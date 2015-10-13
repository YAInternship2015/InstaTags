//
//  DDAuthenticationManager.m
//  InstaTags
//
//  Created by Dmitriy Demchenko on 10/13/15.
//  Copyright (c) 2015 Dmitriy Demchenko. All rights reserved.
//

#import "DDAuthenticationManager.h"
#import "AFNetworking.h"
#import "DDApiConstants.h"
#import "DDDataManager.h"

static NSString *const INSTAGRAM_URL_SCHEME     = @"instatags";
static NSString *const INSTAGRAM_CLIENT_ID      = @"15cc709935094bfaa0e14f485fee38da";
static NSString *const INSTAGRAM_REDIRECT_URI   = @"instatags://instagram/authentication";

static NSString *const OAuthHostURL             = @"https://api.instagram.com/oauth/";

static NSString *const NM_AuthorizationPath     = @"authorize/";
static NSString *const NM_ParameterClientID     = @"client_id=";
static NSString *const NM_ParameterRedirectURI  = @"redirect_uri=";
static NSString *const NM_ResponseType          = @"response_type=code";

static NSString *const NM_ParameterCode         = @"code=";


@interface DDAuthenticationManager ()

@property (nonatomic, strong) NSString *instagramCode;

@end


@implementation DDAuthenticationManager // tWGC3uLpB4nhUt

#pragma mark - Puplic methods

// 1
- (void)directUserToAuthorizationURL {
    // https://api.instagram.com/oauth/authorize/?client_id=CLIENT-ID&redirect_uri=REDIRECT-URI&response_type=code
    
    NSString *receivingAccessTokenURL = [NSString stringWithFormat:@"%@%@?%@%@&%@%@&%@", OAuthHostURL, NM_AuthorizationPath, NM_ParameterClientID, INSTAGRAM_CLIENT_ID, NM_ParameterRedirectURI, INSTAGRAM_REDIRECT_URI, NM_ResponseType];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:receivingAccessTokenURL]];
}

// 3
- (BOOL)getInstagramCodeWithURL:(NSURL *)url {
    
    BOOL success;
    
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
            success = NO;
        }
    }
    return success;
}

#pragma mark - Private methods
// 4
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

// 5
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
        
        [[NSUserDefaults standardUserDefaults] setValue:responseObject[kAccessToken] forKey:INSTAGRAM_ACCESS_TOKEN];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:INSTAGRAM_ACCESS_TOKEN_RECEIVED];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self saveUserProfile:responseObject[kUser]];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", [error localizedDescription]);
    }];
}

- (void)saveUserProfile:(NSDictionary *)userProfile {
    
    [[NSUserDefaults standardUserDefaults] setValue:userProfile[kUserFullName] forKey:kUserFullName];
    [[NSUserDefaults standardUserDefaults] setValue:userProfile[kUserProfilePicture] forKey:kUserProfilePicture];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationUserProfileSaved object:nil];
}

@end
