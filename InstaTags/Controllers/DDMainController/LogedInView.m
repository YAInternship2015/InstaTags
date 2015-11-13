//
//  LogedInView.m
//  InstaTags
//
//  Created by Dmitriy Demchenko on 11/13/15.
//  Copyright © 2015 Dmitriy Demchenko. All rights reserved.
//

#import "LogedInView.h"

@interface LogedInView ()

@property (weak, nonatomic) IBOutlet UILabel *userFullNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@end

@implementation LogedInView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self load];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self load];
    }
    return self;
}

- (void)load {
    UIView *view = [[[NSBundle bundleForClass:[self class]] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
    [self addSubview:view];
    view.frame = self.bounds;
    
    self.userFullNameLabel.text = @"userFullNameLabel";
    self.userProfileImageView.image = [UIImage appCollectionViewIcon]; // test
    [self.activityIndicatorView startAnimating];
}

@end