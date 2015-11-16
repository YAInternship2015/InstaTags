//
//  DDMainController.m
//  InstaTags
//
//  Created by Dmitriy Demchenko on 11/13/15.
//  Copyright © 2015 Dmitriy Demchenko. All rights reserved.
//

#import "DDMainController.h"
#import "DDInstagramViewerController.h"
#import "DDTagsDataSource.h"
#import "DDPostsDataSource.h"
#import "DDInputValidator.h"
#import "DDContainerHeaderView.h"
#import "DDUser.h"

static NSString *const HeaderContainer = @"HeaderContainer";

@interface DDMainController () <DDTagsDataSourceDelegate>

@property (nonatomic, weak) IBOutlet UITextField *searchTagsTextField;
@property (nonatomic, weak) IBOutlet UIButton *showPhotosButton;
@property (nonatomic, weak) IBOutlet UIPickerView *pickerView;
@property (nonatomic, strong) IBOutlet UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, strong) IBOutlet DDTagsDataSource *tagsDataSource;
@property (nonatomic, strong) NSString *selectTag;
@property (nonatomic, strong) DDPostsDataSource *postsDataSource;
@property (nonatomic, strong) DDContainerHeaderView *containerHeaderView;
@property (nonatomic, assign) BOOL isAnimated;

@end

@implementation DDMainController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupIBOutlets];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogedIn) name:NotificationUserProfileSaved object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

#pragma mark - ContainerHeader methods

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:HeaderContainer]) {
        self.containerHeaderView = segue.destinationViewController;
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSError *error = NULL;
    if ([DDInputValidator validateInputString:textField.text error:&error]) {
        [self.tagsDataSource requestTagsListWithName:[self.searchTagsTextField.text removeWhitespaces]];
    } else {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
    return YES;
}

#pragma mark - DDTagsDataSourceDelegate

- (void)dataSourceDidUpdateContent:(DDTagsDataSource *)dataSource {
    [self.pickerView reloadAllComponents];
    [self.pickerView selectRow:0 inComponent:0 animated:YES];
    [self.pickerView setVisible:YES animated:YES];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)dataSource:(DDTagsDataSource *)dataSource didSelectRowAtIndex:(NSInteger)index{
    self.selectTag = [self.tagsDataSource tagAtIndex:index];
    if (self.selectTag && !self.isAnimated) {
        [self.showPhotosButton setVisible:YES animated:YES];
        [self animateAppearanceForView:self.showPhotosButton duration:0.3];
    }
}

#pragma mark - Actions

- (void)showPhotosAction {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak typeof(self) weakSelf = self;
    self.postsDataSource = [[DDPostsDataSource alloc] init];
    [self.postsDataSource requestPostsWithTag:self.selectTag completion:^(BOOL success) {
        if (success) {
            [weakSelf pushInstagramViewerController];
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        } else {
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        }
    }];
}

#pragma mark - Private methods

- (void)setupIBOutlets {
    self.searchTagsTextField.layer.borderColor = [UIColor appBorderColor].CGColor;
    self.searchTagsTextField.hidden = ([DDUser MR_countOfEntities]) ? NO : YES;
    self.showPhotosButton.layer.borderColor = [UIColor appButtonColor].CGColor;
    [self.tapGestureRecognizer addTarget:self action:@selector(dismissKeyboard)];
    [self.showPhotosButton addTarget:self action:@selector(showPhotosAction) forControlEvents:UIControlEventTouchUpInside];
    [self.pickerView setShowsSelectionIndicator:YES];
    [self.pickerView setVisible:NO];
    [self.showPhotosButton setVisible:NO];
    self.isAnimated = NO;
}

- (void)userLogedIn {
    self.searchTagsTextField.hidden = NO;
}

- (void)dismissKeyboard {
    [self.searchTagsTextField resignFirstResponder];
}

- (void)pushInstagramViewerController {
    DDInstagramViewerController *controller = (DDInstagramViewerController *)[self.storyboard instantiateViewControllerWithIdentifier:DDInstagramViewerControllerID];
    controller.tagStringForTitle = [self.selectTag capitalizedString];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)animateAppearanceForView:(UIView *)view duration:(CFTimeInterval)duration {
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"position.y";
    animation.fromValue = @(CGRectGetMaxY([UIScreen mainScreen].bounds));
    animation.toValue = @(CGRectGetMidY(self.showPhotosButton.frame));
    animation.duration = duration;
    animation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.5:0:0.9:0.7];
    [view.layer addAnimation:animation forKey:@"basic"];
    view.layer.position = CGPointMake(CGRectGetMidX(view.frame), CGRectGetMidY(view.frame));
    self.isAnimated = YES;
}

@end