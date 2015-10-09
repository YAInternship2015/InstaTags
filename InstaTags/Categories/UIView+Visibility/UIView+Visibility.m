//
//  UIView+Visibility.m
//  InstaTags
//
//  Created by Dmitriy Demchenko on 10/3/15.
//  Copyright (c) 2015 Dmitriy Demchenko. All rights reserved.
//

#import "UIView+Visibility.h"

NSString *const UIViewVisibilityAnimationKeyShow = @"UIViewVisibilityAnimationKeyShow";
NSString *const UIViewVisibilityAnimationKeyHide = @"UIViewVisibilityAnimationKeyHide";

@implementation UIView (Visibility)

- (BOOL)visible {
    if (self.hidden || [self.layer animationForKey:UIViewVisibilityAnimationKeyHide]) {
        return NO;
    }
    return YES;
}

- (void)setVisible:(BOOL)visible {
    [self setVisible:visible animated:NO];
}

- (void)setVisible:(BOOL)visible animated:(BOOL)animated {
    
    if (self.visible == visible) {
        return;
    }
    
    [self.layer removeAnimationForKey:UIViewVisibilityAnimationKeyShow];
    [self.layer removeAnimationForKey:UIViewVisibilityAnimationKeyHide];
    
    if (!animated) {
        self.alpha = 1.f;
        self.hidden = !visible;
        return;
    }
    
    self.hidden = NO;
    
    CGFloat fromAlpha = visible ? 0.f : 1.f;
    CGFloat toAlpha = visible ? 1.f : 0.f;
    NSString *animationKey = visible ? UIViewVisibilityAnimationKeyShow : UIViewVisibilityAnimationKeyHide;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.duration = 0.25;
    animation.fromValue = @(fromAlpha);
    animation.toValue = @(toAlpha);
    animation.delegate = self;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [self.layer addAnimation:animation forKey:animationKey];
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)finished {
    if ([[self.layer animationForKey:UIViewVisibilityAnimationKeyHide] isEqual:animation]) {
        self.hidden = YES;
    }
}

@end