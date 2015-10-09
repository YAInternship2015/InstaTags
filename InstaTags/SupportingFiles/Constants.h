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


#pragma mark - Instagram API

static NSString *const INSTAGRAM_URL_SCHEME             = @"instatags";
static NSString *const INSTAGRAM_CODE                   = @"INSTAGRAM_CODE";
static NSString *const INSTAGRAM_ACCESS_TOKEN_RECEIVED  = @"INSTAGRAM_ACCESS_TOKEN_RECEIVED";

#pragma mark - Stroryboard IDs

static NSString *const DDInstagramViewerControllerID    = @"DDInstagramViewerControllerID";
static NSString *const DDTableViewControllerID          = @"DDTableViewControllerID";
static NSString *const DDCollectionViewControllerID     = @"DDCollectionViewControllerID";

#pragma mark - Segue identifiers

static NSString *const SegueIdentifierTableController       = @"SegueIdentifierTableController";
static NSString *const SegueIdentifierCollectionController  = @"SegueIdentifierCollectionController";

#pragma mark - CoreData

static NSString *const EntityDDModel = @"DDModel";
static NSString *const kPostID = @"post_id";

#pragma mark - User profile

static NSString *const kUserFullName                = @"full_name";
static NSString *const kUserProfilePicture          = @"profile_picture";
static NSString *const NotificationUserProfileSaved = @"NotificationUserProfileSaved";

#endif