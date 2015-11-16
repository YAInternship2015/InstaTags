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

static CGFloat const TransitionDuration = 1.3;

typedef enum LoginUserState {
    Login,
    LogedIn
} LoginUserState;

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(swapViewController) name:NotificationUserProfileSaved object:nil];
    
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

- (CGRect)frameForCharacterController {
    return self.view.bounds;
}

#pragma mark - Actions

- (void)swapViewController {
    [self.currentViewController willMoveToParentViewController:nil];
    [self addChildViewController:self.logedInController];
    self.logedInController.view.frame = CGRectMake(CGRectGetMaxX(self.logedInController.view.frame),
                                                   0.f,
                                                   CGRectGetWidth(self.logedInController.view.frame),
                                                   175.f);
    [self transitionFromViewController:self.currentViewController toViewController:self.logedInController duration:TransitionDuration options:0 animations:^{
        self.logedInController.view.frame = self.currentViewController.view.frame;
        self.currentViewController.view.frame = CGRectMake(-(CGRectGetMaxX(self.currentViewController.view.frame)),
                                                           0.f,
                                                           CGRectGetWidth(self.currentViewController.view.frame),
                                                           175.f);
    } completion:^(BOOL finished) {
        [self.currentViewController removeFromParentViewController];
        self.currentViewController = self.logedInController;
        [self.currentViewController didMoveToParentViewController:self];
    }];
}

@end