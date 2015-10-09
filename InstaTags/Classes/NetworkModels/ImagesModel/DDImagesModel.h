//
//  ImagesModel.h
//  InstaTags
//
//  Created by Dmitriy Demchenko on 10/3/15.
//  Copyright (c) 2015 Dmitriy Demchenko. All rights reserved.
//

#import "DDNetworkObject.h"
#import "DDImageModel.h"

@interface DDImagesModel : DDNetworkObject

@property (nonatomic, strong) DDImageModel *low_resolution;
@property (nonatomic, strong) DDImageModel *thumbnail;
@property (nonatomic, strong) DDImageModel *standard_resolution;

@end