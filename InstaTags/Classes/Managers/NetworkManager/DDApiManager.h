//
//  DDApiManager.h
//  InstaTags
//
//  Created by Dmitriy Demchenko on 9/25/15.
//  Copyright (c) 2015 Dmitriy Demchenko. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ApiManagerBlock)(BOOL success, id responseObject, NSError *error);

@interface DDApiManager : NSObject

+ (DDApiManager *)sharedManager;

- (void)searchForTagsByName:(NSString *)tagsByName completionHandler:(ApiManagerBlock)completionHandler;
- (void)loadImagesWithTag:(NSString *)tag completionHandler:(ApiManagerBlock)completionHandler;

@end