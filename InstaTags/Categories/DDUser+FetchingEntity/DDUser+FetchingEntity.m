//
//  DDUser+FetchingEntity.m
//  InstaTags
//
//  Created by Dmitriy Demchenko on 10/13/15.
//  Copyright (c) 2015 Dmitriy Demchenko. All rights reserved.
//

#import "DDUser+FetchingEntity.h"

@implementation DDUser (FetchingEntity)

+ (DDUser *)savedUser {
    return [DDUser MR_findFirst];
}

@end
