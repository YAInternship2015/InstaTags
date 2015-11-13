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
- (NSUInteger)numberOfModels;
- (DDModel *)modelForIndex:(NSInteger)index;
- (void)removeModelAtIndex:(NSIndexPath *)indexPath;
- (void)requestPostWithTag:(NSString *)tag completion:(SuccessBlock)completion;
- (void)refreshPostWithCompletion:(SuccessBlock)completion;

@end


@protocol DDPostsDataSourceDelegate <NSObject>

@optional
- (void)contentWasChanged;

@end