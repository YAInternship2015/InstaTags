//
//  DDTableViewDataSource.m
//  InstaTags
//
//  Created by Dmitriy Demchenko on 11/13/15.
//  Copyright © 2015 Dmitriy Demchenko. All rights reserved.
//

#import "DDTableViewDataSource.h"
#import "DDPostsDataSource.h"
#import "DDITTableViewCell.h"
#import "SVPullToRefresh.h"

static NSString *const InstagramCellIdentifier = @"InstagramCellIdentifier";

@interface DDTableViewDataSource () <DDPostsDataSourceDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) DDPostsDataSource *dataSource;

@end

@implementation DDTableViewDataSource

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (self) {
        self.dataSource = [[DDPostsDataSource alloc] initWithDelegate:self];
    }
    return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource objectsCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DDITTableViewCell *cell = (DDITTableViewCell *)[tableView dequeueReusableCellWithIdentifier:InstagramCellIdentifier forIndexPath:indexPath];
    [cell configWithPostModel:[self.dataSource modelAtIndex:indexPath.row]];
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

//#pragma mark - DDPostsDataSourceDelegate
//
//- (void)dataSourceDidUpdateContent {
//    [self.tableView reloadData];
//}

@end