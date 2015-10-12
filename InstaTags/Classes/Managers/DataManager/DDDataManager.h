//
//  DDDataManager.h
//  InstaTags
//
//  Created by Dmitriy Demchenko on 10/4/15.
//  Copyright (c) 2015 Dmitriy Demchenko. All rights reserved.
//

#import <Foundation/Foundation.h>

//#warning зачем нужен этот блок?
//typedef void (^DMBlock)(BOOL succeыs);
typedef void (^DataManagerBlock)(BOOL success, id responseObject, NSError *error);

@interface DDDataManager : NSObject

+ (DDDataManager *)sharedManager;
- (void)saveUserProfile:(NSDictionary *)userProfile;
- (void)tagsByName:(NSString *)name completion:(DataManagerBlock)completion;
- (void)postsWithTag:(NSString *)tag completion:(DataManagerBlock)completion;

@end