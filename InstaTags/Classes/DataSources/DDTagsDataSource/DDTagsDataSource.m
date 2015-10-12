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

#pragma mark - Initialization

- (instancetype)initWithDelegate:(id<DDTagsDataSourceDelegate>)delegate {
    self = [self init];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

#pragma mark - Public methods

- (void)requestForTagsByName:(NSString *)name {
    __weak typeof(self) weakSelf = self;
    [[DDDataManager sharedManager] tagsByName:name completion:^(BOOL success, id responseObject, NSError *error) {
        if (success) {
            weakSelf.tagsArray = responseObject;
            [weakSelf.delegate dataWasChanged:self];
        }
    }];
}

- (NSUInteger)countTags {
    return [self.tagsArray count];
}

- (NSString *)tagForIndex:(NSInteger)index {
    return self.tagsArray[index];
}

@end