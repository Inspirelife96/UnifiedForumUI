//
//  UFUIUserProfileEditDetailViewController.m
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2021/10/25.
//

#import "UFUIUserProfileEditDetailViewController.h"

#import "UFUIUserProfileEditDetailBioCell.h"
#import "UFUIUserProfileEditDetailUserIdCell.h"
#import "UFUIUserProfileEditDetailUserNameCell.h"

#import "UFUIUserProfileEditViewModel.h"

#import "UFUIConstants.h"

#import "UFUIUFMServiceErrorHandler.h"

#import "NSString+UFUIInputFieldCheck.h"

#import "UFUIAutoHeightTextView.h"

#import "SCLAlertView+ShowOnMostTopViewController.h"


@interface UFUIUserProfileEditDetailViewController () <UITableViewDataSource, UITableViewDelegate, UFUIUserProfileEditDetailBioCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UFUIUserProfileEditDetailUserIdCell *userIdCell;
@property (nonatomic, strong) UFUIUserProfileEditDetailUserNameCell *userNameCell;
@property (nonatomic, strong) UFUIUserProfileEditDetailBioCell *signatureCell;

@property (nonatomic, strong) UFUIUserProfileEditViewModel *userProfileEditVM;

@end

@implementation UFUIUserProfileEditDetailViewController

- (instancetype)initWithUserProfileEditViewModel:(UFUIUserProfileEditViewModel *)userProfileEditVM {
    if (self = [super init]) {
        _userProfileEditVM = userProfileEditVM;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (UIScrollView *)pageContentScrollView {
    return self.tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return self.userIdCell;
    } else if (indexPath.row == 1) {
        return self.userNameCell;
    } else {
        return self.signatureCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 匿名用户，则提供升级功能
    if (self.userProfileEditVM.isAnonymousUser && indexPath.row == 1) {
        [self upgradeAccount];
    }
}

- (void)upgradeAccount {
    NSString *title = KUFUILocalization(@"upgradeAlertView.title");
    NSString *subTitle = KUFUILocalization(@"upgradeAlertView.subTitle");
    NSString *userNameFieldPlaceholder = KUFUILocalization(@"upgradeAlertView.userNameField.placeholder");
    NSString *passwordFieldPlaceholder = KUFUILocalization(@"upgradeAlertView.passwordField.placeholder");
    NSString *emailFieldPlaceholder = KUFUILocalization(@"upgradeAlertView.emailField.placeholder");
    NSString *signUpButtonTitle = KUFUILocalization(@"upgradeAlertView.upgradeButton.title");
    NSString *closeButtonTitle = KUFUILocalization(@"upgradeAlertView.closeButton.title");
    
    SCLAlertView *upgradeAlertView = [[SCLAlertView alloc] init];
    upgradeAlertView.shouldDismissOnTapOutside = YES;
    
    SCLTextView *userNameField = [upgradeAlertView addTextField:userNameFieldPlaceholder];
    userNameField.keyboardType = UIKeyboardTypeDefault;
    
    SCLTextView *passwordField = [upgradeAlertView addTextField:passwordFieldPlaceholder];
    passwordField.keyboardType = UIKeyboardTypeDefault;
    passwordField.secureTextEntry = YES;

    SCLTextView *emailField = [upgradeAlertView addTextField:emailFieldPlaceholder];
    emailField.keyboardType = UIKeyboardTypeEmailAddress;

    [upgradeAlertView addButton:signUpButtonTitle validationBlock:^BOOL{

        self.userProfileEditVM.upgradeUserName = userNameField.text;
        self.userProfileEditVM.upgradePassword = passwordField.text;
        self.userProfileEditVM.upgradeEmail = emailField.text;
        
        NSString *errorMessage = @"";
        
        if (![userNameField.text ufui_checkUserName:&errorMessage]) {
            [self _showUpgradeFailedAlertView:errorMessage];
            [userNameField becomeFirstResponder];
            return NO;
        }
        
        if (![passwordField.text ufui_checkPassword:&errorMessage]) {
            [self _showUpgradeFailedAlertView:errorMessage];
            [passwordField becomeFirstResponder];
            return NO;
        }
        
        if (![emailField.text ufui_checkEmail:&errorMessage]) {
            [self _showUpgradeFailedAlertView:errorMessage];
            [emailField becomeFirstResponder];
            return NO;
        }
        
        return YES;
    } actionBlock:^{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.view setUserInteractionEnabled:NO];
        
        [self.userProfileEditVM upgradeAccountInBackgroundWithBlock:^(NSError * _Nonnull error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.view setUserInteractionEnabled:YES];
            
            if (error) {
                [self _showUpgradeFailedAlertView:[UFUIUFMServiceErrorHandler errorMessage:error.code]];
            } else {
                [self _showUpgradeSucceedAlertView];
                self.userProfileEditVM.isAnonymousUser = NO;
                self.userProfileEditVM.userName = self.userProfileEditVM.upgradeUserName;
                [self.userNameCell configWithUserProfileEditViewModel:self.userProfileEditVM];
            }
        }];
    }];
    
    [upgradeAlertView ufui_showEditOnMostTopViewControllerWithTitle:title subTitle:subTitle closeButtonTitle:closeButtonTitle duration:0];
}

- (void)_showUpgradeFailedAlertView:(NSString *)alertViewSubTitle {
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    NSString *title = KUFUILocalization(@"upgradeFailedAlertView.titleLabel.text");
    NSString *closeButtonTitle = KUFUILocalization(@"upgradeFailedAlertView.closeButton.title");
    [alert ufui_showErrorOnMostTopViewControllerWithTitle:title subTitle:alertViewSubTitle closeButtonTitle:closeButtonTitle duration:0.0f];
}

- (void)_showUpgradeSucceedAlertView {
    SCLAlertView *upgradeSucceedAlertView = [[SCLAlertView alloc] init];
    NSString *title = KUFUILocalization(@"upgradeSucceedAlertView.titleLabel.text");
    NSString *subTitle = KUFUILocalization(@"upgradeSucceedAlertView.subTitle.text");
    NSString *closeButtonTitle = KUFUILocalization(@"upgradeSucceedAlertView.closeButton.title");
    [upgradeSucceedAlertView ufui_showInfoOnMostTopViewControllerWithTitle:title subTitle:subTitle closeButtonTitle:closeButtonTitle duration:0.0f];
}

#pragma mark UFUITextViewCellDelegate

-(void)textViewCell:(UFUIUserProfileEditDetailBioCell*)cell textHeightChange:(CGFloat)texHeight {
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

-(void)textViewCell:(UFUIUserProfileEditDetailBioCell*)cell textChange:(NSString*)text {
    self.userProfileEditVM.bio = text;
    self.userProfileEditVM.isBioChanged = YES;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 100;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        _tableView.backgroundColor = [UIColor systemBackgroundColor];
        
        //_tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
        //_tableView.theme_backgroundColor = [ThemeColorPicker pickerWithKeyPath:@"UITableView.backgroundColor"];
    }
    
    return _tableView;
}

- (UFUIUserProfileEditDetailUserIdCell *)userIdCell {
    if (!_userIdCell) {
        _userIdCell = [[UFUIUserProfileEditDetailUserIdCell alloc] init];
        [_userIdCell configWithUserProfileEditViewModel:self.userProfileEditVM];
    }
    
    return _userIdCell;
}

- (UFUIUserProfileEditDetailUserNameCell *)userNameCell {
    if (!_userNameCell) {
        _userNameCell = [[UFUIUserProfileEditDetailUserNameCell alloc] init];
        [_userNameCell configWithUserProfileEditViewModel:self.userProfileEditVM];
    }
    
    return _userNameCell;
}

- (UFUIUserProfileEditDetailBioCell *)signatureCell {
    if (!_signatureCell) {
        _signatureCell = [[UFUIUserProfileEditDetailBioCell alloc] init];
        _signatureCell.delegate = self;
        
        [_signatureCell configWithUserProfileEditViewModel:self.userProfileEditVM];
        
//        if (self.userVM.signature && ![self.userVM.signature isEqualToString:@""]) {
//            _signatureCell.signatureTextView.text = self.userVM.signature;
//        }
    }
    
    return _signatureCell;
}

@synthesize pageViewController;

@end
