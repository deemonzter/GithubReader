//
//  User.h
//  GithubReader
//
//  Created by Joseph Daryl Locsin on 1/8/15.
//  Copyright (c) 2015 OxygenVentures. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSString * avatar_url;
@property (nonatomic, retain) NSString * blog;
@property (nonatomic, retain) NSString * company;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * login;
@property (nonatomic, retain) NSNumber * private_gists;
@property (nonatomic, retain) NSNumber * public_gists;
@property (nonatomic, retain) NSNumber * public_repos;
@property (nonatomic, retain) NSNumber * total_private_repos;

+ (BOOL)insertUserWithDictionary:(NSDictionary *)dict andContext:(NSManagedObjectContext *)context;

@end