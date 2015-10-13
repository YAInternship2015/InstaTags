//
//  DDDataManager.m
//  InstaTags
//
//  Created by Dmitriy Demchenko on 10/4/15.
//  Copyright (c) 2015 Dmitriy Demchenko. All rights reserved.
//

#import "DDDataManager.h"
#import "DDPostModel.h"
#import "DDApiManager.h"
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

- (void)postsWithTag:(NSString *)tag completion:(DataManagerBlock)completion {
    
    [[DDApiManager sharedManager] loadImagesWithTag:tag completionHandler:^(BOOL success, id responseObject, NSError *error) {
        __weak typeof(self) weakSelf = self;
        [weakSelf insertItemsToCoreDataFromArray:responseObject[kTagsData]];
        if (tag) {
            completion(success, nil, nil);
        }
    }];
}

#pragma mark - Private methods

- (void)insertItemsToCoreDataFromArray:(NSArray *)array {
    
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        DDPostModel *networkObject = [[DDPostModel alloc] init];
        networkObject.objectDictionary = obj;
        
//#warning так как "пачки" данных в приложении небольшие, я бы порекомендовал вынести перебор массива в MagicalRecord блок, чтобы save произошел один, а не для каждой отдельной модели
#warning Не смог применить данную рекомендацию, тК при переборке массива внутри блока происходит сбой при обновлении контента tableView & collectionView
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
                item.username = networkObject.user.username;
                item.instagram_image_url = networkObject.images.standard_resolution.url;
                item.caption_text = networkObject.caption.text;
                item.saved_date = [NSDate date];
            }
        }];
    }];
}

@end