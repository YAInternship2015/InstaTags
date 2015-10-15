//
//  DDContainerViewController.m
//  InstaTags
//
//  Created by Dmitriy Demchenko on 9/27/15.
//  Copyright (c) 2015 Dmitriy Demchenko. All rights reserved.
//

#import "DDContainerViewController.h"
#import "DDTableViewController.h"
#import "DDCollectionViewController.h"

static CGFloat const AnimateDuration = 1.3f;

@interface DDContainerViewController ()

@property (nonatomic, strong) DDTableViewController *tableController;
@property (nonatomic, strong) DDCollectionViewController *collectionController;
@property (nonatomic, strong) UIViewController *currentViewController;
#warning сразу не заметил, лучше избавиться от булевой переменной здесь. Можно написать маленький enum, с типом ControllerMode, в котором будут значения tableViewMode и collectionViewMode. Данный контроллер будет хранить переменную такого типа, а в остально все останется также
@property (nonatomic, assign) BOOL isChangeViewController;

@end


@implementation DDContainerViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isChangeViewController = NO;
    
    self.tableController = [self.storyboard instantiateViewControllerWithIdentifier:DDTableViewControllerID];
    self.collectionController = [self.storyboard instantiateViewControllerWithIdentifier:DDCollectionViewControllerID];
    
    [self presentController:self.tableController];
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
    if (!self.isChangeViewController) {
        [self swapCurrentControllerWith:self.collectionController];
        [navigationItem.rightBarButtonItem setImage:[UIImage imageNamed:@"TableViewIcon"]];
        self.isChangeViewController = YES;
    } else {
        [self swapCurrentControllerWith:self.tableController];
        [navigationItem.rightBarButtonItem setImage:[UIImage imageNamed:@"CollectionViewIcon"]];
        self.isChangeViewController = NO;
    }
}

@end