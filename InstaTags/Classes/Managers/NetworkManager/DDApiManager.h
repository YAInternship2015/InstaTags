//
//  DDApiManager.h
//  InstaTags
//
//  Created by Dmitriy Demchenko on 9/25/15.
//  Copyright (c) 2015 Dmitriy Demchenko. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CompletionBlock)(BOOL succes, id responseObject, NSError *error);

@interface DDApiManager : NSObject

+ (DDApiManager *)sharedManager;

#warning плозие имена методов
- (void)directUserToAuthorizationURL;
- (void)receiveRedirectFromInstagram;

- (void)searchForTagsByName:(NSString *)tagsByName completionHandler:(CompletionBlock)completionHandler;
#warning здесь вместо get надо load или request
- (void)getImagesWithTag:(NSString *)tag completionHandler:(CompletionBlock)completionHandler;

@end