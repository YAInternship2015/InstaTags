//
//  DDTagsDataSource.m
//  InstaTags
//
//  Created by Dmitriy Demchenko on 10/12/15.
//  Copyright (c) 2015 Dmitriy Demchenko. All rights reserved.
//

#import "DDTagsDataSource.h"
#import "DDDataManager.h"

@interface DDTagsDataSource ()

@property (nonatomic, strong) NSArray *tagsArray;

@end

@implementation DDTagsDataSource

#pragma mark - Init

- (instancetype)initWithDelegate:(id<DDTagsDataSourceDelegate>)delegate {
    self = [self init];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

#pragma mark - Public methods

- (void)requestTagsListWithName:(NSString *)name {
    __weak typeof(self) weakSelf = self;
    [[DDDataManager sharedManager] tagsByName:name completion:^(BOOL success, id responseObject, NSError *error) {
        if (success) {
            weakSelf.tagsArray = responseObject;
            [weakSelf.delegate dataSourceDidUpdateContent:self];
        }
    }];
}

- (NSUInteger)objectsCount {
    return [self.tagsArray count];
}

- (NSString *)tagAtIndex:(NSInteger)index {
    return self.tagsArray[index];
}

@end