//
//  DDITDataSource.h
//  InstaTags
//
//  Created by Dmitriy Demchenko on 9/25/15.
//  Copyright (c) 2015 Dmitriy Demchenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DDModel;

@protocol DDPostsDataSourceDelegate;

typedef void (^SuccessBlock)(BOOL success);

@interface DDPostsDataSource : NSObject

@property (nonatomic, weak) id<DDPostsDataSourceDelegate>delegate;

- (instancetype)initWithDelegate:(id<DDPostsDataSourceDelegate>)delegate;
- (NSUInteger)objectsCount;
- (DDModel *)modelAtIndex:(NSInteger)index;
- (void)removeModelAtIndex:(NSIndexPath *)indexPath;
- (void)requestPostsWithTag:(NSString *)tag completion:(SuccessBlock)completion;
- (void)refreshPostsWithCompletion:(SuccessBlock)completion;

@end


@protocol DDPostsDataSourceDelegate <NSObject>

@optional
- (void)dataSourceDidUpdateContent;

@end