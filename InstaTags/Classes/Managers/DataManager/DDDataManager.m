//
//  DDDataManager.m
//  InstaTags
//
//  Created by Dmitriy Demchenko on 10/4/15.
//  Copyright (c) 2015 Dmitriy Demchenko. All rights reserved.
//

#import "DDDataManager.h"
#import "DDPostModel.h"

@implementation DDDataManager

+ (DDDataManager *)sharedManager {
    static DDDataManager *manager = nil;
    static dispatch_once_t onceTaken;
    dispatch_once (&onceTaken, ^{
        manager = [[DDDataManager alloc] init];
    });
    return manager;
}

- (void)saveUserProfile:(NSDictionary *)userProfile {
    
    [[NSUserDefaults standardUserDefaults] setValue:userProfile[kUserFullName] forKey:kUserFullName];
    [[NSUserDefaults standardUserDefaults] setValue:userProfile[kUserProfilePicture] forKey:kUserProfilePicture];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationUserProfileSaved object:nil];
}

#warning плохое имя метода, ничего не говорит о том, что в нем происходит
- (void)pagination {
    __weak typeof(self) weakSelf = self;
#warning в succes опечатка
    [[DDApiManager sharedManager] loadImagesWithTag:nil completionHandler:^(BOOL succes, id responseObject, NSError *error) {
        [weakSelf insertItemsToCoreDataFromArray:responseObject];
    }];
}

- (void)insertItemsToCoreDataFromArray:(NSArray *)array {
    
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        DDPostModel *networkObject = [[DDPostModel alloc] init];
        networkObject.objectDictionary = obj;
        
#warning так как "пачки" данных в приложении небольшие, я бы порекомендовал вынести перебор массива в MagicalRecord блок, чтобы save произошел один, а не для каждой отдельной модели
        [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
            DDModel *item = nil;
            NSArray *savedItemArray = [DDModel MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"post_id == %@", networkObject.post_id]];
            
            if ([savedItemArray count] > 0) {
                item = savedItemArray[0];
            }else{
                item = [DDModel MR_createEntityInContext:localContext];
                item.post_id = networkObject.post_id;
                item.user_profile_picture = networkObject.user.profile_picture;
                item.user_full_name = networkObject.user.full_name;
                item.instagram_image_url = networkObject.images.standard_resolution.url;
                item.caption_text = networkObject.caption.text;
            }
        }];
    }];
}

@end