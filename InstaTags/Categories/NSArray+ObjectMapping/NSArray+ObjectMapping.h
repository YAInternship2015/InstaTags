//
//  NSArray+ObjectMapping.h
//  InstaTags
//
//  Created by Dmitriy Demchenko on 9/25/15.
//  Copyright (c) 2015 Dmitriy Demchenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (ObjectMapping)

+ (instancetype)initWithArrayForMapping:(NSArray *)inputArray objectsClass:(Class)objectClass;

@end