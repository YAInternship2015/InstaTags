//
//  UIColor+AppColors.m
//  InstaTags
//
//  Created by Dmitriy Demchenko on 9/25/15.
//  Copyright (c) 2015 Dmitriy Demchenko. All rights reserved.
//

#import "UIColor+AppColors.h"
#import "UIColor+ConvertHEX.h"

@implementation UIColor (AppColors)

#pragma mark - Random color

+ (UIColor *)randomColor {
    CGFloat redLevel = rand() / (float) RAND_MAX;
    CGFloat greenLevel = rand() / (float) RAND_MAX;
    CGFloat blueLevel = rand() / (float) RAND_MAX;
    return [UIColor colorWithRed:redLevel green:greenLevel blue:blueLevel alpha:0.1f];
}

#pragma mark - Application colors

+ (UIColor *)appBaseBlueColor {
    return [UIColor colorWithHexString:@"#0A497A"];
}

+ (UIColor *)appBackgroundColor {
    return [UIColor colorWithHexString:@"#FAFAFA"];
}

+ (UIColor *)appBorderColor {
    return [UIColor colorWithHexString:@"#EDEEEE"];
}

+ (UIColor *)appSearchFieldColor {
    return [UIColor colorWithHexString:@"#A8AAAD"];
}

+ (UIColor *)appCaptionLabelColor {
    return [UIColor colorWithHexString:@"#555555"];
}

+ (UIColor *)appButtonColor {
    return [UIColor colorWithHexString:@"#4090DB"];
}

@end