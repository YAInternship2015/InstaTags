//
//  DDITDataSource.h
//  InstaTags
//
//  Created by Dmitriy Demchenko on 9/25/15.
//  Copyright (c) 2015 Dmitriy Demchenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DDPostsDataSourceDelegate;


@interface DDPostsDataSource : NSObject

@property (nonatomic, weak) id<DDPostsDataSourceDelegate>delegate;

- (instancetype)initWithDelegate:(id<DDPostsDataSourceDelegate>)delegate;
- (NSUInteger)numberOfModels;
- (DDModel *)modelForIndex:(NSInteger)index;
- (void)removeModelAtIndex:(NSIndexPath *)indexPath;
//#warning в здесь лучше не get, а load или request. Get подразумевает мгновенную операцию, в load или request - длительную
- (void)requestNextImagePack;

@end


@protocol DDPostsDataSourceDelegate <NSObject>

@required
- (void)contentWasChangedAtIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath;

@end