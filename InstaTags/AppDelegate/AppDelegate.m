//
//  AppDelegate.m
//  InstaTags
//
//  Created by Dmitriy Demchenko on 9/25/15.
//  Copyright (c) 2015 Dmitriy Demchenko. All rights reserved.
//

#import "AppDelegate.h"
#import "DDAppearanceConfigurator.h"
#import "DDAuthenticationManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [DDAppearanceConfigurator configurateNavigationBarAndStatusBar];
    [DDAppearanceConfigurator configurateTextField];
    
    [MagicalRecord setupCoreDataStack];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
#warning Вынес в отдельный класс DDAuthenticationManager
//#warning эту логику надо убрать из AppDelegate
    DDAuthenticationManager *manager = [[DDAuthenticationManager alloc] init];
    return [manager getInstagramCodeFromURL:url];
}

@end