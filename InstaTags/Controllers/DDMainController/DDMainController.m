//
//  DDMainController.m
//  InstaTags
//
//  Created by Dmitriy Demchenko on 11/13/15.
//  Copyright © 2015 Dmitriy Demchenko. All rights reserved.
//

#import "DDMainController.h"
#import "LoginView.h"
#import "LogedInView.h"
#import "DDInstagramViewerController.h"
#import "DDUser.h"
#import "DDTagsDataSource.h"
#import "DDPostsDataSource.h"
#import "DDInputValidator.h"

#import "DDUser.h"
#import "DDUser+FetchingEntity.h"
#import <SDWebImage/UIImageView+WebCache.h>

typedef enum LoginUserState {
    Login,
    LogedIn
} LoginUserState;

@interface DDMainController () <DDTagsDataSourceDelegate>

@property (nonatomic, weak) IBOutlet LoginView *loginView;
@property (nonatomic, weak) IBOutlet LogedInView *logedInView;
@property (nonatomic, weak) IBOutlet UITextField *searchTagsTextField;
@property (nonatomic, weak) IBOutlet UIButton *showPhotosButton;
@property (nonatomic, weak) IBOutlet UIPickerView *pickerView;
@property (nonatomic, strong) IBOutlet UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, strong) IBOutlet DDTagsDataSource *tagsDataSource;
//@property (nonatomic, assign) BOOL loginUserState;
@property (nonatomic, strong) NSString *selectTag;
@property (nonatomic, strong) DDPostsDataSource *postsDataSource;

@end

@implementation DDMainController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLoginUserState) name:NotificationUserProfileSaved object:nil];
#warning TODO
    self.searchTagsTextField.layer.borderColor = [UIColor appBorderColor].CGColor;
    [self.pickerView setShowsSelectionIndicator:YES];
    [self.pickerView setVisible:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Setters

- (void)setLoginView:(LoginView *)loginView {
    loginView.hidden = ([DDUser MR_countOfEntities]) ? YES: NO;
}

- (void)setLogedInView:(LogedInView *)logedInView {
    logedInView.hidden = (![DDUser MR_countOfEntities]) ? YES : NO;
}

- (void)setTapGestureRecognizer:(UITapGestureRecognizer *)tapGestureRecognizer {
    [tapGestureRecognizer addTarget:self action:@selector(dismissKeyboard)];
}

- (void)setShowPhotosButton:(UIButton *)showPhotosButton {
    showPhotosButton.layer.borderColor = [UIColor appButtonColor].CGColor;
    [showPhotosButton addTarget:self action:@selector(showPhotosAction) forControlEvents:UIControlEventTouchUpInside];
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

#pragma mark - Private methods

- (void)dismissKeyboard {
    [self.searchTagsTextField resignFirstResponder];
}

- (void)changeLoginUserState {
    self.loginView.hidden = YES;
    self.logedInView.hidden = NO;
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
    if (self.selectTag) {
        [self.showPhotosButton setVisible:YES animated:YES];
    }
}

#pragma mark - Actions

- (void)showPhotosAction {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak typeof(self) weakSelf = self;
    self.postsDataSource = [[DDPostsDataSource alloc] init];
    [self.postsDataSource requestPostsWithTag:self.selectTag completion:^(BOOL success) {
        if (success) {
            DDInstagramViewerController *controller = (DDInstagramViewerController *)[self.storyboard instantiateViewControllerWithIdentifier:DDInstagramViewerControllerID];
            controller.tagStringForTitle = [weakSelf.selectTag capitalizedString];
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            [weakSelf.navigationController pushViewController:controller animated:YES];
        } else {
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        }
    }];
}

@end