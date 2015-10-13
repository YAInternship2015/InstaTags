//
//  DDModel.h
//  InstaTags
//
//  Created by Dmitriy Demchenko on 10/13/15.
//  Copyright (c) 2015 Dmitriy Demchenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DDModel : NSManagedObject

@property (nonatomic, retain) NSString *caption_text;
@property (nonatomic, retain) NSString *instagram_image_url;
@property (nonatomic, retain) NSString *post_id;
@property (nonatomic, retain) NSString *user_full_name;
@property (nonatomic, retain) NSString *user_profile_picture;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSDate *saved_date;

#warning добавил 2 новых поля username (используется если юзер не предоставил user_full_name) и saved_date (для сортировки при выборке)

@end
