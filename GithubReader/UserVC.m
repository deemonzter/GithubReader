//
//  UserVC.m
//  GithubReader
//
//  Created by Joseph Daryl Locsin on 1/7/15.
//  Copyright (c) 2015 OxygenVentures. All rights reserved.
//

#import "UserVC.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "Webservice.h"
#import "Utils.h"
#import "User.h"

@interface UserVC() <UIAlertViewDelegate>
{
    User *_user;
    MBProgressHUD *_hud;
}
@end

@implementation UserVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"User Info";
    
    UIBarButtonItem *rightNavButton = [[UIBarButtonItem alloc] initWithTitle:@"Fetch" style:UIBarButtonItemStylePlain target:self action:@selector(confirmRefetch)];
    self.navigationItem.rightBarButtonItem = rightNavButton;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getCurrentUserAndReloadTableIfNecessary];
}

#pragma mark - Private Methods

- (void)confirmRefetch {
    // ask user if that's what he/she really wants
    NSString *appropriateMsg = _user ? @"Fetching will replace existing stored user info." : @"Fetching will store user's info locally.";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:appropriateMsg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"I understand", nil];
    alert.tag = 1001;
    [alert show];
}

- (void)refetchUserInfo {
    NSLog(@"starting refetch...");
    [self showHUD];
    [self removeUserInfoFromDB];
    [Webservice requestUserInfoWithHandler:^(NSDictionary *userInfo, BOOL didSucceed) {
        NSLog(@"finished refetch...");
        [self dismissHUD];
        
        if (didSucceed) {
            [self saveUserInfoAsManagedObject:userInfo withSuccess:^{
                [self getCurrentUserAndReloadTableIfNecessary];
            }];
        } else {
            [Utils showAlertWithTitle:@"Service Failed" andMessage:@"Cannot get user info at this time."];
        }
    }];
}

- (void)getCurrentUserAndReloadTableIfNecessary {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([User class])];
    NSError *error = nil;
    NSArray *result = [self.context executeFetchRequest:request error:&error];
    
    if (result) {
        id userObject = [result firstObject];
        
        if ([userObject isKindOfClass:[User class]]) {
            _user = (User *)userObject;
            [self.tableView reloadData];
        }
    } else {
        NSLog(@"No user to display.");
    }
}

- (void)saveUserInfoAsManagedObject:(NSDictionary *)userInfo withSuccess:(void (^)())successBlock {
    BOOL result = [User insertUserWithDictionary:userInfo andContext:self.context];
    
    if (result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            successBlock();
        });
    }
}

- (void)removeUserInfoFromDB {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"User" inManagedObjectContext:self.context]];
    [request setIncludesPropertyValues:NO];
    
    NSError * error = nil;
    NSArray * users = [self.context executeFetchRequest:request error:&error];
    
    for (NSManagedObject * user in users) {
        [self.context deleteObject:user];
    }
    
    NSError *saveError = nil;
    if ([self.context save:&saveError]) {
        NSLog(@"Successfully removed User from DB");
    } else {
        NSLog(@"Failed to remove User from DB");
    }
}

#pragma mark - UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // cancel
        NSLog(@"Cancelled refetch.");
    } else if (buttonIndex == 1) {
        // confirmed
        [self refetchUserInfo];
    }
}

#pragma mark - MBProgressHUD Methods

- (void)showHUD {
    if (!_hud) {
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _hud.mode = MBProgressHUDModeIndeterminate;
        _hud.labelText = @"Loading";
    }
}

- (void)dismissHUD {
    if (_hud) {
        [_hud hide:YES];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CELL_ID = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CELL_ID];
    }
    
    NSString *textLabel = @"";
    NSString *detailTextLabel = @"";
    
    switch (indexPath.row) {
        case 0:
            // name
            textLabel = _user.name;
            detailTextLabel = @"Account name";
            break;
        case 1:
            // email
            textLabel = _user.email;
            detailTextLabel = @"Email address";
            break;
        case 2:
            // location
            textLabel = _user.location;
            detailTextLabel = @"User's location";
            break;
        case 3:
            // company
            textLabel = _user.company;
            detailTextLabel = @"User's company";
            break;
        case 4:
            // public repos
            textLabel = [_user.public_repos stringValue];
            detailTextLabel = @"Number of public repositories";
            break;
        case 5:
            // private repos
            textLabel = [_user.total_private_repos stringValue];
            detailTextLabel = @"Number of private repositories";
            break;
        case 6:
            // public gists
            textLabel = [_user.public_gists stringValue];
            detailTextLabel = @"Number of public gists";
            break;
        case 7:
            // private repos
            textLabel = [_user.private_gists stringValue];
            detailTextLabel = @"Number of private gists";
            break;
        default:
            break;
    }
    
    cell.textLabel.text = textLabel;
    if ([textLabel length] > 0) {
        cell.detailTextLabel.text = detailTextLabel;
    }
    
    return cell;
}

@end
