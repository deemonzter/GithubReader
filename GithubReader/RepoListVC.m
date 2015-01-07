//
//  RepoListVC.m
//  GithubReader
//
//  Created by Joseph Daryl Locsin on 1/7/15.
//  Copyright (c) 2015 OxygenVentures. All rights reserved.
//

#import "RepoListVC.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "Webservice.h"
#import "Utils.h"
#import "Repo.h"
#import "RepoDetailVC.h"

@interface RepoListVC ()
{
    MBProgressHUD *_hud;
    NSArray *_repos;
    Repo *_selectedRepo;
}
@end

@implementation RepoListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Repositories";
    
    UIBarButtonItem *rightNavButton = [[UIBarButtonItem alloc] initWithTitle:@"Fetch" style:UIBarButtonItemStylePlain target:self action:@selector(confirmRefetch)];
    self.navigationItem.rightBarButtonItem = rightNavButton;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getCurrentRepositoriesAndReloadTableIfNecessary];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showRepoDetail"]) {
        RepoDetailVC *repoDetailVC = segue.destinationViewController;
        repoDetailVC.chosenRepo = _selectedRepo;
    }
}

#pragma mark - Private Methods

- (void)confirmRefetch {
    // ask user if that's what he/she really wants
    NSString *appropriateMsg = [_repos count] > 0 ? @"Fetching will replace existing stored repositories." : @"Fetching will store repositories locally.";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:appropriateMsg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"I understand", nil];
    alert.tag = 1001;
    [alert show];
}

- (void)refetchUserInfo {
    NSLog(@"starting refetch...");
    [self showHUD];
    [self removeRepositoriesFromDB];
    [Webservice requestAllRepositoriesWithHandler:^(NSArray *repos, BOOL didSucceed) {
        NSLog(@"finished refetch...");
        [self dismissHUD];
        
        if (didSucceed) {
            [self saveRepositoriesAsManagedObject:repos withSuccess:^{
                [self getCurrentRepositoriesAndReloadTableIfNecessary];
            }];
        } else {
            [Utils showAlertWithTitle:@"Service Failed" andMessage:@"Cannot get repositories at this time."];
        }
    }];
}

- (void)getCurrentRepositoriesAndReloadTableIfNecessary {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([Repo class])];
    NSError *error = nil;
    NSArray *result = [self.context executeFetchRequest:request error:&error];
    
    if (result) {
        _repos = result;
        [self.tableView reloadData];
    }
}

- (void)saveRepositoriesAsManagedObject:(NSArray *)repoList withSuccess:(void (^)())successBlock {
    int count = 0;
    for (NSDictionary *repo in repoList) {
        BOOL result = [Repo insertRepoWithDictionary:repo andContext:self.context];
        
        if (result) {
            count++;
        }
    }
    
    if (count > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            successBlock();
        });
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
    return [_repos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CELL_ID = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CELL_ID];
    }
    
    Repo *repo = (Repo *)_repos[indexPath.row];
    cell.textLabel.text = repo.name;
    cell.detailTextLabel.text = repo.desc;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _selectedRepo = (Repo *)_repos[indexPath.row];
    [self performSegueWithIdentifier:@"showRepoDetail" sender:self];
}

@end