//
//  DDInstagramViewerCell.m
//  InstaTags
//
//  Created by Dmitriy Demchenko on 9/26/15.
//  Copyright (c) 2015 Dmitriy Demchenko. All rights reserved.
//

#import "DDITTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface DDITTableViewCell ()

#warning в моделях формат с "_" еще как-то оправдывается, здесь уже нет. Пользуйтесь camel case'ом
@property (weak, nonatomic) IBOutlet UIImageView *profile_picture;
@property (weak, nonatomic) IBOutlet UILabel *full_name;
@property (weak, nonatomic) IBOutlet UIImageView *instagramImageView;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;

@end

@implementation DDITTableViewCell

- (void)configWithPostModel:(DDModel *)post {
    
    [self.profile_picture sd_setImageWithURL:[NSURL URLWithString:post.user_profile_picture]];
    self.full_name.text = post.user_full_name;
    
    self.instagramImageView.image = nil;
//#warning картинку-плейсхолдер надо вынести в категорию UIImage
    [self.instagramImageView sd_setImageWithURL:[NSURL URLWithString:post.instagram_image_url] placeholderImage:[UIImage appPlaceholderImage]];
    
    self.captionLabel.text = post.caption_text;
}

@end