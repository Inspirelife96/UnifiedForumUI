//
//  UFPFService+User.h
//  UFPFParse
//
//  Created by XueFeng Chen on 2021/6/24.
//

#import "UFPFService.h"

NS_ASSUME_NONNULL_BEGIN

@interface UFPFService (User)

/**
 登录

 可以由error判断登录是否成功
 登录成功后可以调用[PFUser currentUser]获取当前的登录用户

 @param userName 用户名
 @param password 密码
 @param error 出错信息
 */
+ (void)logInWithUsername:(NSString *)userName password:(NSString *)password error:(NSError **)error;

/**
 使用Apple ID进行第三方登录

 由于使用Apple ID进行登录时，用户可以进行取消，因此添加了返回值代表登录是否执行（YES）/取消（NO）
 登录成功后可以调用[PFUser currentUser]获取当前的登录用户

 @param authType 用户名
 @param authData 密码
 @param error 出错信息
 
 @return 执行（YES）/取消（NO）
 */
+ (BOOL)loginWithAppleAuthType:(NSString *)authType authData:(NSDictionary<NSString *, NSString *> *)authData error:(NSError **)error;

/**
 匿名登录

 @param error 出错信息
 */
+ (void)logInWithAnonymous:(NSError **)error;

/**
 匿名用户升级，注意，调用此API必须保证当前登录用户是匿名用户，否则会直接出断言错误，请调用者务必小心。

 @param userName 用户名
 @param password 密码
 @param email 邮箱
 @param error 出错信息
 */
+ (void)upgradeCurrentAnonymousUserWithUsername:(NSString *)userName password:(NSString *)password email:(NSString *)email error:(NSError **)error;

/**
 新用户注册

 @param userName 用户名
 @param password 密码
 @param email 邮箱
 @param error 出错信息
 */
+ (void)signUpWithUsername:(NSString *)userName password:(NSString *)password email:(NSString *)email error:(NSError **)error;

/**
 退出登录
 */
+ (void)logOut;

/**
 重制密码

 @param email 邮箱
 @param error 出错信息
 */
+ (void)requestPasswordResetForEmail:(NSString *)email error:(NSError **)error;

/**
 注销账户
 */
+ (void)unsubscribe:(NSError **)error;


+ (PFQuery *)buildUserQueryWhereUserIsDeleted;

+ (PFQuery *)buildUserQueryWhereUserIsLocked;

@end

NS_ASSUME_NONNULL_END
