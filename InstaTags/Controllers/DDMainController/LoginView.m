//
//  LoginView.m
//  InstaTags
//
//  Created by Dmitriy Demchenko on 11/13/15.
//  Copyright © 2015 Dmitriy Demchenko. All rights reserved.
//

#import "LoginView.h"
#import "DDAuthenticationManager.h"

@interface LoginView ()

@property (nonatomic, weak) IBOutlet UIButton *loginButton;
@property (nonatomic, weak) IBOutlet UILabel *messageLabel;

@end

@implementation LoginView

- (void)setLoginButton:(UIButton *)loginButton {
    [loginButton setTitle:[@"войти" localized] forState:UIControlStateNormal];
}

- (void)setMessageLabel:(UILabel *)messageLabel {
    messageLabel.text = [@"Войдите, чтобы смотреть фотографии." localized];
}

- (IBAction)loginActions:(UIButton *)sender {
    [self.loginButton setVisible:NO animated:YES];
    [self.messageLabel setVisible:NO animated:YES];
    DDAuthenticationManager *manager = [[DDAuthenticationManager alloc] init];
    [manager authenticationAndLoginUser];
}

@end