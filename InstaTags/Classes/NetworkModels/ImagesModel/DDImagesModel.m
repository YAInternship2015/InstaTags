//
//  ImagesModel.m
//  InstaTags
//
//  Created by Dmitriy Demchenko on 10/3/15.
//  Copyright (c) 2015 Dmitriy Demchenko. All rights reserved.
//

#import "DDImagesModel.h"

@implementation DDImagesModel

- (NSDictionary *)relationshipMappingDictionary {
    return @{@"low_resolution"      : [DDImageModel class],
             @"thumbnail"           : [DDImageModel class],
             @"standard_resolution" : [DDImageModel class]};
}

@end