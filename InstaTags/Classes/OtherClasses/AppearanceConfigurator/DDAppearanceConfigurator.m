//
//  DDAppearanceConfigurator.m
//  InstaTags
//
//  Created by Dmitriy Demchenko on 9/25/15.
//  Copyright (c) 2015 Dmitriy Demchenko. All rights reserved.
//

#import "DDAppearanceConfigurator.h"

@implementation DDAppearanceConfigurator

+ (void)configurateNavigationBarAndStatusBar {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UINavigationBar appearance] setBarTintColor:[UIColor appBaseBlueColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont appFontProximanovaRegularWithSize:18.f], NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [[UINavigationBar appearance] setBackIndicatorImage:[UIImage appBackButton]];
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage appBackButton]];
}

+ (void)configurateTextField {
    [[UITextField appearance] setTintColor:[UIColor appBaseBlueColor]];
}

@end