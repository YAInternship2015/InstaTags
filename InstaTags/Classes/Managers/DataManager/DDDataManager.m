//
//  DDDataManager.m
//  InstaTags
//
//  Created by Dmitriy Demchenko on 10/4/15.
//  Copyright (c) 2015 Dmitriy Demchenko. All rights reserved.
//

#import "DDDataManager.h"
#import "DDPostModel.h"
#import "DDApiConstants.h"

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

- (void)tagsByName:(NSString *)name completion:(DataManagerBlock)completion {
    __block NSMutableArray *tagsArray = [[NSMutableArray alloc] init];
    [[DDApiManager sharedManager] searchForTagsByName:name completionHandler:^(BOOL success, id responseObject, NSError *error) {
        NSArray *dataArray = responseObject[kTagsData];
        [dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [tagsArray addObject:obj[kTagsName]];
        }];
        completion(success, tagsArray, nil);
    }];
}

//#warning плохое имя метода, ничего не говорит о том, что в нем происходит
- (void)loadNextStackOfPosts {
    __weak typeof(self) weakSelf = self;
//#warning в succes опечатка
    [[DDApiManager sharedManager] loadImagesWithTag:nil completionHandler:^(BOOL success, id responseObject, NSError *error) {
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