//
//  LoginView.m
//  InstaTags
//
//  Created by Dmitriy Demchenko on 11/13/15.
//  Copyright © 2015 Dmitriy Demchenko. All rights reserved.
//

#import "LoginView.h"

@interface LoginView ()

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation LoginView

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
    
    self.infoLabel.text = @"infoLabel";
    [self.loginButton setTitle:[@"войти" localized] forState:UIControlStateNormal];
}

@end
