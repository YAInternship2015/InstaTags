//
//  DDApiManager.m
//  InstaTags
//
//  Created by Dmitriy Demchenko on 9/25/15.
//  Copyright (c) 2015 Dmitriy Demchenko. All rights reserved.
//

#import "DDApiManager.h"
#import "AFNetworking.h"
#import "DDDataManager.h"
#import "DDUser+FetchingEntity.h"

static NSString *const TagsHostURL = @"https://api.instagram.com/v1/tags/";

@interface DDApiManager ()

@property (nonatomic, strong) NSString *nextURL;

@end


@implementation DDApiManager

#pragma mark - Initialization

+ (DDApiManager *)sharedManager {
    static DDApiManager *manager = nil;
    static dispatch_once_t onceTaken;
    dispatch_once (&onceTaken, ^{
        manager = [[DDApiManager alloc] init];
    });
    return manager;
}

#pragma mark - Public methods

- (void)searchForTagsByName:(NSString *)tagsByName completionHandler:(ApiManagerBlock)completionHandler {
    
    // https://api.instagram.com/v1/tags/search?q=snowy&access_token=ACCESS-TOKEN
    
    NSString *pathString = [NSString stringWithFormat:@"search?q=%@&%@%@", tagsByName, [NM_AccessTokenPath stringByAppendingString:@"=" ], [DDUser savedUser].access_token];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:TagsHostURL]];
    [manager GET:pathString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completionHandler(YES, responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", [error localizedDescription]);
    }];
}

- (void)loadImagesWithTag:(NSString *)tag completionHandler:(ApiManagerBlock)completionHandler {
    
    // https://api.instagram.com/v1/tags/{tag-name}/media/recent?access_token=ACCESS-TOKEN
    
    NSString *pathString = (tag) ? [NSString stringWithFormat:@"%@%@/media/recent?%@%@&count=5", TagsHostURL, tag, [NM_AccessTokenPath stringByAppendingString:@"=" ], [DDUser savedUser].access_token] : self.nextURL;
    __weak typeof(self) weakSelf = self;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:pathString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        weakSelf.nextURL = responseObject[kTagsPagination][kTagsNextURL];
        completionHandler (YES, responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", [error localizedDescription]);
    }];
}

@end