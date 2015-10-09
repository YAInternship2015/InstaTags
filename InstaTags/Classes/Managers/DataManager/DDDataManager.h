//
//  DDDataManager.h
//  InstaTags
//
//  Created by Dmitriy Demchenko on 10/4/15.
//  Copyright (c) 2015 Dmitriy Demchenko. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^DMBlock)(BOOL succes);

@interface DDDataManager : NSObject

+ (DDDataManager *)sharedManager;
- (void)saveUserProfile:(NSDictionary *)userProfile;
- (void)pagination;
- (void)insertItemsToCoreDataFromArray:(NSArray *)array;

@end