//
//  DDCollectionViewController.m
//  InstaTags
//
//  Created by Dmitriy Demchenko on 9/25/15.
//  Copyright (c) 2015 Dmitriy Demchenko. All rights reserved.
//

#import "DDCollectionViewController.h"
#import "DDITCollectionViewCell.h"
#import "DDPostsDataSource.h"
#import "SVPullToRefresh.h"

static CGFloat const durationAnimationDeleteCell = 0.3f;

@interface DDCollectionViewController () <DDPostsDataSourceDelegate>

@property (nonatomic, strong) DDPostsDataSource *dataSource;

@end


@implementation DDCollectionViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = [[DDPostsDataSource alloc] initWithDelegate:self];
    [self setupLoadersCallback];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataSource objectsCount];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DDITCollectionViewCell *cell = (DDITCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([DDITCollectionViewCell class]) forIndexPath:indexPath];
    [cell configWithPostModel:[self.dataSource modelAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat widthOfScreen = CGRectGetWidth([UIScreen mainScreen].bounds);
    return CGSizeMake(widthOfScreen, widthOfScreen + 1.f); // 1px for separator (gray line)
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
                [weakSelf.dataSource removeModelAtIndex:indexPath]; 
            } completion:nil];
        }];
    }
}

#pragma mark - Private methods

- (void)setupLoadersCallback {
    __weak typeof(self) weakSelf = self;
    [self.collectionView addPullToRefreshWithActionHandler:^{
        [weakSelf.dataSource refreshPostsWithCompletion:nil];
    }];
    [self.collectionView addInfiniteScrollingWithActionHandler:^{
        [weakSelf.dataSource requestPostsWithTag:nil completion:nil];
    }];
}

@end