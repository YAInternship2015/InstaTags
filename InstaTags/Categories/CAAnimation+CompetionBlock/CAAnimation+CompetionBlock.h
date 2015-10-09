//
//  CAAnimation+CompetionBlock.h.h
//  InstaTags
//
//  Created by Dmitriy Demchenko on 9/25/15.
//  Copyright (c) 2015 Dmitriy Demchenko. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CAAnimation (CompetionBlock)

@property (copy) void (^begin)(void);
@property (copy) void (^end)(BOOL end);

@end