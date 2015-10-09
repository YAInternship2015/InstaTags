//
//  DDInputValidator.m
//  InstaTags
//
//  Created by Dmitriy Demchenko on 9/25/15.
//  Copyright (c) 2015 Dmitriy Demchenko. All rights reserved.
//

#import "DDInputValidator.h"

@implementation DDInputValidator

static NSString *const RegularExpression = @"[\\w\\s]{3,100}";

+ (BOOL)validateInputString:(NSString *)string error:(NSError **)error {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES[cd] %@", RegularExpression];
    BOOL success = [predicate evaluateWithObject:string];
    
    NSString *errorMessage;
    NSInteger errorCode = 0;
    
    if (!success) {
        errorMessage = [@"Tag can't be less than 3 characters." localized];
        errorCode = 9000;
        
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey : errorMessage};
        
        if (error != NULL) {
            *error = [NSError errorWithDomain:@"com.dmitriy.demchenko.InstaTags" code:errorCode userInfo:userInfo];
        }
        
        [[[UIAlertView alloc] initWithTitle:[@"Message" localized] message:userInfo[NSLocalizedDescriptionKey] delegate:nil cancelButtonTitle:[@"Dismiss" localized] otherButtonTitles:nil] show];
        
        return NO;
    }
    return YES;
}

@end