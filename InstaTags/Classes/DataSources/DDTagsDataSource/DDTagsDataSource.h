//
//  DDTagsDataSource.h
//  InstaTags
//
//  Created by Dmitriy Demchenko on 10/12/15.
//  Copyright (c) 2015 Dmitriy Demchenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DDTagsDataSourceDelegate;

@interface DDTagsDataSource : NSObject

@property (nonatomic, weak) id <DDTagsDataSourceDelegate> delegate;

- (instancetype)initWithDelegate:(id<DDTagsDataSourceDelegate>)delegate;

- (void)requestTagsListWithName:(NSString *)name;
- (NSUInteger)objectsCount;
- (NSString *)tagAtIndex:(NSInteger)index;

@end

@protocol DDTagsDataSourceDelegate <NSObject>

@required
- (void)dataSourceDidUpdateContent:(DDTagsDataSource *)dataSource;

@end