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

#import "DDModel.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [DDAppearanceConfigurator configurateNavigationBarAndStatusBar];
    [DDAppearanceConfigurator configurateTextField];
    
    [MagicalRecord setupCoreDataStack];
    
    [DDModel MR_truncateAllInContext:[NSManagedObjectContext MR_defaultContext]];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    DDAuthenticationManager *manager = [[DDAuthenticationManager alloc] init];
    return [manager getInstagramCodeFromURL:url];
}

@end