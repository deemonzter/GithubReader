//
//  User.m
//  GithubReader
//
//  Created by Joseph Daryl Locsin on 1/8/15.
//  Copyright (c) 2015 OxygenVentures. All rights reserved.
//

#import "User.h"


@implementation User

@dynamic avatar_url;
@dynamic blog;
@dynamic company;
@dynamic email;
@dynamic location;
@dynamic name;
@dynamic login;
@dynamic private_gists;
@dynamic public_gists;
@dynamic public_repos;
@dynamic total_private_repos;

+ (BOOL)insertUserWithDictionary:(NSDictionary *)dict andContext:(NSManagedObjectContext *)context {
    User *user = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    user.avatar_url = dict[@"avatar_url"];
    user.blog = dict[@"blog"];
    user.company = dict[@"company"];
    user.email = dict[@"email"];
    user.location = dict[@"location"];
    user.name = dict[@"name"];
    user.login = dict[@"login"];
    user.private_gists = dict[@"private_gists"];
    user.public_gists = dict[@"public_gists"];
    user.public_repos = dict[@"public_repos"];
    user.total_private_repos = dict[@"total_private_repos"];
    
    NSError *error = nil;
    if ([context save:&error]) {
        return YES;
    } else {
        NSLog(@"Failed to insert current user");
        return NO;
    }
}

- (NSString *)description {
    return [NSString stringWithFormat:@"avatar:%@\nblog:%@\ncompany:%@\nemail:%@\nlocation:%@\nname:%@\nlogin:%@\nprivate gists:%@\npublic gists:%@\npublic repos:%@\nprivate repos:%@", self.avatar_url, self.blog, self.company, self.email, self.location, self.name, self.login, self.private_gists, self.public_gists, self.public_repos, self.total_private_repos];
}

@end