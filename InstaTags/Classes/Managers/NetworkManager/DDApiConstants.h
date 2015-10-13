//
//  DDApiConstants.h
//  InstaTags
//
//  Created by Dmitriy Demchenko on 9/25/15.
//  Copyright (c) 2015 Dmitriy Demchenko. All rights reserved.
//

//#warning Как файл называется странно. И ему нужно добавить префикс приложения

#import <Foundation/Foundation.h>

#ifndef INSTATAGS_ApiConstants_h
#define INSTATAGS_ApiConstants_h

#pragma mark - Client Info

static NSString *const INSTAGRAM_CLIENT_SECRET  = @"f13aef57842f417c93e05ce2637194fb";
static NSString *const INSTAGRAM_WEBSITE_URL    = @"https://www.facebook.com/snowdima";
static NSString *const INSTAGRAM_SUPPORT_EMAIL  = @"organization_98@yahoo.com";
static NSString *const INSTAGRAM_GRANT_TYPE     = @"authorization_code";

static NSString *const INSTAGRAM_ACCESS_TOKEN   = @"INSTAGRAM_ACCESS_TOKEN";

#pragma mark - Host URL

static NSString *const TagsHostURL =    @"https://api.instagram.com/v1/tags/";

#pragma mark - Authentication request

static NSString *const NM_ParameterClientSecret = @"client_secret";
static NSString *const NM_ParameterGrantType    = @"grant_type";

#pragma mark - Response keys

static NSString *const kAccessToken             = @"access_token";

static NSString *const kUser                    = @"user";

static NSString *const kTagsName                = @"name";
static NSString *const kTagsData                = @"data";
static NSString *const kTagsImages              = @"images";
static NSString *const kTagsStandardResolution  = @"standard_resolution";
static NSString *const kTagsURL                 = @"url";

static NSString *const kTagsPagination          = @"pagination";
static NSString *const kTagsNextURL             = @"next_url";

#endif