//
//  DDITDataSource.m
//  InstaTags
//
//  Created by Dmitriy Demchenko on 9/25/15.
//  Copyright (c) 2015 Dmitriy Demchenko. All rights reserved.
//

#import "DDPostsDataSource.h"
#import "DDDataManager.h"

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

- (NSUInteger)numberOfModels {
    return [DDModel MR_countOfEntities];
}

- (DDModel *)modelForIndex:(NSInteger)index {
    return self.fetchedResultsController.fetchedObjects[index];
}

- (void)removeModelAtIndex:(NSIndexPath *)indexPath {
    DDModel *postToRemove = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [postToRemove MR_deleteEntity];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

- (void)requestPostWithTag:(NSString *)tag completion:(SuccessBlock)completion {
    [[DDDataManager sharedManager] postsWithTag:tag completion:^(BOOL success, id responseObject, NSError *error) {
        if (tag && success) {
            completion(success);
        }
    }];
}

#pragma mark - NSFetchedResultsControllerDelegate

//- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
//#warning не понял, зачем нужно заново переконфигурировать контроллер
//    [self setupFetchedResultsController];
//}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    [self.delegate contentWasChangedAtIndexPath:indexPath forChangeType:type newIndexPath:newIndexPath];
}

@end