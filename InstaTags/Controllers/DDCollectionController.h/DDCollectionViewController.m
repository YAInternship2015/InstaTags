//
//  DDCollectionViewController.m
//  InstaTags
//
//  Created by Dmitriy Demchenko on 9/25/15.
//  Copyright (c) 2015 Dmitriy Demchenko. All rights reserved.
//

#import "DDCollectionViewController.h"
#import "DDPostsDataSource.h"
#import "SVPullToRefresh.h"

static CGFloat const durationAnimationDeleteCell = 0.3f;

@interface DDCollectionViewController () <DDPostsDataSourceDelegate>

@property (nonatomic, strong) IBOutlet DDPostsDataSource *postsDataSource;

@end

@implementation DDCollectionViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLoadersCallback];
}

#pragma mark - DDModelsDataSourceDelegate

- (void)dataSourceDidUpdateContent {
    [self.collectionView reloadData];
    [self.collectionView.pullToRefreshView stopAnimating];
    [self.collectionView.infiniteScrollingView stopAnimating];
}

#pragma mark - IBactions

- (IBAction)handleLongPressAction:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [sender locationInView:self.collectionView];
        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:durationAnimationDeleteCell animations:^{
            UICollectionViewCell *cell = [weakSelf.collectionView cellForItemAtIndexPath:indexPath];
            cell.layer.transform = CATransform3DMakeRotation(M_PI,1.0,0.0,0.0);;
        } completion:^(BOOL finished) {
            [weakSelf.collectionView performBatchUpdates:^{
                [weakSelf.postsDataSource removeModelAtIndex:indexPath];
            } completion:nil];
        }];
    }
}

#pragma mark - Private methods

- (void)setupLoadersCallback {
    __weak typeof(self) weakSelf = self;
    [self.collectionView addPullToRefreshWithActionHandler:^{
        [weakSelf.postsDataSource refreshPostsWithCompletion:nil];
    }];
    [self.collectionView addInfiniteScrollingWithActionHandler:^{
        [weakSelf.postsDataSource requestPostsWithTag:nil completion:nil];
    }];
}

@end