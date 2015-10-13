//
//  DDAuthenticationManager.h
//  InstaTags
//
//  Created by Dmitriy Demchenko on 10/13/15.
//  Copyright (c) 2015 Dmitriy Demchenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDAuthenticationManager : NSObject

- (void)authenticationAndLoginUser;
- (BOOL)getInstagramCodeFromURL:(NSURL *)url;

@end