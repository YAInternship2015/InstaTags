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
#import "DDAuthenticationManager.h"
#import "DDTagsDataSource.h"
#import "DDPostsDataSource.h"
#import "DDInputValidator.h"


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

//@property (nonatomic, assign) BOOL loginUserState;
@property (nonatomic, strong) NSString *selectTag;
@property (nonatomic, strong) DDTagsDataSource *tagsDataSource;
@property (nonatomic, strong) DDPostsDataSource *postsDataSource;

@end

@implementation DDMainController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLoginUserState) name:NotificationUserProfileSaved object:nil];
    self.tagsDataSource = [[DDTagsDataSource alloc] initWithDelegate:self];
    
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

//- (void)setPickerView:(UIPickerView *)pickerView {
//    [pickerView setShowsSelectionIndicator:YES];
//    [pickerView setVisible:NO];
//}

- (void)setShowPhotosButton:(UIButton *)showPhotosButton {
    showPhotosButton.layer.borderColor = [UIColor appButtonColor].CGColor;
//    [showPhotosButton setVisible:NO];
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
//    [self.searchHelpLabel setVisible:NO animated:YES];
    [self.pickerView setVisible:YES animated:YES];
    [self.pickerView reloadAllComponents];
    [self.pickerView selectRow:0 inComponent:0 animated:YES];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.tagsDataSource objectsCount];
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSDictionary *attributes = @{NSFontAttributeName : [UIFont appFontProximanovaRegularWithSize:16.f],
                                 NSForegroundColorAttributeName :[UIColor appSearchFieldColor]};
    return [[NSAttributedString alloc] initWithString:[self.tagsDataSource tagAtIndex:row] attributes:attributes];
}

#pragma mark - UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.selectTag = [self.tagsDataSource tagAtIndex:row];
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