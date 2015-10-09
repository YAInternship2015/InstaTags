//
//  UIView+Visibility.h
//  InstaTags
//
//  Created by Dmitriy Demchenko on 10/3/15.
//  Copyright (c) 2015 Dmitriy Demchenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Visibility)

- (BOOL)visible;
- (void)setVisible:(BOOL)visible;
- (void)setVisible:(BOOL)visible animated:(BOOL)animated;

@end