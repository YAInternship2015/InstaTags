//
//  DDApiManager.h
//  InstaTags
//
//  Created by Dmitriy Demchenko on 9/25/15.
//  Copyright (c) 2015 Dmitriy Demchenko. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^DataManagerBlock)(BOOL success, id responseObject, NSError *error);

@interface DDApiManager : NSObject

+ (DDApiManager *)sharedManager;

#warning плохие имена методов
- (void)directUserToAuthorizationURL;
- (void)receiveRedirectFromInstagram;

- (void)searchForTagsByName:(NSString *)tagsByName completionHandler:(DataManagerBlock)completionHandler;
//#warning здесь вместо get надо load или request
- (void)loadImagesWithTag:(NSString *)tag completionHandler:(DataManagerBlock)completionHandler;

@end