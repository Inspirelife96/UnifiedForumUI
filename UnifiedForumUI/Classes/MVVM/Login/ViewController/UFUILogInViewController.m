//
//  UFUILogInViewController.m
//  UFUIParseUI
//
//  Created by XueFeng Chen on 2021/6/30.
//

#import "UFUILogInViewController.h"

#import "UFUILogInView.h"

#import "UFUILogInViewModel.h"

#import "UFUIConstants.h"

#import "UIViewController+OpenLinkInSafari.h"
#import "SCLAlertView+ShowOnMostTopViewController.h"

#import "UFUIUFMServiceErrorHandler.h"

#import <AuthenticationServices/AuthenticationServices.h>

@interface UFUILogInViewController () <ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding, UFUILogInViewDelegate>

@property (nonatomic, strong) UFUILogInView *logInView;

@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic, strong) UFUILogInViewModel *logInVM;

@end

@implementation UFUILogInViewController

- (instancetype)initWithLogInViewModel:(UFUILogInViewModel *)logInVM {
    if (self = [super init]) {
        _logInVM = logInVM;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.logInView];
    [self.view addSubview:self.closeButton];

    [self.logInView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.right.equalTo(self.view).with.offset(-20.0f);
        make.width.mas_equalTo(24.0f);
        make.height.mas_equalTo(24.0f);
    }];
}

#pragma mark Actions

// 关闭按钮
- (void)clickCloseButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 使用苹果账户登录，按照苹果的Login with Apple ID流程
-(void)loginWithAppleID API_AVAILABLE(ios(13.0)) {
    ASAuthorizationAppleIDProvider *provider = [[ASAuthorizationAppleIDProvider alloc]init];
    ASAuthorizationAppleIDRequest * request = [provider createRequest];
    request.requestedScopes = @[ASAuthorizationScopeFullName,ASAuthorizationScopeEmail];
    ASAuthorizationController *authorizationController= [[ASAuthorizationController alloc]initWithAuthorizationRequests:@[request]];
    authorizationController.delegate = self;
    authorizationController.presentationContextProvider = self;
    [authorizationController performRequests];
}

// 匿名登录
- (void)loginWithAnonymous {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.view setUserInteractionEnabled:NO];
    
    [self.logInVM loginAnonymousInBackground:^(NSError *error) {
        // 异步完成，取消进度条，允许交互
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.view setUserInteractionEnabled:YES];

        if (!error) {
            [[NSNotificationCenter defaultCenter] postNotificationName:UFUIUserLoginNotification object:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self _showLogInFailedAlertView:[UFUIUFMServiceErrorHandler errorMessage:error.code]];
        }
    }];
}

// 账户登录
- (void)login {
    NSString *title = KUFUILocalization(@"logInAlertView.titleLabel.text");
    NSString *subTitle = KUFUILocalization(@"logInAlertView.subTitleLabel.text");
    NSString *userNameFieldPlaceholder = KUFUILocalization(@"logInAlertView.userNameField.placeholder");
    NSString *passwordFieldPlaceholder = KUFUILocalization(@"logInAlertView.passwordField.placeholder");
    NSString *loginButtonTitle = KUFUILocalization(@"logInAlertView.loginButton.title");
    NSString *closeButtonTitle = KUFUILocalization(@"logInAlertView.closeButton.title");
    
    SCLAlertView *loginAlertView = [[SCLAlertView alloc] init];
    
    loginAlertView.shouldDismissOnTapOutside = YES;
    
    SCLTextView *userNameField = [loginAlertView addTextField:userNameFieldPlaceholder];
    userNameField.keyboardType = UIKeyboardTypeDefault;
    
    SCLTextView *passwordField = [loginAlertView addTextField:passwordFieldPlaceholder];
    passwordField.keyboardType = UIKeyboardTypeDefault;
    passwordField.secureTextEntry = YES;
    
    [loginAlertView addButton:loginButtonTitle validationBlock:^BOOL{
        self.logInVM.userName = userNameField.text;
        self.logInVM.password = passwordField.text;
        
        NSString *errorMessage = @"";
        
        if (![self.logInVM checkUserName:&errorMessage]) {
            [self _showLogInFailedAlertView:errorMessage];
            [userNameField becomeFirstResponder];
            return NO;
        }
        
        if (![self.logInVM checkPassword:&errorMessage]) {
            [self _showLogInFailedAlertView:errorMessage];
            [passwordField becomeFirstResponder];
            return NO;
        }
        
        return YES;
    } actionBlock:^{
        // 显示进度条，禁止UI交互，等待异步处理完成
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.view setUserInteractionEnabled:NO];
        
        [self.logInVM loginInBackground:^(NSError *error) {
            // 异步完成，取消进度条，允许交互
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.view setUserInteractionEnabled:YES];

            if (!error) {
                [[NSNotificationCenter defaultCenter] postNotificationName:UFUIUserLoginNotification object:nil];
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                [self _showLogInFailedAlertView:[UFUIUFMServiceErrorHandler errorMessage:error.code]];
            }
        }];
    }];
    
    [loginAlertView ufui_showEditOnMostTopViewControllerWithTitle:title subTitle:subTitle closeButtonTitle:closeButtonTitle duration:0];
}

- (void)signUp {
    NSString *title = KUFUILocalization(@"signUpAlertView.titleLabel.text");
    NSString *subTitle = KUFUILocalization(@"signUpAlertView.subTitleLabel.text");
    NSString *userNameFieldPlaceholder = KUFUILocalization(@"signUpAlertView.userNameField.placeholder");
    NSString *passwordFieldPlaceholder = KUFUILocalization(@"signUpAlertView.passwordField.placeholder");
    NSString *emailFieldPlaceholder = KUFUILocalization(@"signUpAlertView.emailField.placeholder");
    NSString *signUpButtonTitle = KUFUILocalization(@"signUpAlertView.signupButton.title");
    NSString *userTermButtonTitle = KUFUILocalization(@"signUpAlertView.userTermButton.title");
    NSString *closeButtonTitle = KUFUILocalization(@"signUpAlertView.closeButton.title");
    
    SCLAlertView *signUpAlertView = [[SCLAlertView alloc] init];

    signUpAlertView.shouldDismissOnTapOutside = YES;
    
    SCLTextView *userNameField = [signUpAlertView addTextField:userNameFieldPlaceholder];
    userNameField.keyboardType = UIKeyboardTypeDefault;
    
    SCLTextView *passwordField = [signUpAlertView addTextField:passwordFieldPlaceholder];
    passwordField.keyboardType = UIKeyboardTypeDefault;
    passwordField.secureTextEntry = YES;

    SCLTextView *emailField = [signUpAlertView addTextField:emailFieldPlaceholder];
    emailField.keyboardType = UIKeyboardTypeEmailAddress;

    [signUpAlertView addButton:signUpButtonTitle validationBlock:^BOOL{

        self.logInVM.userName = userNameField.text;
        self.logInVM.password = passwordField.text;
        self.logInVM.email = emailField.text;
        
        NSString *errorMessage = @"";
        
        if (![self.logInVM checkUserName:&errorMessage]) {
            [self _showSignUpFailedAlertView:errorMessage];
            [userNameField becomeFirstResponder];
            return NO;
        }
        
        if (![self.logInVM checkPassword:&errorMessage]) {
            [self _showSignUpFailedAlertView:errorMessage];
            [passwordField becomeFirstResponder];
            return NO;
        }
        
        if (![self.logInVM checkEmail:&errorMessage]) {
            [self _showSignUpFailedAlertView:errorMessage];
            [emailField becomeFirstResponder];
            return NO;
        }
        
        return YES;
    } actionBlock:^{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.view setUserInteractionEnabled:NO];
        
        [self.logInVM signUpInBackground:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.view setUserInteractionEnabled:YES];

            if (!error) {
                [[NSNotificationCenter defaultCenter] postNotificationName:UFUIUserLoginNotification object:nil];
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                [self _showLogInFailedAlertView:[UFUIUFMServiceErrorHandler errorMessage:error.code]];
            }
        }];
    }];
    
    [signUpAlertView addButton:userTermButtonTitle actionBlock:^{
        [self ufui_openLinkInSafari:self.logInVM.userTermLink];
    }];
    
    [signUpAlertView ufui_showEditOnMostTopViewControllerWithTitle:title subTitle:subTitle closeButtonTitle:closeButtonTitle duration:0];
}

- (void)resetPassword {
    NSString *title = KUFUILocalization(@"resetPasswordAlertView.titleLabel.text");
    NSString *subTitle = KUFUILocalization(@"resetPasswordAlertView.subTitleLabel.text");
    NSString *emailFieldPlaceholder = KUFUILocalization(@"resetPasswordAlertView.emailField.placeholder");
    NSString *sendButtonTitle = KUFUILocalization(@"resetPasswordAlertView.resetPasswordButton.title");
    NSString *closeButtonTitle = KUFUILocalization(@"resetPasswordAlertView.closeButton.title");
    
    SCLAlertView *resetPasswordAlertView = [[SCLAlertView alloc] init];

    resetPasswordAlertView.shouldDismissOnTapOutside = YES;
    
    SCLTextView *emailField = [resetPasswordAlertView addTextField:emailFieldPlaceholder];
    emailField.keyboardType = UIKeyboardTypeEmailAddress;
    
    [resetPasswordAlertView addButton:sendButtonTitle validationBlock:^BOOL{
        self.logInVM.email = emailField.text;
        NSString *errorMessage = @"";
        if (![self.logInVM checkEmail:&errorMessage]) {
            [self _showResetPasswordFailedAlertView:errorMessage];
            return NO;
        }

        return YES;
    } actionBlock:^{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.view setUserInteractionEnabled:NO];
        
        WEAKSELF
        [self.logInVM requestPasswordResetForEmailInBackground:^(NSError *error) {
            STRONGSELF
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [strongSelf.view setUserInteractionEnabled:YES];

            if (!error) {
                [self _showResetPasswordSucceedAlertView];
            } else {
                [self _showResetPasswordFailedAlertView:[UFUIUFMServiceErrorHandler errorMessage:error.code]];
            }
        }];
    }];
    
    [resetPasswordAlertView ufui_showEditOnMostTopViewControllerWithTitle:title subTitle:subTitle closeButtonTitle:closeButtonTitle duration:0];
}

#pragma mark ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding

-(ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller
API_AVAILABLE(ios(13.0)){
    return  self.view.window;
}

-(void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization
API_AVAILABLE(ios(13.0)){
    if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
        ASAuthorizationAppleIDCredential * credential = authorization.credential;
        NSString *state = credential.state;
        NSString * userID = credential.user;
        NSPersonNameComponents *fullName = credential.fullName;
        NSString * email = credential.email;
        // refresh token
        NSString * authorizationCode = [[NSString alloc]initWithData:credential.authorizationCode encoding:NSUTF8StringEncoding];
        // access token
        NSString * identityToken = [[NSString alloc]initWithData:credential.identityToken encoding:NSUTF8StringEncoding];
        ASUserDetectionStatus realUserStatus = credential.realUserStatus;
        NSLog(@"state: %@", state);
        NSLog(@"userID: %@", userID);
        NSLog(@"fullName: %@", fullName);
        NSLog(@"email: %@", email);
        NSLog(@"authorizationCode: %@", authorizationCode);
        NSLog(@"identityToken: %@", identityToken);
        NSLog(@"realUserStatus: %@", @(realUserStatus));
        
        NSDictionary *authData = @{
            @"id":userID,
            @"token":identityToken
        };
        
        self.logInVM.authType = @"apple";
        self.logInVM.authData = authData;
        self.logInVM.userName = fullName.familyName;
        self.logInVM.email = email;
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];

        [self.view setUserInteractionEnabled:NO];
        
        [self.logInVM loginWithAppleAuthDataInBackground:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.view setUserInteractionEnabled:YES];

            if (!error) {
                [[NSNotificationCenter defaultCenter] postNotificationName:UFUIUserLoginNotification object:nil];
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                [self _showLogInFailedAlertView:[UFUIUFMServiceErrorHandler errorMessage:error.code]];
            }
        }];
    }
}

- (BOOL)restoreAuthenticationWithAuthData:(nullable NSDictionary<NSString *, NSString *> *)authData {
    NSLog(@"authData = %@", authData);
    return YES;
}

#pragma mark- 授权失败的回调
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error API_AVAILABLE(ios(13.0)){
    NSString *errorMessage = nil;
    switch (error.code) {
        case ASAuthorizationErrorCanceled:
            errorMessage = KUFUILocalization(@"logInFailedAlertView.subTitleLabel.text.ASAuthorizationErrorCanceled");
            break;
        case ASAuthorizationErrorFailed:
            errorMessage = KUFUILocalization(@"logInFailedAlertView.subTitleLabel.text.ASAuthorizationErrorFailed");
            break;
        case ASAuthorizationErrorInvalidResponse:
            errorMessage = KUFUILocalization(@"logInFailedAlertView.subTitleLabel.text.ASAuthorizationErrorInvalidResponse");
            break;
        case ASAuthorizationErrorNotHandled:
            errorMessage = KUFUILocalization(@"logInFailedAlertView.subTitleLabel.text.ASAuthorizationErrorNotHandled");
            break;
        case ASAuthorizationErrorUnknown:
            errorMessage = KUFUILocalization(@"logInFailedAlertView.subTitleLabel.text.ASAuthorizationErrorUnknown");
            break;
    }
    
    [self _showLogInFailedAlertView:errorMessage];
}

#pragma mark Private Methods

- (void)_showLogInFailedAlertView:(NSString *)alertViewSubTitle {
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    NSString *title = KUFUILocalization(@"logInFailedAlertView.titleLabel.text");
    NSString *closeButtonTitle = KUFUILocalization(@"logInFailedAlertView.closeButton.title");
    [alert ufui_showErrorOnMostTopViewControllerWithTitle:title subTitle:alertViewSubTitle closeButtonTitle:closeButtonTitle duration:0.0f];
}

- (void)_showSignUpFailedAlertView:(NSString *)alertViewSubTitle {
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    NSString *title = KUFUILocalization(@"signUpFailedAlertView.titleLabel.text");
    NSString *closeButtonTitle = KUFUILocalization(@"signUpFailedAlertView.closeButton.title");
    [alert ufui_showErrorOnMostTopViewControllerWithTitle:title subTitle:alertViewSubTitle closeButtonTitle:closeButtonTitle duration:0.0f];
}

- (void)_showResetPasswordSucceedAlertView {
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    NSString *title = KUFUILocalization(@"resetPasswordSucceedAlertView.titleLabel.text");
    NSString *subTitle = KUFUILocalization(@"resetPasswordSucceedAlertView.subTitleLabel.text");
    NSString *closeButtonTitle = KUFUILocalization(@"resetPasswordSucceedAlertView.closeButton.title");
    [alert ufui_showSuccessOnMostTopViewControllerWithTitle:title subTitle:subTitle closeButtonTitle:closeButtonTitle duration:0.0f];
}

- (void)_showResetPasswordFailedAlertView:(NSString *)alertViewSubTitle {
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    NSString *title = KUFUILocalization(@"resetPasswordFailedAlertView.titleLabel.text");
    NSString *closeButtonTitle = KUFUILocalization(@"resetPasswordFailedAlertView.closeButton.title");
    [alert ufui_showErrorOnMostTopViewControllerWithTitle:title subTitle:alertViewSubTitle closeButtonTitle:closeButtonTitle duration:0.0f];
}

#pragma mark Getter/Setter

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [[UIButton alloc] init];
        UIImageSymbolConfiguration *imageSymbolConfig = [UIImageSymbolConfiguration configurationWithPointSize:24.0f];
        [_closeButton setImage:[UIImage systemImageNamed:@"xmark.circle.fill" withConfiguration:imageSymbolConfig] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(clickCloseButton:) forControlEvents:UIControlEventTouchUpInside];
        [_closeButton setUserInteractionEnabled:YES];
    }
    
    return _closeButton;
}

- (UFUILogInView *)logInView {
    if (!_logInView) {
        _logInView = [[UFUILogInView alloc] initWithLoginViewModel:self.logInVM];
        _logInView.delegate = self;
    }
    
    return _logInView;
}

@end
