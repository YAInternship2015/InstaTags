//
//  NetworkObject.h
//  Parovozom.com
//
//  Created by Dmitriy Demchenko on 02/17/15.
//  Copyright (c) 2015 Dmitriy Demchenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDNetworkObject : NSObject

@property (nonatomic, strong) NSDictionary *objectDictionary;

- (NSDictionary *)relationshipMappingDictionary;

@end