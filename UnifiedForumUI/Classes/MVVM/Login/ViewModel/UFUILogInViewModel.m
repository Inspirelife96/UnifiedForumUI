//
//  UFUILogInViewModel.m
//  UFUIParseUI
//
//  Created by XueFeng Chen on 2021/6/30.
//

#import "UFUILogInViewModel.h"

#import "NSString+JKNormalRegex.h"

#import "UFUIUFMServiceErrorHandler.h"

#import "UFUIBundle.h"
#import "UFUIConstants.h"
#import "UFUIUFMServiceErrorHandler.h"

@implementation UFUILogInViewModel

- (instancetype)init {
    if (self = [super init]) {
        _logoImage = [UFUIBundle imageNamed:@"logo_default"];
        _orLabelTitle = KUFUILocalization(@"logInView.orLabel.text");
        _loginButtonTitle = KUFUILocalization(@"logInView.loginButton.title");
        _anonymousLoginButtonTitle = KUFUILocalization(@"logInView.anonymousLoginButton.title");
        _signupButtonTitle = KUFUILocalization(@"logInView.signUpButton.title");
        _resetPasswordButtonTitle = KUFUILocalization(@"logInView.resetPasswordButton.title");
        _appleIDButtonStyle = ASAuthorizationAppleIDButtonStyleBlack;
        _enableAnonymousLogin = YES;
        _userTermLink = @"";
        _userName = @"";
        _password = @"";
        _email = @"";
        _authType = @"";
        _authData = @{};
    }
    
    return self;
}

- (BOOL)checkUserName:(NSString **)errorMessage {
    if ([self.userName isEqualToString:@""]) {
        *errorMessage = KUFUILocalization(@"userNameField.text.isEmpty");
        return NO;
    } else {
        return YES;
    }
}

- (BOOL)checkPassword:(NSString **)errorMessage {
    if ([self.password isEqualToString:@""]) {
        *errorMessage = KUFUILocalization(@"passwordField.text.isEmpty");;
        return NO;
    } else {
        return YES;
    }
}

- (BOOL)checkEmail:(NSString **)errorMessage {
    if ([self.email jk_isEmailAddress]) {
        return YES;
    } else {
        *errorMessage = KUFUILocalization(@"emailField.text.isInvalid");;
        return NO;
    }
}

- (void)loginInBackground:(void(^)(NSError *error))refreshUIBlock {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error = nil;
        [UFMService logInWithUsername:self.userName password:self.password error:&error];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            refreshUIBlock(error);
        });
    });
}

- (void)signUpInBackground:(void(^)(NSError *error))refreshUIBlock {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error = nil;
        [UFMService signUpWithUsername:self.userName password:self.password email:self.email error:&error];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            refreshUIBlock(error);
        });
        
    });
}

// 和平常的不同，内部直接调用了PFUser的函数
- (void)loginWithAppleAuthDataInBackground:(void(^)(NSError *error))refreshUIBlock {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error = nil;
        [UFMService loginWithAppleAuthType:self.authType authData:self.authData error:&error];

        dispatch_async(dispatch_get_main_queue(), ^{
            refreshUIBlock(error);
        });
    });
}

- (void)loginAnonymousInBackground:(void(^)(NSError *error))refreshUIBlock {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error = nil;
        [UFMService logInWithAnonymous:&error];

        dispatch_async(dispatch_get_main_queue(), ^{
            refreshUIBlock(error);
        });
    });
}

- (void)requestPasswordResetForEmailInBackground:(void(^)(NSError *error))refreshUIBlock {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *error = nil;
        [UFMService requestPasswordResetForEmail:self.email error:&error];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            refreshUIBlock(error);
        });
        
    });
}

@end
