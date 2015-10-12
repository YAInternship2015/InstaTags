//
//  AppDelegate.m
//  InstaTags
//
//  Created by Dmitriy Demchenko on 9/25/15.
//  Copyright (c) 2015 Dmitriy Demchenko. All rights reserved.
//

#import "AppDelegate.h"
#import "DDAppearanceConfigurator.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [DDAppearanceConfigurator configurateNavigationBarAndStatusBar];
    [DDAppearanceConfigurator configurateTextField];
    
    [MagicalRecord setupCoreDataStackWithStoreNamed:EntityDDModel];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    if([[url scheme] isEqualToString:INSTAGRAM_URL_SCHEME]) {
#warning эту логику надо убрать из AppDelegate
        if([[url absoluteString] rangeOfString:@"code="].location != NSNotFound) {
            NSString* authorizationCode = [[url absoluteString] substringFromIndex: NSMaxRange([[url absoluteString] rangeOfString:@"code="])];
            
            [[NSUserDefaults standardUserDefaults] setValue:authorizationCode forKey:INSTAGRAM_CODE];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[DDApiManager sharedManager] receiveRedirectFromInstagram];
        } else {
            if([[url absoluteString] rangeOfString:@"error="].location != NSNotFound) {
                NSLog(@"error occured!");
            }
        }
    }
    return YES;
}

@end