//
//  DDApiManager.m
//  InstaTags
//
//  Created by Dmitriy Demchenko on 9/25/15.
//  Copyright (c) 2015 Dmitriy Demchenko. All rights reserved.
//

#import "DDApiManager.h"
#import "AFNetworking.h"
#import "ApiMethods.h"
#import "DDPostModel.h"
#import "DDDataManager.h"

@interface DDApiManager ()

#warning не понял, зачем нужно свойство myTag
@property (nonatomic, strong) NSString *myTag;
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

#pragma mark - Authentication

#warning API клиент должен ТОЛЬКО отправлять запросы. Никакого маппинга моделей, перебрасывания на экраны и работы с UI.
- (void)directUserToAuthorizationURL {
    // https://api.instagram.com/oauth/authorize/?client_id=CLIENT-ID&redirect_uri=REDIRECT-URI&response_type=code
    
    NSString *receivingAccessTokenURL = [NSString stringWithFormat:@"%@%@?%@%@&%@%@&%@", OAuthHostURL, NM_AuthorizationPath, NM_ParameterClientID, INSTAGRAM_CLIENT_ID, NM_ParameterRedirectURI, INSTAGRAM_REDIRECT_URI, NM_ResponseType];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:receivingAccessTokenURL]];
}

- (void)receiveRedirectFromInstagram {
    
    // http://your-redirect-uri?code=CODE
    
    NSString *customScheme = [INSTAGRAM_URL_SCHEME stringByAppendingString:@"://"];
    NSString *fullPath = [NSString stringWithFormat:@"%@?%@%@", customScheme, NM_ParameterCode, [[NSUserDefaults standardUserDefaults] valueForKey:INSTAGRAM_CODE]];
    NSURL *url = [NSURL URLWithString:fullPath];
    
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [self requestAccessToken];
        
    } else {
        [[[UIAlertView alloc] initWithTitle:[@"Receiver Not Found" localized] message:[@"The Receiver App is not installed. It must be installed to send text." localized] delegate:nil cancelButtonTitle:[@"OK" localized] otherButtonTitles:nil] show];
    }
}

- (void)requestAccessToken {
    
    /*
     curl -F 'client_id=CLIENT_ID' \
     -F 'client_secret=CLIENT_SECRET' \
     -F 'grant_type=authorization_code' \
     -F 'redirect_uri=AUTHORIZATION_REDIRECT_URI' \
     -F 'code=CODE' \
     https://api.instagram.com/oauth/access_token
     */
    
    NSString *fullPathString = [OAuthHostURL stringByAppendingString:NM_AccessTokenPath];
    
    NSDictionary *parameters = @{[NM_ParameterClientID removeLastCharacter] : INSTAGRAM_CLIENT_ID,
                                 NM_ParameterClientSecret : INSTAGRAM_CLIENT_SECRET,
                                 NM_ParameterGrantType : INSTAGRAM_GRANT_TYPE,
                                 [NM_ParameterRedirectURI removeLastCharacter] : INSTAGRAM_REDIRECT_URI,
                                 [NM_ParameterCode removeLastCharacter] : [[NSUserDefaults standardUserDefaults] valueForKey:INSTAGRAM_CODE]};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:fullPathString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [[NSUserDefaults standardUserDefaults] setValue:responseObject[kAccessToken] forKey:INSTAGRAM_ACCESS_TOKEN];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:INSTAGRAM_ACCESS_TOKEN_RECEIVED];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[DDDataManager sharedManager] saveUserProfile:responseObject[kUser]];
    
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", [error localizedDescription]);
    }];
}

#pragma mark - Requests

- (void)searchForTagsByName:(NSString *)tagsByName completionHandler:(CompletionBlock)completionHandler {
    
    // https://api.instagram.com/v1/tags/search?q=snowy&access_token=ACCESS-TOKEN
    
    NSString *pathString = [NSString stringWithFormat:@"search?q=%@&%@%@", tagsByName, [NM_AccessTokenPath stringByAppendingString:@"=" ], [[NSUserDefaults standardUserDefaults] valueForKey:INSTAGRAM_ACCESS_TOKEN]];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:TagsHostURL]];
    [manager GET:pathString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *dataArray = responseObject[kTagsData];
        __block NSMutableArray *tagsByNameArray = [[NSMutableArray alloc] init];
#warning обработка полученных данных должна происходить не в API клиенте
        [dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [tagsByNameArray addObject:obj[kTagsName]];
        }];
        completionHandler(YES, tagsByNameArray, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", [error localizedDescription]);
    }];
}

- (void)loadImagesWithTag:(NSString *)tag completionHandler:(CompletionBlock)completionHandler {
    
    self.myTag = tag;
    
    // https://api.instagram.com/v1/tags/{tag-name}/media/recent?access_token=ACCESS-TOKEN
    
    NSString *pathString = (!self.nextURL) ? [NSString stringWithFormat:@"%@%@/media/recent?%@%@&count=5", TagsHostURL, tag, [NM_AccessTokenPath stringByAppendingString:@"=" ], [[NSUserDefaults standardUserDefaults] valueForKey:INSTAGRAM_ACCESS_TOKEN]] : self.nextURL;
    
    __weak typeof(self) weakSelf = self;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:pathString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        weakSelf.nextURL = responseObject[kTagsPagination][kTagsNextURL];
        completionHandler (YES, responseObject[kTagsData], nil);
        
#warning этого здесь не должно быть
        if (tag) {
            [[DDDataManager sharedManager] insertItemsToCoreDataFromArray:responseObject[kTagsData]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", [error localizedDescription]);
    }];
}

@end