//
//  DDInstagramViewerCell.m
//  InstaTags
//
//  Created by Dmitriy Demchenko on 9/26/15.
//  Copyright (c) 2015 Dmitriy Demchenko. All rights reserved.
//

#import "DDITTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "DDModel.h"

@interface DDITTableViewCell ()

//#warning в моделях формат с "_" еще как-то оправдывается, здесь уже нет. Пользуйтесь camel case'ом
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *fullName;
@property (weak, nonatomic) IBOutlet UIImageView *instagramImageView;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;

@end


@implementation DDITTableViewCell

- (void)configWithPostModel:(DDModel *)post {
    
    [self.profilePicture sd_setImageWithURL:[NSURL URLWithString:post.user_profile_picture]];
    self.fullName.text = (post.user_full_name) ? post.user_full_name : post.username;
    
    self.instagramImageView.image = nil;
//#warning картинку-плейсхолдер надо вынести в категорию UIImage
    [self.instagramImageView sd_setImageWithURL:[NSURL URLWithString:post.instagram_image_url] placeholderImage:[UIImage appPlaceholderImage]];
    
    self.captionLabel.text = post.caption_text;
}

@end