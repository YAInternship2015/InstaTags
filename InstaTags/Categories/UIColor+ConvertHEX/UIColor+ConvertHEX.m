//
//  UIColor+ConvertHEX.m
//  InstaTags
//
//  Created by Dmitriy Demchenko on 9/25/15.
//  Copyright (c) 2015 Dmitriy Demchenko. All rights reserved.
//

#import "UIColor+ConvertHEX.h"

@implementation UIColor (ConvertHEX)

+ (UIColor *)colorWithHexString:(NSString *)colorString {
    colorString = [colorString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if (colorString.length == 3) {
        colorString = [NSString stringWithFormat:@"%c%c%c%c%c%c",
                       [colorString characterAtIndex:0], [colorString characterAtIndex:0],
                       [colorString characterAtIndex:1], [colorString characterAtIndex:1],
                       [colorString characterAtIndex:2], [colorString characterAtIndex:2]];
    }
    if (colorString.length == 6) {
        int r, g, b;
        sscanf([colorString UTF8String], "%2x%2x%2x", &r, &g, &b);
        return [UIColor colorWithRed:(r/255.f) green:(g/255.f) blue:(b/255.f) alpha:1.f];
    }
    return nil;
}

+ (UIColor *)colorWithHexValue:(int)hexValue {
    float red   = ((hexValue & 0xFF0000) >> 16)/255.f;
    float green = ((hexValue & 0xFF00) >> 8)/255.f;
    float blue  = (hexValue & 0xFF)/255.f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.f];
}

@end