//
//  DDLoginController.h
//  InstaTags
//
//  Created by Dmitriy Demchenko on 11/16/15.
//  Copyright © 2015 Dmitriy Demchenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginControllerDelegate <NSObject>

@required
- (void)loginAction;

@end

@interface DDLoginController : UIViewController

@property (nonatomic, weak) IBOutlet id <LoginControllerDelegate> delegate;

@end