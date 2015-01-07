//
//  Repo.h
//  GithubReader
//
//  Created by Joseph Daryl Locsin on 1/8/15.
//  Copyright (c) 2015 OxygenVentures. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Repo : NSManagedObject

@property (nonatomic, retain) NSString * default_branch;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * git_url;
@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSDate * updated_at;
@property (nonatomic, retain) NSNumber * watchers_count;
@property (nonatomic, retain) NSNumber * open_issues_count;
@property (nonatomic, retain) NSNumber * forks;
@property (nonatomic, retain) NSString * owner;

+ (BOOL)insertRepoWithDictionary:(NSDictionary *)dict andContext:(NSManagedObjectContext *)context;

@end