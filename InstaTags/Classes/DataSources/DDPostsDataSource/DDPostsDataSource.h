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
//#warning в здесь лучше не get, а load или request. Get подразумевает мгновенную операцию, в load или request - длительную
//- (void)requestNextPosts;
#warning Оставил один метод для первого запроса постов по тэгу и для получения следующей пачки постов, в даном случае в параметры передаются nil

@end


@protocol DDPostsDataSourceDelegate <NSObject>

#warning Этот метод сделал опциональным, тК он не нужен для контроллера где выполняется первый запрос постов
//@required
@optional
- (void)contentWasChangedAtIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath;

@end