//
//  DDLoginController.m
//  InstaTags
//
//  Created by Dmitriy Demchenko on 11/16/15.
//  Copyright © 2015 Dmitriy Demchenko. All rights reserved.
//

#import "DDLoginController.h"
#import "DDAuthenticationManager.h"

@interface DDLoginController ()

@property (nonatomic, weak) IBOutlet UIButton *loginButton;
@property (nonatomic, weak) IBOutlet UILabel *messageLabel;

@end

@implementation DDLoginController

#pragma mark - Setters

- (void)setLoginButton:(UIButton *)loginButton {
    [loginButton setTitle:[@"войти" localized] forState:UIControlStateNormal];
}

- (void)setMessageLabel:(UILabel *)messageLabel {
    messageLabel.text = [@"Войдите, чтобы смотреть фотографии." localized];
}

- (IBAction)loginAction:(UIButton *)sender {
    DDAuthenticationManager *manager = [[DDAuthenticationManager alloc] init];
    [manager authenticationAndLoginUser];
    [self.loginButton setVisible:NO animated:YES];
    [self.messageLabel setVisible:NO animated:YES];
}

@end
