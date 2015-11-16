//
//  LogedInController.m
//  InstaTags
//
//  Created by Dmitriy Demchenko on 11/16/15.
//  Copyright © 2015 Dmitriy Demchenko. All rights reserved.
//

#import "DDLogedInController.h"
#import "DDUser.h"
#import "DDUser+FetchingEntity.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface DDLogedInController ()

@property (nonatomic, weak) IBOutlet UILabel *userNameLabel;
@property (nonatomic, weak) IBOutlet UIImageView *userProfilePictureImageView;

@end

@implementation DDLogedInController

#pragma mark - Setters

- (void)setUserNameLabel:(UILabel *)userNameLabel {
    userNameLabel.text = [DDUser savedUser].full_name;
}

- (void)setUserProfilePictureImageView:(UIImageView *)userProfilePictureImageView {
    [userProfilePictureImageView sd_setImageWithURL:[NSURL URLWithString:[DDUser savedUser].profile_picture] placeholderImage:[UIImage appUserAvatar]];
}

@end
