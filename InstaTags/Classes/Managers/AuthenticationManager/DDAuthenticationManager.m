//
//  DDAuthenticationManager.m
//  InstaTags
//
//  Created by Dmitriy Demchenko on 10/13/15.
//  Copyright (c) 2015 Dmitriy Demchenko. All rights reserved.
//

#import "DDAuthenticationManager.h"
#import "AFNetworking.h"
#import "DDDataManager.h"
#import "DDUserProfileModel.h"  // networkObjectModel
#import "DDUser.h"              // coreDataModel

static NSString *const INSTAGRAM_CLIENT_SECRET  = @"f13aef57842f417c93e05ce2637194fb";
static NSString *const INSTAGRAM_WEBSITE_URL    = @"https://www.facebook.com/snowdima";
static NSString *const INSTAGRAM_SUPPORT_EMAIL  = @"organization_98@yahoo.com";
static NSString *const INSTAGRAM_GRANT_TYPE     = @"authorization_code";
static NSString *const INSTAGRAM_URL_SCHEME     = @"instatags";
static NSString *const INSTAGRAM_CLIENT_ID      = @"15cc709935094bfaa0e14f485fee38da";
static NSString *const INSTAGRAM_REDIRECT_URI   = @"instatags://instagram/authentication";

static NSString *const OAuthHostURL             = @"https://api.instagram.com/oauth/";


@interface DDAuthenticationManager ()

@property (nonatomic, strong) NSString *instagramCode;

@end


@implementation DDAuthenticationManager

#pragma mark - Puplic methods

- (void)authenticationAndLoginUser {
    // https://api.instagram.com/oauth/authorize/?client_id=CLIENT-ID&redirect_uri=REDIRECT-URI&response_type=code
    
    NSString *receivingAccessTokenURL = [NSString stringWithFormat:@"%@%@?%@%@&%@%@&%@", OAuthHostURL, NM_AuthorizationPath, NM_ParameterClientID, INSTAGRAM_CLIENT_ID, NM_ParameterRedirectURI, INSTAGRAM_REDIRECT_URI, NM_ResponseType];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:receivingAccessTokenURL]];
}

- (BOOL)getInstagramCodeFromURL:(NSURL *)url {
    BOOL success = NO;
    if([[url scheme] isEqualToString:INSTAGRAM_URL_SCHEME]) {
        if([[url absoluteString] rangeOfString:@"code="].location != NSNotFound) {
            NSString* authorizationCode = [[url absoluteString] substringFromIndex: NSMaxRange([[url absoluteString] rangeOfString:@"code="])];
            self.instagramCode = authorizationCode;
            [self receiveRedirectFromInstagram];
            success = YES;
        } else {
            if([[url absoluteString] rangeOfString:@"error="].location != NSNotFound) {
                NSLog(@"error occured!");
            }
        }
    }
    return success;
}

#pragma mark - Private methods

- (void)receiveRedirectFromInstagram {
    
    // http://your-redirect-uri?code=CODE
    
    NSString *customScheme = [INSTAGRAM_URL_SCHEME stringByAppendingString:@"://"];
    NSString *fullPath = [NSString stringWithFormat:@"%@?%@%@", customScheme, NM_ParameterCode, self.instagramCode];
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
                                 [NM_ParameterCode removeLastCharacter] : self.instagramCode};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:fullPathString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self saveUserProfileFromResponseObject:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", [error localizedDescription]);
    }];
}

- (void)saveUserProfileFromResponseObject:(id)responseObject {
    DDUserProfileModel *networkObject = [[DDUserProfileModel alloc] init];
    networkObject.objectDictionary = responseObject;
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        DDUser *user = [DDUser MR_createEntityInContext:localContext];
        user.access_token = networkObject.access_token;
        user.username = networkObject.user.username;
        user.full_name = networkObject.user.full_name;
        user.profile_picture = networkObject.user.profile_picture;
    } completion:^(BOOL contextDidSave, NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationUserProfileSaved object:nil];
    }];
}

@end