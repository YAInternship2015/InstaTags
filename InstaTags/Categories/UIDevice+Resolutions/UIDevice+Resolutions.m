//
//  UIDevice+Resolutions.m
//  InstaTags
//
//  Created by Dmitriy Demchenko on 11/17/15.
//  Copyright © 2015 Dmitriy Demchenko. All rights reserved.
//

#import "UIDevice+Resolutions.h"

@implementation UIDevice (Resolutions)

+ (UIDeviceResolution)resolution {
    UIDeviceResolution resolution = UIDeviceResolution_Unknown;
    UIScreen *mainScreen = [UIScreen mainScreen];
    CGFloat scale = ([mainScreen respondsToSelector:@selector(scale)] ? mainScreen.scale : 1.0f);
    CGFloat pixelHeight = (CGRectGetHeight(mainScreen.bounds) * scale);
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        if (scale == 2.0f) {
            if (pixelHeight == 960.0f)
                resolution = UIDeviceResolution_iPhoneRetina4;
            else if (pixelHeight == 1136.0f)
                resolution = UIDeviceResolution_iPhoneRetina5;
            else if (pixelHeight == 1334.0f)
                resolution = UIDeviceResolution_iPhoneRetina6;
        } else if (scale == 1.0f && pixelHeight == 480.0f) {
            resolution = UIDeviceResolution_iPhoneStandard;
        } else if (scale == 3.0f) {
            resolution = UIDeviceResolution_iPhoneRetina6Plus;
        }
    } else {
        if (scale == 2.0f && pixelHeight == 2048.0f) {
            resolution = UIDeviceResolution_iPadRetina;
        } else if (scale == 2.0f && pixelHeight == 2732.0f) {
            resolution = UIDeviceResolution_iPadPro;
        } else if (scale == 1.0f && pixelHeight == 1024.0f) {
            resolution = UIDeviceResolution_iPadStandard;
        }
    }
    return resolution;
}

@end