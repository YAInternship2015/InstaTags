//
//  DDInstagramViewerController.m
//  InstaTags
//
//  Created by Dmitriy Demchenko on 9/27/15.
//  Copyright (c) 2015 Dmitriy Demchenko. All rights reserved.
//

#import "DDInstagramViewerController.h"
#import "DDContainerViewController.h"

static NSString *const EmbedContainer = @"EmbedContainer";

@interface DDInstagramViewerController ()

@property (nonatomic, strong) DDContainerViewController *containerViewController;

@end


@implementation DDInstagramViewerController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.topItem.title = @"";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = self.tagStringForTitle;
}


#pragma mark - UIViewController methods

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:EmbedContainer]) {
        self.containerViewController = segue.destinationViewController;
    }
}

#pragma mark - IBActions

- (IBAction)changeView:(id)sender {
    [self.containerViewController swapViewControllers:self.navigationItem];
}

@end