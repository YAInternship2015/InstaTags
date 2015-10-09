//
//  UIFont+AppFont.m
//  InstaTags
//
//  Created by Dmitriy Demchenko on 9/27/15.
//  Copyright (c) 2015 Dmitriy Demchenko. All rights reserved.
//

#import "UIFont+AppFont.h"

@implementation UIFont (AppFont)

/*
 proximanova-bold.otf
 proximanova-light.otf
 proximanova-regular.otf
 proximanova-regularitalic.otf
 proximanova-semibold.otf
 */

+ (UIFont *)appFontProximanovaBoldWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"proximanova-bold" size:size];
}

+ (UIFont *)appFontProximanovaLightWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"proximanova-light" size:size];
}

+ (UIFont *)appFontProximanovaRegularWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"proximanova-regular" size:size];
}

+ (UIFont *)appFontProximanovaRegularitalicWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"proximanova-regularitalic" size:size];
}

+ (UIFont *)appFontProximanovaSemiboldWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"proximanova-semibold" size:size];
}

@end
