//
//  UserModel.h
//  InstaTags
//
//  Created by Dmitriy Demchenko on 9/27/15.
//  Copyright (c) 2015 Dmitriy Demchenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDNetworkObject.h"

@interface DDUserModel : DDNetworkObject

@property (nonatomic, strong) NSString *profile_picture;
@property (nonatomic, strong) NSString *full_name;
@property (nonatomic, strong) NSString *username;

@end