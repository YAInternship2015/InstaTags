//
//  DDUserProfile.h
//  InstaTags
//
//  Created by Dmitriy Demchenko on 10/13/15.
//  Copyright (c) 2015 Dmitriy Demchenko. All rights reserved.
//

#import "DDNetworkObject.h"
#import "DDUserModel.h"

@interface DDUserProfileModel : DDNetworkObject

@property (nonatomic, strong) NSString *access_token;
@property (nonatomic, strong) DDUserModel *user;

@end