//
//  LoginView.h
//  InstaTags
//
//  Created by Dmitriy Demchenko on 11/13/15.
//  Copyright © 2015 Dmitriy Demchenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginViewDelegate <NSObject>

@required
- (void)loginAction;

@end


@interface LoginView : UIView

@property (nonatomic, weak) IBOutlet id <LoginViewDelegate> delegate;

@end