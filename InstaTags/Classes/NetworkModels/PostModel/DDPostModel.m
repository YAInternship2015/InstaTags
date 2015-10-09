//
//  PostModel.m
//  InstaTags
//
//  Created by Dmitriy Demchenko on 10/3/15.
//  Copyright (c) 2015 Dmitriy Demchenko. All rights reserved.
//

#import "DDPostModel.h"

@implementation DDPostModel

- (NSDictionary *)relationshipMappingDictionary {
    return @{@"images"  : [DDImagesModel class],
             @"caption" : [DDCaptionModel class],
             @"user"    : [DDUserModel class]};
}

@end