//
//  DDContainerHeaderView.m
//  InstaTags
//
//  Created by Dmitriy Demchenko on 11/16/15.
//  Copyright © 2015 Dmitriy Demchenko. All rights reserved.
//

#import "DDContainerHeaderView.h"
#import "DDLogedInController.h"
#import "DDLoginController.h"
#import "DDUser.h"

typedef enum LoginUserState {
    Login,
    LogedIn
} LoginUserState;

static CGFloat const AnimateDuration = 1.3f;

@interface DDContainerHeaderView ()

@property (nonatomic, strong) DDLogedInController *logedInController;
@property (nonatomic, strong) DDLoginController *loginController;
@property (nonatomic, strong) UIViewController *currentViewController;
@property (nonatomic, assign) LoginUserState loginUserState;

@end

@implementation DDContainerHeaderView

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(swapViewControllers:) name:NotificationUserProfileSaved object:nil];
    
    self.loginUserState = ([DDUser MR_countOfEntities]) ? LogedIn : Login;
    
    self.loginController = [self.storyboard instantiateViewControllerWithIdentifier:DDLoginControllerID];
    self.logedInController = [self.storyboard instantiateViewControllerWithIdentifier:DDLogedInControllerID];
    
    [self presentController:(self.loginUserState == LogedIn) ? self.logedInController : self.loginController];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - ContainerViewController methods

- (void)presentController:(UIViewController *)controller {
    if (self.currentViewController) {
        [self removeCurrentViewController];
    }
    [self addChildViewController:controller];
    controller.view.frame = [self frameForCharacterController];
    [self.view addSubview:controller.view];
    self.currentViewController = controller;
    [controller didMoveToParentViewController:self];
}

- (void)removeCurrentViewController {
    [self.currentViewController willMoveToParentViewController:nil];
    [self.currentViewController.view removeFromSuperview];
    [self.currentViewController removeFromParentViewController];
}

- (void)swapCurrentControllerWith:(UIViewController *)controller {
    
    __block CGRect tempRect;
    tempRect.origin.x = 0.f;
    tempRect.origin.y = CGRectGetHeight([UIScreen mainScreen].bounds) * 2;
    tempRect.size = CGSizeMake(CGRectGetWidth(controller.view.frame), CGRectGetHeight(controller.view.frame));
    
    [self.currentViewController willMoveToParentViewController:nil];
    [self addChildViewController:controller];
    controller.view.frame = tempRect;
    [self.view addSubview:controller.view];
    
    [UIView animateWithDuration:AnimateDuration animations:^{
        
        controller.view.frame = self.currentViewController.view.frame;
        tempRect.origin.y = -(CGRectGetHeight([UIScreen mainScreen].bounds) * 2);
        self.currentViewController.view.frame = tempRect;
        
    } completion:^(BOOL finished) {
        
        [self.currentViewController.view removeFromSuperview];
        [self.currentViewController removeFromParentViewController];
        self.currentViewController = controller;
        [self.currentViewController didMoveToParentViewController:self];
    }];
}

- (CGRect)frameForCharacterController {
    return self.view.bounds;
}

#pragma mark - Actions

- (void)swapViewControllers:(UINavigationItem *)navigationItem {
    if (self.loginUserState == Login) {
        [self swapCurrentControllerWith:self.loginController];
        self.loginUserState = LogedIn;
    } else {
        [self swapCurrentControllerWith:self.logedInController];
        self.loginUserState = Login;
    }
}

@end