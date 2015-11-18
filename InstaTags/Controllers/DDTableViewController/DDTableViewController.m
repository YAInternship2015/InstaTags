//
//  DDTableViewController.m
//  InstaTags
//
//  Created by Dmitriy Demchenko on 9/26/15.
//  Copyright (c) 2015 Dmitriy Demchenko. All rights reserved.
//

#import "DDTableViewController.h"
#import "DDPostsDataSource.h"
#import "SVPullToRefresh.h"

@interface DDTableViewController () <DDPostsDataSourceDelegate>

@property (strong, nonatomic) IBOutlet DDPostsDataSource *postsDataSource;

@end

@implementation DDTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLoadersCallback];
}

#pragma mark - DDITDataSourceDelegate

- (void)dataSourceDidUpdateContent {
    [self.tableView reloadData];
    [self.tableView.pullToRefreshView stopAnimating];
    [self.tableView.infiniteScrollingView stopAnimating];
}

#pragma mark - Private methods

- (void)setupLoadersCallback {
    __weak typeof(self) weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf.postsDataSource refreshPostsWithCompletion:nil];
    }];
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf.postsDataSource requestPostsWithTag:nil completion:nil];
    }];
}

@end