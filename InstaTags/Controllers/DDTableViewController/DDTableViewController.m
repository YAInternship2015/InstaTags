//
//  DDTableViewController.m
//  InstaTags
//
//  Created by Dmitriy Demchenko on 9/26/15.
//  Copyright (c) 2015 Dmitriy Demchenko. All rights reserved.
//

#import "DDTableViewController.h"
#import "DDITTableViewCell.h"
#import "DDPostsDataSource.h"
#import "SVPullToRefresh.h"

static NSString *const InstagramCellIdentifier = @"InstagramCellIdentifier";

@interface DDTableViewController () <DDPostsDataSourceDelegate>

@property (nonatomic, strong) DDPostsDataSource *dataSource;

@end

@implementation DDTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = [[DDPostsDataSource alloc] initWithDelegate:self];
    [self setupLoadersCallback];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource numberOfModels];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DDITTableViewCell *cell = (DDITTableViewCell *)[tableView dequeueReusableCellWithIdentifier:InstagramCellIdentifier forIndexPath:indexPath];
    [cell configWithPostModel:[self.dataSource modelForIndex:indexPath.row]];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [tableView beginUpdates];
        [self.dataSource removeModelAtIndex:indexPath];
        [tableView endUpdates];
    }
}

#pragma mark - DDITDataSourceDelegate

- (void)contentWasChanged {
    [self.tableView reloadData];
    [self.tableView.pullToRefreshView stopAnimating];
    [self.tableView.infiniteScrollingView stopAnimating];
}

#pragma mark - Private methods

- (void)setupLoadersCallback {
    __weak typeof(self) weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf.dataSource refreshPostWithCompletion:nil];
    }];
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf.dataSource requestPostWithTag:nil completion:nil];
    }];
}

@end