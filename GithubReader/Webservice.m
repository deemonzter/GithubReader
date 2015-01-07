//
//  Webservice.m
//  GithubReader
//
//  Created by Joseph Daryl Locsin on 1/7/15.
//  Copyright (c) 2015 OxygenVentures. All rights reserved.
//

#import "Webservice.h"

#define URL_API @"https://api.github.com"

@implementation Webservice

#pragma mark - Accessors

+ (NSURL *)apiURL {
    return [NSURL URLWithString:URL_API];
}

+ (NSString *)authToken {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"authToken"];
}

#pragma mark - Public Methods

+ (void)requestAuthenticationWithUsername:(NSString *)username password:(NSString *)password andHandler:(void (^)(NSString *authToken, BOOL didSucceed))handler {
    NSURL *url = [[self apiURL] URLByAppendingPathComponent:@"/user"];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", username, password];
    NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authValue = [NSString stringWithFormat: @"Basic %@",[authData base64EncodedStringWithOptions:0]];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    [self makeDataRequest:request withHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpRes = (NSHTTPURLResponse *)response;
        
        if (httpRes.statusCode == 200) {
            dispatch_async(dispatch_get_main_queue(), ^{
                handler(authValue, YES);
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                handler(nil, NO);
            });
        }
    }];
}

+ (void)requestUserInfoWithHandler:(void (^)(NSDictionary *userInfo, BOOL didSucceed))handler {
    // only works when user is authenticated
    if ([[self authToken] length] == 0) {
        NSLog(@"[Webservice] authToken missing!");
        return;
    }
    
    NSURL *url = [[self apiURL] URLByAppendingPathComponent:@"/user"];
    [self authenticatedDataRequestWithURL:url andHandler:handler];
}

+ (void)requestAllRepositoriesWithHandler:(void (^)(NSArray *repos, BOOL didSucceed))handler {
    // only works when the user is authenticated
    if ([[self authToken] length] == 0) {
        NSLog(@"[Webservice] authToken missing!");
        return;
    }
    
    NSURL *url = [[self apiURL] URLByAppendingPathComponent:@"/user/repos"];
    [self authenticatedDataRequestWithURL:url andHandler:handler];
}

#pragma mark - Private Methods

+ (void)authenticatedDataRequestWithURL:(NSURL *)url andHandler:(void (^)(id object, BOOL didSucceed))handler {
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:[self authToken] forHTTPHeaderField:@"Authorization"];
    
    [self makeDataRequest:request withHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpRes = (NSHTTPURLResponse *)response;
        
        if (httpRes.statusCode == 200) {
            NSLog(@"[Webservice] Login Successful.");
            NSError *err = nil;
            id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
            
            if (err) {
                NSLog(@"[Webservice] Something wrong with parsing the data...");
                dispatch_async(dispatch_get_main_queue(), ^{
                    handler(nil, NO);
                });
            } else {
                NSLog(@"[Webservice] Data received: %@", jsonObject);
                dispatch_async(dispatch_get_main_queue(), ^{
                    handler(jsonObject, YES);
                });
            }
        } else {
            NSLog(@"[Webservice] status code %d", (int)httpRes.statusCode);
            dispatch_async(dispatch_get_main_queue(), ^{
                handler(nil, NO);
            });
        }
    }];
}
        
+ (void)makeDataRequest:(NSURLRequest *)request withHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))handler {
    NSURLSessionDataTask* task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:handler];
    [task resume];
}

@end