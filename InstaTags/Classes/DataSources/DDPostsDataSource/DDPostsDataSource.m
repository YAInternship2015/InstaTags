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

@interface DDPostsDataSource () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end


@implementation DDPostsDataSource

#pragma mark - Lifecycle

- (instancetype)initWithDelegate:(id<DDPostsDataSourceDelegate>)delegate {
    self = [super init];
    if (self) {
        self.delegate = delegate;
        [self setupFetchedResultsController];
    }
    return self;
}

#pragma mark - DataSource methods

- (void)setupFetchedResultsController {
    self.fetchedResultsController = [DDModel MR_fetchAllSortedBy:kSavedDate ascending:YES withPredicate:nil groupBy:nil delegate:self];
}

- (NSUInteger)objectsCount {
    return [DDModel MR_countOfEntities];
}

- (DDModel *)modelAtIndex:(NSInteger)index {
    return self.fetchedResultsController.fetchedObjects[index];
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
            [DDModel MR_deleteAllMatchingPredicate:predicate inContext:[NSManagedObjectContext MR_defaultContext]];
        }
    }];
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.delegate dataSourceDidUpdateContent];
}

@end