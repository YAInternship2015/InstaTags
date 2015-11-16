//
//  Constants.h
//  InstaTags
//
//  Created by Dmitriy Demchenko on 9/25/15.
//  Copyright (c) 2015 Dmitriy Demchenko. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef INSTATAGS_Constants_h
#define INSTATAGS_Constants_h


#pragma mark - Notifications

static NSString *const NotificationUserProfileSaved     = @"NotificationUserProfileSaved";


#pragma mark - Stroryboard IDs

static NSString *const DDInstagramViewerControllerID    = @"DDInstagramViewerControllerID";
static NSString *const DDTableViewControllerID          = @"DDTableViewControllerID";
static NSString *const DDCollectionViewControllerID     = @"DDCollectionViewControllerID";
static NSString *const DDLoginControllerID              = @"DDLoginControllerID";
static NSString *const DDLogedInControllerID            = @"DDLogedInControllerID";

#pragma mark - Segue identifiers

static NSString *const SegueIdentifierTableController       = @"SegueIdentifierTableController";
static NSString *const SegueIdentifierCollectionController  = @"SegueIdentifierCollectionController";

#pragma mark - CoreData

static NSString *const kSavedDate               = @"saved_date";

#pragma mark - Requst parameters and values

static NSString *const NM_AuthorizationPath     = @"authorize/";
static NSString *const NM_AccessTokenPath       = @"access_token";
static NSString *const NM_ParameterClientID     = @"client_id=";
static NSString *const NM_ParameterRedirectURI  = @"redirect_uri=";
static NSString *const NM_ResponseType          = @"response_type=code";
static NSString *const NM_ParameterCode         = @"code=";
static NSString *const NM_ParameterClientSecret = @"client_secret";
static NSString *const NM_ParameterGrantType    = @"grant_type";

#pragma mark - Response keys

static NSString *const kTagsName                = @"name";
static NSString *const kTagsData                = @"data";
static NSString *const kTagsImages              = @"images";
static NSString *const kTagsStandardResolution  = @"standard_resolution";
static NSString *const kTagsURL                 = @"url";
static NSString *const kTagsPagination          = @"pagination";
static NSString *const kTagsNextURL             = @"next_url";

#endif