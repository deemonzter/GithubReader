//
//  ViewController.m
//  GithubReader
//
//  Created by Joseph Daryl Locsin on 1/7/15.
//  Copyright (c) 2015 OxygenVentures. All rights reserved.
//

#import "ViewController.h"
@import CoreData;
#import <MBProgressHUD/MBProgressHUD.h>
#import "Webservice.h"
#import "Utils.h"
#import "UserVC.h"
#import "RepoListVC.h"

@interface ViewController ()
{
    MBProgressHUD *_hud;
}
@end

@implementation ViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    if (self.context) {
        NSLog(@"Context successfully injected.");
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSString *authToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"authToken"];
    
    if ([authToken length] > 0) {
        NSLog(@"[ROOTVC] Retrieved current user. Continuing session...");
    } else {
        NSLog(@"[ROOTVC] No login found. Going to Login screen...");
        [self performSegueWithIdentifier:@"modalLogin" sender:self];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showUser"]) {
        UserVC *userVC = segue.destinationViewController;
        userVC.context = self.context;
    } else if ([segue.identifier isEqualToString:@"showRepoList"]) {
        RepoListVC *repoListVC = segue.destinationViewController;
        repoListVC.context = self.context;
    }
}

#pragma mark - IBActions

- (IBAction)tappedUserInfo:(id)sender {
    [self performSegueWithIdentifier:@"showUser" sender:self];
}

- (IBAction)tappedRepositories:(id)sender {
    [self performSegueWithIdentifier:@"showRepoList" sender:self];
}

- (IBAction)tappedLogout:(id)sender {
    // remove user token
    [self showHUD];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"authToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // remove user data
    [self removeUserInfoFromDB];
    [self removeRepositoriesFromDB];
    
    [self dismissHUD];
    [self performSegueWithIdentifier:@"modalLogin" sender:self];
}

#pragma mark - Private Methods

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

- (void)removeRepositoriesFromDB {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Repo" inManagedObjectContext:self.context]];
    [request setIncludesPropertyValues:NO];
    
    NSError * error = nil;
    NSArray * repos = [self.context executeFetchRequest:request error:&error];
    
    for (NSManagedObject * repo in repos) {
        [self.context deleteObject:repo];
    }
    
    NSError *saveError = nil;
    if ([self.context save:&saveError]) {
        NSLog(@"Successfully removed all Repos from DB");
    } else {
        NSLog(@"Failed to remove all Repos from DB");
    }
}

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