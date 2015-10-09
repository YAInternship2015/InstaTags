//
//  CAAnimation+CompetionBlock.h.m
//  InstaTags
//
//  Created by Dmitriy Demchenko on 9/25/15.
//  Copyright (c) 2015 Dmitriy Demchenko. All rights reserved.
//

#import "CAAnimation+CompetionBlock.h"

@implementation CAAnimation (CompetionBlock)

@dynamic begin;
@dynamic end;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.delegate = self;
    }
    return self;
}

- (void)animationDidStart:(CAAnimation *)anim {
    if (self.begin) {
        self.begin();
        self.begin = nil;
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (self.end) {
        self.end(flag);
        self.end = nil;
    }
}

@end