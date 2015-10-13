//
//  DDUser.h
//  InstaTags
//
//  Created by Dmitriy Demchenko on 10/13/15.
//  Copyright (c) 2015 Dmitriy Demchenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DDUser : NSManagedObject

@property (nonatomic, retain) NSString *access_token;
@property (nonatomic, retain) NSString *full_name;
@property (nonatomic, retain) NSString *profile_picture;
@property (nonatomic, retain) NSString *username;

@end