//
//  UIDevice+Resolutions.h
//  InstaTags
//
//  Created by Dmitriy Demchenko on 11/17/15.
//  Copyright © 2015 Dmitriy Demchenko. All rights reserved.
//

#import <UIKit/UIKit.h>

enum {
    UIDeviceResolution_Unknown              = 0,
    UIDeviceResolution_iPhoneStandard       = 1,    // iPhone 1,3,3GS Standard Display          (320x480px)
    UIDeviceResolution_iPhoneRetina4        = 2,    // iPhone 4,4S Retina Display 3.5"          (640x960px)
    UIDeviceResolution_iPhoneRetina5        = 3,    // iPhone 5 Retina Display 4"               (640x1136px)
    UIDeviceResolution_iPhoneRetina6        = 4,    // iPhone 6,6S Retina Display 4.7"          (750x1334px)
    UIDeviceResolution_iPhoneRetina6Plus    = 5,    // iPhone 6Plus,6PlusS Retina Display 5.5"  (1242x2208px)
    UIDeviceResolution_iPadStandard         = 6,    // iPad 1,2,mini Standard Display           (768x1024px)
    UIDeviceResolution_iPadRetina           = 7,    // iPad 3,4,
                                                    // iPad Air, Air2,
                                                    // iPad mini2, mini3, mini4 Retina Display  (1536x2048px)
    UIDeviceResolution_iPadPro              = 8,    // iPad Pro                                 (2048x2732px)
    
}; typedef NSUInteger UIDeviceResolution;

@interface UIDevice (Resolutions)

+ (UIDeviceResolution)resolution;

NSString *NSStringFromResolution(UIDeviceResolution resolution);

@end