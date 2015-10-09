//
//  NSString+Convenience.h
//  InstaTags
//
//  Created by Dmitriy Demchenko on 9/27/15.
//  Copyright (c) 2015 Dmitriy Demchenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Convenience)

- (NSString *)removeLastCharacter;
- (NSString *)removeWhitespaces;
- (NSString *)localized;

@end
