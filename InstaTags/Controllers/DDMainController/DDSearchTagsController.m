//
//  DDSearchTagsController.m
//  InstaTags
//
//  Created by Dmitriy Demchenko on 9/25/15.
//  Copyright (c) 2015 Dmitriy Demchenko. All rights reserved.
//

#import "DDSearchTagsController.h"
#import "DDInstagramViewerController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "DDAuthenticationManager.h"
#import "DDTagsDataSource.h"
#import "DDPostsDataSource.h"
#import "DDInputValidator.h"
#import "DDUser+FetchingEntity.h"

#warning Из данного замечания реализовал вынос датасорса для пикера, который решил еще одну ошибку с обращением к ApiManager, child - обязательно реализую позже, спасибо за данную рекомендацию, получил понимание практического применения контейнеров
//#warning достаточно "жирный" контроллер, много чего умеет делать. Напрашивается вынос датасорса для пикера и, как вариант, вынос логин-части с профилем пользователя (верхняя часть на экране) в отдельный контроллер, который добавится как child на этот. Если будет время, попробуйте что-то из этого воплотить в жизнь

@interface DDSearchTagsController () <DDTagsDataSourceDelegate>

// before login
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loginActivityIndicator;
@property (nonatomic, weak) IBOutlet UIButton *loginButton;
@property (nonatomic, weak) IBOutlet UILabel *beforeLoginMessageLabel;

// after login
@property (nonatomic, weak) IBOutlet UILabel *userFullNameLabel;
@property (nonatomic, weak) IBOutlet UIImageView *userProfilePicture;
@property (nonatomic, weak) IBOutlet UITextField *searchField; // after login - enable

// before search
@property (nonatomic, weak) IBOutlet UILabel *searchHelpLabel;

// after search
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (nonatomic, weak) IBOutlet UIButton *showPhotosButton;

// base properties
@property (nonatomic, weak) IBOutlet UIView *gradientView;
@property (nonatomic, strong) IBOutlet UITapGestureRecognizer *tap;
@property (nonatomic, strong) CAGradientLayer *gradient;
@property (nonatomic, strong) NSString *selectTag;
@property (nonatomic, strong) DDTagsDataSource *tagsDataSource;
@property (nonatomic, strong) DDPostsDataSource *postsDataSource;

@end


@implementation DDSearchTagsController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tagsDataSource = [[DDTagsDataSource alloc] initWithDelegate:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupOrUpdateViewIfUserLogin) name:NotificationUserProfileSaved object:nil];
    
    if (![DDUser MR_countOfEntities]) {
        [self setupViewIfUserDontLogin];
    } else {
        [self setupOrUpdateViewIfUserLogin];
    }
    
    self.searchField.layer.borderColor = [UIColor appBorderColor].CGColor;
    [self.tap addTarget:self action:@selector(dismissKeyboard)];
    
    self.searchHelpLabel.text = [@"Все очень просто! Начинайте поиск тэгов, выбирайте тэг для просмотра фотографий." localized];
    
    self.gradient = [CAGradientLayer layer];
    self.gradient.frame = self.gradientView.bounds;
    self.gradient.colors = @[(id)[UIColor appBaseBlueColor].CGColor,
                             (id)[UIColor purpleColor].CGColor];
    [self.gradientView.layer insertSublayer:self.gradient atIndex:0];
    
    [self.pickerView setShowsSelectionIndicator:YES];
    [self.pickerView setVisible:NO];
    
    self.showPhotosButton.layer.borderColor = [UIColor appButtonColor].CGColor;
    [self.showPhotosButton setVisible:NO];
    [self.showPhotosButton addTarget:self action:@selector(showPhotosAction) forControlEvents:UIControlEventTouchUpInside];
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

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSError *error = NULL;
    if ([DDInputValidator validateInputString:textField.text error:&error]) {
//#warning вообще работать с API клиентами должны дата менеджеры. Вью контроллер говорит менеджеру "дай мне что-то", менеджер говорит апи клиенту, чтобы тот згарузил данные, затем менеджер как-то обрабатывает полученные данные и возвращает их контроллеру через блоки
#warning добавил tagsDataSource, котрый стал поставщиком для пикера, и который через dataManager пробрасывает запрос в apiManager
        [self.tagsDataSource requestForTagsByName:[self.searchField.text removeWhitespaces]];
    } else {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
    return YES;
}

#pragma mark - DDTagsDataSourceDelegate

- (void)dataWasChanged:(DDTagsDataSource *)dataSource {
    
    [self.searchHelpLabel setVisible:NO animated:YES];
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
    return [self.tagsDataSource countTags];
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSDictionary *attributes = @{NSFontAttributeName : [UIFont appFontProximanovaRegularWithSize:16.f],
                                 NSForegroundColorAttributeName :[UIColor appSearchFieldColor]};
    return [[NSAttributedString alloc] initWithString:[self.tagsDataSource tagForIndex:row] attributes:attributes];
}

#pragma mark - UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.selectTag = [self.tagsDataSource tagForIndex:row];
    if (self.selectTag) {
        [self.showPhotosButton setVisible:YES animated:YES];
    }
}

#pragma mark - Private methods

- (void)setupOrUpdateViewIfUserLogin {
    
    // hide activity
    if ([self.loginActivityIndicator isAnimating]) {
        [self.loginActivityIndicator stopAnimating];
        [self.loginActivityIndicator setVisible:NO animated:YES];
    } else {
        [self.loginActivityIndicator setVisible:NO];
    }
    
    // hide pre-login objects
    [self.loginButton setVisible:NO];
    [self.beforeLoginMessageLabel setVisible:NO];
    
    // show user profile
    [self.userFullNameLabel setVisible:YES animated:YES];
    self.userFullNameLabel.text = [DDUser savedUser].full_name;
//    self.userFullNameLabel.text = [[NSUserDefaults standardUserDefaults] valueForKey:kUserFullName];
    [self.userProfilePicture setVisible:YES animated:YES];
//    [self.userProfilePicture sd_setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:kUserProfilePicture]]];
    [self.userProfilePicture sd_setImageWithURL:[NSURL URLWithString:[DDUser savedUser].profile_picture]];
    
    // search field
    self.searchField.enabled = YES;
}

- (void)setupViewIfUserDontLogin {
    
    self.searchField.enabled = NO;
    
    self.beforeLoginMessageLabel.text = [@"Войдите, чтобы смотреть фотографии." localized];
    
    [self.loginActivityIndicator setVisible:NO];
    [self.userFullNameLabel setVisible:NO];
    [self.loginButton setTitle:[@"войти" localized] forState:UIControlStateNormal];
    [self.loginButton addTarget:self action:@selector(loginInstagramAction) forControlEvents:UIControlEventTouchUpInside];
}

-(void)dismissKeyboard {
    [self.searchField resignFirstResponder];
}

#pragma mark - Actions

- (void)loginInstagramAction {
    
    // hide pre-login message and login button
    [self.loginButton setVisible:NO];
    [self.beforeLoginMessageLabel setVisible:NO];
    
    // activity
    [self.loginActivityIndicator setVisible:YES animated:YES];
    [self.loginActivityIndicator startAnimating];
    
    DDAuthenticationManager *manager = [[DDAuthenticationManager alloc] init];
    [manager authenticationAndLoginUser];
}

- (void)showPhotosAction {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    self.postsDataSource = [[DDPostsDataSource alloc] init];
    [self.postsDataSource requestPostWithTag:self.selectTag completion:^(BOOL success) {
        if (success) {
#warning weakSelf.storyboard
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