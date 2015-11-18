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

@property (nonatomic, weak) IBOutlet id<DDPostsDataSourceDelegate>delegate;

- (void)requestPostsWithTag:(NSString *)tag completion:(SuccessBlock)completion;
- (void)refreshPostsWithCompletion:(SuccessBlock)completion;
- (void)removeModelAtIndex:(NSIndexPath *)indexPath;

@end

@protocol DDPostsDataSourceDelegate <NSObject>

@optional
- (void)dataSourceDidUpdateContent;

@end