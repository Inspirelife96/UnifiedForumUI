//
//  UFMService+UserModel.h
//  UFMParseImpl
//
//  Created by XueFeng Chen on 2022/11/8.
//

#import "UFMService.h"

@class UFMUserModel;

NS_ASSUME_NONNULL_BEGIN

@interface UFMService (User)

+ (UFMUserModel *)currentUserModel;

/**
 using user name and password login.
 
 @note No return value, use error to check whether login succeeded or not. Call [UFMService currentUser] to get user if login succeeded.

 @param userName login user name
 @param password login password
 @param error error information if login failed
 */
+ (void)logInWithUsername:(NSString *)userName password:(NSString *)password error:(NSError **)error;

/**
 Logs in a user with third party authentication credentials.

 @note This method shouldn't be invoked directly unless developing a third party authentication library.
 @see PFUserAuthenticationDelegate

 @param authType The name of the type of third party authentication source.
 @param authData The user credentials of the third party authentication source.

 @return login is Cancelled or Completed. Yes if completed or No if Cancelled.
 */
+ (BOOL)loginWithAppleAuthType:(NSString *)authType authData:(NSDictionary<NSString *, NSString *> *)authData error:(NSError **)error;

+ (void)logInWithAnonymous:(NSError **)error;

+ (void)upgradeAnonymousUserWithUsername:(NSString *)userName password:(NSString *)password email:(NSString *)email error:(NSError **)error;

+ (void)signUpWithUsername:(NSString *)userName password:(NSString *)password email:(NSString *)email error:(NSError **)error;

+ (void)logOut;

+ (void)requestPasswordResetForEmail:(NSString *)email error:(NSError **)error;

+ (void)unsubscribe:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
