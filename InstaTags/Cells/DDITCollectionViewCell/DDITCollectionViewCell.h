//
//  DDCharacterCollectionCell.h
//  InstaTags
//
//  Created by Dmitriy Demchenko on 9/25/15.
//  Copyright (c) 2015 Dmitriy Demchenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DDModel;

@interface DDITCollectionViewCell : UICollectionViewCell

- (void)configWithPostModel:(DDModel *)model;

@end