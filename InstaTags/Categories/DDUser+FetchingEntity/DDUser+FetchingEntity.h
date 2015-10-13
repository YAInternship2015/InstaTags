//
//  DDUser+FetchingEntity.h
//  InstaTags
//
//  Created by Dmitriy Demchenko on 10/13/15.
//  Copyright (c) 2015 Dmitriy Demchenko. All rights reserved.
//

#import "DDUser.h"

@interface DDUser (FetchingEntity)

+ (DDUser *)savedUser;

@end
