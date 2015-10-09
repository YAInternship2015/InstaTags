//
//  NSArray+ObjectMapping.m
//  InstaTags
//
//  Created by Dmitriy Demchenko on 9/25/15.
//  Copyright (c) 2015 Dmitriy Demchenko. All rights reserved.
//

#import "NSArray+ObjectMapping.h"
#import "DDNetworkObject.h"

@implementation NSArray (ObjectMapping)

+ (instancetype)initWithArrayForMapping:(NSArray *)inputArray objectsClass:(Class)objectClass {
    NSMutableArray *mappedArray = [NSMutableArray array];
    [inputArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        DDNetworkObject *networkObject = [[objectClass alloc] init];
        networkObject.objectDictionary = obj;
        [mappedArray addObject:networkObject];
    }];
    return mappedArray;
}

@end