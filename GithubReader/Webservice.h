//
//  Webservice.h
//  GithubReader
//
//  Created by Joseph Daryl Locsin on 1/7/15.
//  Copyright (c) 2015 OxygenVentures. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Webservice : NSObject

+ (void)requestAuthenticationWithUsername:(NSString *)username
                                 password:(NSString *)password
                               andHandler:(void (^)(NSString *authToken, BOOL didSucceed))handler;

+ (void)requestUserInfoWithHandler:(void (^)(NSDictionary *userInfo, BOOL didSucceed))handler;

+ (void)requestAllRepositoriesWithHandler:(void (^)(NSArray *repos, BOOL didSucceed))handler;

@end