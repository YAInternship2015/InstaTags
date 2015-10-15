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
#warning проще вызвать [DDUser MR_findFirst], если вдруг MR_findAll вернет пустой массив, то приложение "упадет"
    return [DDUser MR_findAll][0];
}

@end
