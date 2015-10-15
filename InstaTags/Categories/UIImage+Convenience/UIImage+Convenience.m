//
//  UIImage+Convenience.m
//  InstaTags
//
//  Created by Dmitriy Demchenko on 10/12/15.
//  Copyright (c) 2015 Dmitriy Demchenko. All rights reserved.
//

#import "UIImage+Convenience.h"

@implementation UIImage (Convenience)

+ (UIImage *)appPlaceholderImage {
    return [UIImage imageNamed:@"placeholder_image"];
}

+ (UIImage *)appBackButton {
    return [UIImage imageNamed:@"back_button"];
}

+ (UIImage *)appTableViewIcon {
    return [UIImage imageNamed:@"TableViewIcon"];
}

+ (UIImage *)appCollectionViewIcon {
    return[UIImage imageNamed:@"CollectionViewIcon"];
}

@end