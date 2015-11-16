//
//  LogedInView.m
//  InstaTags
//
//  Created by Dmitriy Demchenko on 11/13/15.
//  Copyright © 2015 Dmitriy Demchenko. All rights reserved.
//

#import "LogedInView.h"
#import "DDUser.h"
#import "DDUser+FetchingEntity.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface LogedInView ()

@property (nonatomic, weak) IBOutlet UILabel *userNameLabel;
@property (nonatomic, weak) IBOutlet UIImageView *userProfilePictureImageView;
@property (nonatomic, strong) DDUser *logedUser;

@end

@implementation LogedInView

- (void)setUserNameLabel:(UILabel *)userNameLabel {
    userNameLabel.text = [DDUser savedUser].full_name;
}

- (void)setUserProfilePictureImageView:(UIImageView *)userProfilePictureImageView {
    [userProfilePictureImageView sd_setImageWithURL:[NSURL URLWithString:[DDUser savedUser].profile_picture] placeholderImage:[UIImage appUserAvatar]];
}

- (void)setLogedUser:(DDUser *)logedUser {
    logedUser = [DDUser savedUser];
}

@end