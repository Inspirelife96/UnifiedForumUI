//
//  UFUILogInViewModel.h
//  UFUIParseUI
//
//  Created by XueFeng Chen on 2021/6/30.
//

#import <Foundation/Foundation.h>

#import <AuthenticationServices/AuthenticationServices.h>

NS_ASSUME_NONNULL_BEGIN

@interface UFUILogInViewModel : NSObject

@property (nonatomic, strong) UIImage *logoImage;
@property (nonatomic, copy) NSString *orLabelTitle;
@property (nonatomic, copy) NSString *loginButtonTitle;
@property (nonatomic, copy) NSString *anonymousLoginButtonTitle;
@property (nonatomic, copy) NSString *signupButtonTitle;
@property (nonatomic, copy) NSString *resetPasswordButtonTitle;
@property (nonatomic, assign) ASAuthorizationAppleIDButtonStyle appleIDButtonStyle;
@property (nonatomic, copy) NSString *userTermLink;

@property (nonatomic, assign) BOOL enableAnonymousLogin;

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *email;

@property (nonatomic, copy) NSString *authType;
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> *authData;

- (BOOL)checkUserName:(NSString * _Nonnull *_Nullable)errorMessage;
- (BOOL)checkPassword:(NSString * _Nonnull *_Nullable)errorMessage;
- (BOOL)checkEmail:(NSString * _Nonnull *_Nullable)errorMessage;

- (void)loginInBackground:(void(^)(NSError *error))refreshUIBlock;
- (void)signUpInBackground:(void(^)(NSError *error))refreshUIBlock;
- (void)loginWithAppleAuthDataInBackground:(void(^)(NSError *error))refreshUIBlock;
- (void)loginAnonymousInBackground:(void(^)(NSError *error))refreshUIBlock;
- (void)requestPasswordResetForEmailInBackground:(void(^)(NSError *error))refreshUIBlock;

@end

NS_ASSUME_NONNULL_END
