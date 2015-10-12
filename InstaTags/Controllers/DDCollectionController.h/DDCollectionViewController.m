//
//  DDCollectionViewController.m
//  InstaTags
//
//  Created by Dmitriy Demchenko on 9/25/15.
//  Copyright (c) 2015 Dmitriy Demchenko. All rights reserved.
//

#import "DDCollectionViewController.h"
#import "DDITCollectionViewCell.h"
#import "DDITDataSource.h"

@interface DDCollectionViewController () <DDITDataSourceDelegate>

@property (nonatomic, strong) DDITDataSource *dataSource;

@end


static CGFloat const durationAnimationDeleteCell = 0.3f;

@implementation DDCollectionViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = [[DDITDataSource alloc] initWithDelegate:self];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataSource numberOfModels];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DDITCollectionViewCell *cell = (DDITCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([DDITCollectionViewCell class]) forIndexPath:indexPath];
    [cell configWithPostModel:[self.dataSource modelForIndex:indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [self.dataSource numberOfModels] - 1) {
        [self.dataSource requestNextImagePack];
    }
}

#pragma mark - UICollectionViewDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat widthOfScreen = CGRectGetWidth([UIScreen mainScreen].bounds);
    return CGSizeMake(widthOfScreen, widthOfScreen + 1.f); // 1px for separator (gray line)
}

#pragma mark - DDModelsDataSourceDelegate

- (void)contentWasChangedAtIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    if (type == NSFetchedResultsChangeInsert) {
        [self.collectionView insertItemsAtIndexPaths:@[newIndexPath]];
    } else if (type == NSFetchedResultsChangeDelete) {
        [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } else {
        [self.collectionView reloadData];
    }
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

@end