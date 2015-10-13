//
//  NetworkObject.m
//  InstaTags
//
//  Created by Dmitriy Demchenko on 9/25/15.
//  Copyright (c) 2015 Dmitriy Demchenko. All rights reserved.
//

#import "DDNetworkObject.h"
#import <objc/runtime.h>

#warning Хотелось бы услышать комментарии по моему рукотворному маппингу ))

@implementation DDNetworkObject

#pragma mark - Public methods

- (NSDictionary *)relationshipMappingDictionary {
    return @{};
}

#pragma mark - Private methods

- (void)setObjectDictionary:(NSDictionary *)objectDictionary {
    
    if ([objectDictionary isKindOfClass:[NSNull class]]) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    
    NSArray *namesArray = [self getClassPropertyAttributes];
    NSDictionary *relationshipsKeys = [self relationshipMappingDictionary];
    
    [objectDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {

        NSString *fixedKey = ([key isEqualToString:@"id"]) ? @"post_id" : key;
        
        if (![namesArray containsObject:fixedKey]) {
            return;
        }
        
        if (!obj) {
            [weakSelf setValue:[NSNull null] forKey:fixedKey];;
        }
        
        if (relationshipsKeys[fixedKey]) {
            DDNetworkObject *relatedObject = [[relationshipsKeys[fixedKey] alloc] init];
            [relatedObject setObjectDictionary:obj];
            [weakSelf setValue:relatedObject forKey:fixedKey];
            return;
        }
        
        [weakSelf setValue:obj forKey:fixedKey];
    }];
}

- (NSArray *)getClassPropertyAttributes {
    
    unsigned propertiesCount;
    objc_property_t *property_t = class_copyPropertyList([self class], &propertiesCount);
    
    NSMutableArray *namesArray = [NSMutableArray array];
    
    for (unsigned i = 0; i < propertiesCount; i++) {
        objc_property_t property = property_t[i];
        NSString *name = [NSString stringWithUTF8String:property_getName(property)];
        [namesArray addObject:name];
    }
    
    free(property_t);
    
    return namesArray;
}

@end