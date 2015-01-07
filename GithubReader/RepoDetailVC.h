//
//  RepoDetailVC.h
//  GithubReader
//
//  Created by Joseph Daryl Locsin on 1/7/15.
//  Copyright (c) 2015 OxygenVentures. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Repo;

@interface RepoDetailVC : UITableViewController

@property (strong, nonatomic) Repo *chosenRepo;

@end