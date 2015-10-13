//
//  DDUserProfile.m
//  InstaTags
//
//  Created by Dmitriy Demchenko on 10/13/15.
//  Copyright (c) 2015 Dmitriy Demchenko. All rights reserved.
//

#import "DDUserProfileModel.h"

@implementation DDUserProfileModel

- (NSDictionary *)relationshipMappingDictionary {
    return @{@"user" : [DDUserModel class]};
}

@end