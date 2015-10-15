//
//  PreStartController.m
//  InstaTags
//
//  Created by Dmitriy Demchenko on 9/27/15.
//  Copyright (c) 2015 Dmitriy Demchenko. All rights reserved.
//

#import "PreStartController.h"

static CGFloat const LogoPosition = 53.5f;
static CGFloat const AnimationDuration = 1.5f;
static NSString *const SegueIdentifierSplash = @"SegueIdentifierSplash";


@interface PreStartController ()

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;

@end


@implementation PreStartController

#pragma mark - Lifecycle

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    CABasicAnimation *logoAnimation = [CABasicAnimation animation];
    logoAnimation.keyPath = @"position.y";
    logoAnimation.fromValue = @(CGRectGetMidY([UIScreen mainScreen].bounds));
    logoAnimation.duration = AnimationDuration;
    logoAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.logoImageView.layer addAnimation:logoAnimation forKey:@"basic"];
    self.logoImageView.layer.position = CGPointMake(CGRectGetMidX([UIScreen mainScreen].bounds), LogoPosition);
    
    logoAnimation.end = ^(BOOL finished){
        [self performSegueWithIdentifier:SegueIdentifierSplash sender:self];
    };
}

@end