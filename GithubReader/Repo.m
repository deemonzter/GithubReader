//
//  Repo.m
//  GithubReader
//
//  Created by Joseph Daryl Locsin on 1/8/15.
//  Copyright (c) 2015 OxygenVentures. All rights reserved.
//

#import "Repo.h"
#import "Utils.h"

@implementation Repo

@dynamic default_branch;
@dynamic desc;
@dynamic name;
@dynamic git_url;
@dynamic created_at;
@dynamic updated_at;
@dynamic watchers_count;
@dynamic open_issues_count;
@dynamic forks;
@dynamic owner;

+ (BOOL)insertRepoWithDictionary:(NSDictionary *)dict andContext:(NSManagedObjectContext *)context {
    Repo *repo = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    repo.default_branch = dict[@"default_branch"];
    repo.desc = dict[@"description"];
    repo.name = dict[@"name"];
    repo.git_url = dict[@"git_url"];
    repo.created_at = [Utils dateFromString:dict[@"created_at"]];
    repo.updated_at = [Utils dateFromString:dict[@"updated_at"]];
    repo.watchers_count = dict[@"watchers_count"];
    repo.open_issues_count = dict[@"open_issues_count"];
    repo.forks = dict[@"forks"];
    repo.owner = [dict[@"owner"] objectForKey:@"login"];
    
    NSError *error = nil;
    if ([context save:&error]) {
        return YES;
    } else {
        NSLog(@"Failed to insert current user");
        return NO;
    }
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.default_branch = dict[@"default_branch"];
        self.desc = dict[@"desc"];
        self.name = dict[@"name"];
        self.git_url = dict[@"git_url"];
        self.created_at = dict[@"created_at"];
        self.updated_at = dict[@"updated_at"];
        self.watchers_count = dict[@"watchers_count"];
        self.open_issues_count = dict[@"open_issues_count"];
        self.forks = dict[@"forks"];
        self.owner = [dict[@"owner"] objectForKey:@"login"];
    }
    return self;
}

- (id)init {
    return [self initWithDictionary:nil];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"branch:%@\ndesc:%@\nname:%@\ngit:%@\ncreated:%@\nupdated:%@\nwatchers:%@\nopen issues:%@\nforks:%@\nowner:%@", self.default_branch, self.desc, self.name, self.git_url, self.created_at, self.updated_at, self.watchers_count, self.open_issues_count, self.forks, self.owner];
}

@end