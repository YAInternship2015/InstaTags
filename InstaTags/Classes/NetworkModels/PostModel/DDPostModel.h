//
//  PostModel.h
//  InstaTags
//
//  Created by Dmitriy Demchenko on 10/3/15.
//  Copyright (c) 2015 Dmitriy Demchenko. All rights reserved.
//

#import "DDNetworkObject.h"
#import "DDImagesModel.h"
#import "DDCaptionModel.h"
#import "DDUserModel.h"

@interface DDPostModel : DDNetworkObject

@property (nonatomic, strong) NSString *post_id;
@property (nonatomic, strong) DDImagesModel *images;
@property (nonatomic, strong) DDCaptionModel *caption;
@property (nonatomic, strong) DDUserModel *user;

@end