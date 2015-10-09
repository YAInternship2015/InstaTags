//
//  DDCharacterCollectionCell.m
//  InstaTags
//
//  Created by Dmitriy Demchenko on 9/25/15.
//  Copyright (c) 2015 Dmitriy Demchenko. All rights reserved.
//

#import "DDITCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface DDITCollectionViewCell ()

@property (nonatomic, weak) IBOutlet UIImageView *instagramImage;

@end


@implementation DDITCollectionViewCell

- (void)configWithPostModel:(DDModel *)post {
    [self.instagramImage sd_setImageWithURL:[NSURL URLWithString:post.instagram_image_url] placeholderImage:[UIImage imageNamed:@"placeholder_image"]];
}

@end