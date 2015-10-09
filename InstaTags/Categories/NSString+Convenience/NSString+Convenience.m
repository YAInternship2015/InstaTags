//
//  NSString+Convenience.m
//  InstaTags
//
//  Created by Dmitriy Demchenko on 9/27/15.
//  Copyright (c) 2015 Dmitriy Demchenko. All rights reserved.
//

#import "NSString+Convenience.h"

@implementation NSString (Convenience)

- (NSString *)removeLastCharacter {
    return [self substringToIndex:[self length] - 1];
}

- (NSString *)removeWhitespaces {
    return [[self componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@""];
}

- (NSString *)localized {
    return NSLocalizedString(self, @"");
}

@end