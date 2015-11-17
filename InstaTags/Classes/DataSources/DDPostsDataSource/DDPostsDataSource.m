//
//  DDITDataSource.m
//  InstaTags
//
//  Created by Dmitriy Demchenko on 9/25/15.
//  Copyright (c) 2015 Dmitriy Demchenko. All rights reserved.
//

#import "DDPostsDataSource.h"
#import "DDDataManager.h"
#import "DDModel.h"
#import "DDPostModel.h"
#import "DDITTableViewCell.h"
#import "DDITCollectionViewCell.h"

static NSString *const InstagramCellIdentifier = @"InstagramCellIdentifier";

@interface DDPostsDataSource () <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end


@implementation DDPostsDataSource

#pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupFetchedResultsController];
    }
    return self;
}

#pragma mark - DataSource methods

- (void)setupFetchedResultsController {
    self.fetchedResultsController = [DDModel MR_fetchAllSortedBy:kSavedDate ascending:YES withPredicate:nil groupBy:nil delegate:self];
}

- (void)removeModelAtIndex:(NSIndexPath *)indexPath {
    DDModel *postToRemove = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [postToRemove MR_deleteEntity];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

- (void)requestPostsWithTag:(NSString *)tag completion:(SuccessBlock)completion {
    [[DDDataManager sharedManager] postsWithTag:tag completion:^(BOOL success, id responseObject, NSError *error) {
        if (tag && success) {
            completion(success);
        }
    }];
}

- (void)refreshPostsWithCompletion:(SuccessBlock)completion {
    [[DDDataManager sharedManager] postsWithTag:nil completion:^(BOOL success, id responseObject, NSError *error) {
        if (success) {
            NSArray *array = responseObject[kTagsData];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NOT post_id IN %@", [array valueForKey:@"id"]];
            [DDModel MR_deleteAllMatchingPredicate:predicate];
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
            
        }
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [DDModel MR_countOfEntities];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DDITTableViewCell *cell = (DDITTableViewCell *)[tableView dequeueReusableCellWithIdentifier:InstagramCellIdentifier forIndexPath:indexPath];
    [cell configWithPostModel:self.fetchedResultsController.fetchedObjects[indexPath.row]];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [tableView beginUpdates];
        [self removeModelAtIndex:indexPath];
        [tableView endUpdates];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [DDModel MR_countOfEntities];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DDITCollectionViewCell *cell = (DDITCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([DDITCollectionViewCell class]) forIndexPath:indexPath];
    [cell configWithPostModel:self.fetchedResultsController.fetchedObjects[indexPath.row]];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat widthOfScreen = CGRectGetWidth([UIScreen mainScreen].bounds);
    return CGSizeMake(widthOfScreen, widthOfScreen + 1.f); // 1px for separator (gray line)
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.delegate dataSourceDidUpdateContent];
}

@end