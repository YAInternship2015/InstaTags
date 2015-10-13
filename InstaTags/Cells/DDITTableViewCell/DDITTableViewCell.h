//
//  DDInstagramViewerCell.h
//  InstaTags
//
//  Created by Dmitriy Demchenko on 9/26/15.
//  Copyright (c) 2015 Dmitriy Demchenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DDModel;

@interface DDITTableViewCell : UITableViewCell

- (void)configWithPostModel:(DDModel *)model;

@end