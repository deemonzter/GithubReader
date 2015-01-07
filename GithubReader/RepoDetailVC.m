//
//  RepoDetailVC.m
//  GithubReader
//
//  Created by Joseph Daryl Locsin on 1/7/15.
//  Copyright (c) 2015 OxygenVentures. All rights reserved.
//

#import "RepoDetailVC.h"
#import "Repo.h"
#import "Utils.h"

@interface RepoDetailVC ()

@end

@implementation RepoDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [self.chosenRepo.name length] > 0 ? self.chosenRepo.name : @"Repo Detail";
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
            textLabel = self.chosenRepo.name;
            detailTextLabel = @"Repository name";
            break;
        case 1:
            // desc
            textLabel = self.chosenRepo.desc;
            detailTextLabel = @"Repository description";
            break;
        case 2:
            // default branch
            textLabel = self.chosenRepo.default_branch;
            detailTextLabel = @"Default branch";
            break;
        case 3:
            // git url
            textLabel = self.chosenRepo.git_url;
            detailTextLabel = @"Git URL";
            break;
        case 4:
            // created at
            textLabel = [Utils prettyStringFromDate:self.chosenRepo.created_at];
            detailTextLabel = @"Date when this repository was created";
            break;
        case 5:
            // owner
            textLabel = self.chosenRepo.owner;
            detailTextLabel = @"Owner of this repository";
            break;
        case 6:
            // forks
            textLabel = [self.chosenRepo.forks stringValue];
            detailTextLabel = @"Number of times this repository was forked";
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