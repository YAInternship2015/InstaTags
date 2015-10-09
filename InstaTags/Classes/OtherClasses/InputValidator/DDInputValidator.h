//
//  DDInputValidator.h
//  InstaTags
//
//  Created by Dmitriy Demchenko on 9/25/15.
//  Copyright (c) 2015 Dmitriy Demchenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDInputValidator : NSObject

+ (BOOL)validateInputString:(NSString *)string error:(NSError **)error;

@end