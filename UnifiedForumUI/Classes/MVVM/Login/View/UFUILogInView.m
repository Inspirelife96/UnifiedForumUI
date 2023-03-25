//
//  UFUILogInView.m
//  Bolts
//
//  Created by XueFeng Chen on 2021/6/30.
//

#import "UFUILogInView.h"

#import "UFUILogInLogoView.h"

#import "UFUILoginViewModel.h"

#import <AuthenticationServices/AuthenticationServices.h>

@interface UFUILogInView ()

@property (nonatomic, strong) UFUILogInLogoView *logoView;
@property (nonatomic, strong) UIImageView *backgroundImageView;

@property (nonatomic, strong) ASAuthorizationAppleIDButton *loginWithAppleIDButton;
@property (nonatomic, strong) UILabel *orLabel;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIButton *anonymousLoginButton;
@property (nonatomic, strong) UIButton *signUpButton;
@property (nonatomic, strong) UIButton *resetPasswordButton;

@end

@implementation UFUILogInView

- (instancetype)initWithLoginViewModel:(UFUILogInViewModel *)logInVM {
    if (self = [super initWithFrame:CGRectZero]) {
        _logInVM = logInVM;
        [self buildUI];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self buildUI];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
    }
    
    return self;
}

- (void)buildUI {
    [self addSubview:self.logoView];
    [self addSubview:self.loginWithAppleIDButton];
    [self addSubview:self.orLabel];
    [self addSubview:self.loginButton];
    [self addSubview:self.anonymousLoginButton];
    [self addSubview:self.signUpButton];
    [self addSubview:self.resetPasswordButton];
    
    [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    // AppleID登录剧中显示
    [self.loginWithAppleIDButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).with.offset(80.0f);
        make.height.mas_equalTo(40.0f);
        make.width.mas_equalTo(ceil([UIScreen jk_width] * 0.618));
    }];

    [self.orLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loginWithAppleIDButton.mas_bottom).with.offset(20.0f);
        make.left.equalTo(self.loginWithAppleIDButton);
        make.right.equalTo(self.loginWithAppleIDButton);
        make.height.mas_equalTo(30.0f);
    }];

    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.orLabel.mas_bottom);
        make.left.equalTo(self.loginWithAppleIDButton);
        make.right.equalTo(self.loginWithAppleIDButton);
        make.height.mas_equalTo(40.0f);
    }];
    
    [self.anonymousLoginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loginButton.mas_bottom);
        make.left.equalTo(self.loginWithAppleIDButton);
        make.right.equalTo(self.loginWithAppleIDButton);
        make.height.mas_equalTo(self.loginButton);
    }];
    
    [self.signUpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_safeAreaLayoutGuideBottom).with.offset(-32.0f);
        make.left.equalTo(self).with.offset(16.0f);
        make.width.mas_equalTo(([UIScreen jk_width] - 32.0f)/3.0f);
        make.height.mas_equalTo(24.0f);
    }];

    [self.resetPasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.signUpButton);
        make.right.equalTo(self).with.offset(-16.0f);
        make.width.mas_equalTo(self.signUpButton);
        make.height.mas_equalTo(self.signUpButton);
    }];
    
    // 如果不支持匿名登录的话，隐藏匿名登录按钮
    if (!self.logInVM.enableAnonymousLogin) {
        [self.anonymousLoginButton setHidden:YES];
    } else {
        [self.anonymousLoginButton setHidden:NO];
    }
}

#pragma mark UI Actions

// 使用苹果账户登录，按照苹果的Login with Apple ID流程
-(void)clickSignInWithAppleButton API_AVAILABLE(ios(13.0)) {
    if (self.delegate && [self.delegate respondsToSelector:@selector(loginWithAppleID)]) {
        [self.delegate loginWithAppleID];
    }
}

- (void)clickLogInButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(login)]) {
        [self.delegate login];
    }
}

- (void)clickAnonymousLoginButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(loginWithAnonymous)]) {
        [self.delegate loginWithAnonymous];
    }
}

- (void)clickSignUpButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(signUp)]) {
        [self.delegate signUp];
    }
}

- (void)clickResetPasswordButton {
    if (self.delegate && [self.delegate respondsToSelector:@selector(resetPassword)]) {
        [self.delegate resetPassword];
    }
}

#pragma mark Getter/Setter

- (UFUILogInLogoView *)logoView {
    if (!_logoView) {
        _logoView = [[UFUILogInLogoView alloc] initWithLogoImage:self.logInVM.logoImage];
    }
    
    return _logoView;
}

- (ASAuthorizationAppleIDButton *)loginWithAppleIDButton  API_AVAILABLE(ios(13.0)){
    if (!_loginWithAppleIDButton) {
        if (@available(iOS 13.0, *)) {
            _loginWithAppleIDButton = [[ASAuthorizationAppleIDButton alloc]initWithAuthorizationButtonType:ASAuthorizationAppleIDButtonTypeSignIn authorizationButtonStyle:self.logInVM.appleIDButtonStyle];
            
            [_loginWithAppleIDButton addTarget:self action:@selector(clickSignInWithAppleButton) forControlEvents:UIControlEventTouchUpInside];
        } else {
            // Fallback on earlier versions
        }
    }
    
    return _loginWithAppleIDButton;
}

- (UILabel *)orLabel {
    if (!_orLabel) {
        _orLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        
        _orLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
        _orLabel.textColor = [UIColor secondaryLabelColor];
        _orLabel.text = self.logInVM.orLabelTitle;
        _orLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _orLabel;
}

- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [[UIButton alloc] initWithFrame:CGRectZero];
        _loginButton.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
        [_loginButton setTitleColor:[UIColor labelColor] forState:UIControlStateNormal];
        [_loginButton setTitle:self.logInVM.loginButtonTitle forState:UIControlStateNormal];
        [_loginButton addTarget:self action:@selector(clickLogInButton) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _loginButton;
}

- (UIButton *)anonymousLoginButton {
    if (!_anonymousLoginButton) {
        _anonymousLoginButton = [[UIButton alloc] initWithFrame:CGRectZero];
        _anonymousLoginButton.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
        [_anonymousLoginButton setTitleColor:[UIColor secondaryLabelColor] forState:UIControlStateNormal];
        [_anonymousLoginButton setTitle:self.logInVM.anonymousLoginButtonTitle forState:UIControlStateNormal];
        [_anonymousLoginButton addTarget:self action:@selector(clickAnonymousLoginButton) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _anonymousLoginButton;
}

- (UIButton *)signUpButton {
    if (!_signUpButton) {
        _signUpButton = [[UIButton alloc] initWithFrame:CGRectZero];
        _signUpButton.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
        [_signUpButton setTitleColor:[UIColor secondaryLabelColor] forState:UIControlStateNormal];
        _signUpButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_signUpButton setTitle:self.logInVM.signupButtonTitle forState:UIControlStateNormal];
        [_signUpButton addTarget:self action:@selector(clickSignUpButton) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _signUpButton;
}

- (UIButton *)resetPasswordButton {
    if (!_resetPasswordButton) {
        _resetPasswordButton = [[UIButton alloc] initWithFrame:CGRectZero];
        _resetPasswordButton.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
        [_resetPasswordButton setTitleColor:[UIColor secondaryLabelColor] forState:UIControlStateNormal];
        _resetPasswordButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_resetPasswordButton setTitle:self.logInVM.resetPasswordButtonTitle forState:UIControlStateNormal];
        [_resetPasswordButton addTarget:self action:@selector(clickResetPasswordButton) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _resetPasswordButton;
}

@end
