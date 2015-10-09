//
//  UIFont+AppFont.h
//  InstaTags
//
//  Created by Dmitriy Demchenko on 9/27/15.
//  Copyright (c) 2015 Dmitriy Demchenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (AppFont)

+ (UIFont *)appFontProximanovaBoldWithSize:(CGFloat)size;
+ (UIFont *)appFontProximanovaLightWithSize:(CGFloat)size;
+ (UIFont *)appFontProximanovaRegularWithSize:(CGFloat)size;
+ (UIFont *)appFontProximanovaRegularitalicWithSize:(CGFloat)size;
+ (UIFont *)appFontProximanovaSemiboldWithSize:(CGFloat)size;

@end