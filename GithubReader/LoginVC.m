//
//  LoginVC.m
//  GithubReader
//
//  Created by Joseph Daryl Locsin on 1/7/15.
//  Copyright (c) 2015 OxygenVentures. All rights reserved.
//

#import "LoginVC.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "Webservice.h"
#import "Utils.h"

// ************************************
// ZERO THIS ON RELEASE
// ************************************
#define DEBUG_AUTH 0
// ************************************

@interface LoginVC ()
{
    MBProgressHUD *_hud;
}
@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            // brand
            return 236.f;
            break;
        case 1:
            // username
            return 89.f;
            break;
        case 2:
            // password
            return 89.f;
            break;
        case 3:
            // login button
            return 54.f;
            break;
        default:
            return 44.f;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    switch (indexPath.row) {
        case 0:
            // brand
            cell = [tableView dequeueReusableCellWithIdentifier:@"brand"];
            
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"brand"];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        case 1:
            // username
            cell = [tableView dequeueReusableCellWithIdentifier:@"username"];
            
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"username"];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        case 2:
            // password
            cell = [tableView dequeueReusableCellWithIdentifier:@"password"];
            
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"password"];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        case 3:
            // login button
            cell = [tableView dequeueReusableCellWithIdentifier:@"login"];
            
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"login"];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor lightGrayColor];
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3) {
        // user tried logging in
        self.tableView.userInteractionEnabled = NO;
        
        UITableViewCell *username = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        UITableViewCell *password = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        UITextField *userfield = (UITextField *)[username.contentView viewWithTag:1001];
        UITextField *passfield = (UITextField *)[password.contentView viewWithTag:1001];
        
        NSString *userValue = userfield.text;
        NSString *passValue = passfield.text;

#if DEBUG_AUTH
        if ([userValue length] == 0 || [userValue length] == 0) {
            userValue = @"SUPPLY_USERNAME";
            passValue = @"SUPPLY_PASSWORD";
        }
#endif
        
        if ([userValue length] > 0 && [passValue length] > 0) {
            [self showHUD];
            [Webservice requestAuthenticationWithUsername:userValue password:passValue andHandler:^(NSString *authToken, BOOL didSucceed) {
                
                if (didSucceed) {
                    // save token
                    [[NSUserDefaults standardUserDefaults] setObject:authToken forKey:@"authToken"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    [self dismissHUD];
                    [self dismissViewControllerAnimated:YES completion:nil];
                } else {
                    [self dismissHUD];
                    self.tableView.userInteractionEnabled = YES;
                    [Utils showAlertWithTitle:@"LOGIN FAILED" andMessage:@"Please try again later."];
                }
            }];
        } else {
            self.tableView.userInteractionEnabled = YES;
            [Utils showAlertWithTitle:@"LOGIN FAILED" andMessage:@"Please supply all fields."];
        }
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

@end
