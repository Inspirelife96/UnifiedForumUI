//
//  UFUIUserProfileEditViewModel.h
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2021/10/26.
//

#import <Foundation/Foundation.h>

#import "UFUIConstants.h"

@class UFMUserModel;

NS_ASSUME_NONNULL_BEGIN

@interface UFUIUserProfileEditViewModel : NSObject

@property (nonatomic, strong) UFMUserModel *userModel;

// 核心数据
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *bio;
@property (nonatomic, copy) NSString *avatarImageUrlString;
@property (nonatomic, copy) NSString *backgroundImageUrlString;

// 状态变化
@property (nonatomic, assign) BOOL isBackgroundImageChanged;
@property (nonatomic, assign) BOOL isAvatarImageChanged;
@property (nonatomic, assign) BOOL isBioChanged;

// 更新图片相关
@property (nonatomic, strong) UIImage *selectedAvatarImage;
@property (nonatomic, strong) UIImage *selectedBackgroundImage;

// 匿名登录相关，升级为正式用户
@property (nonatomic, assign) BOOL isAnonymousUser;
@property (nonatomic, assign) BOOL isAccountUpgraded;
@property (nonatomic, copy, nullable) NSString *upgradeUserName;
@property (nonatomic, copy, nullable) NSString *upgradePassword;
@property (nonatomic, copy, nullable) NSString *upgradeEmail;

- (instancetype)initWithUserViewModel:(UFMUserModel *)userModel;

- (void)upgradeAccountInBackgroundWithBlock:(void(^)(NSError *error))refreshUIBlock;

- (void)saveUserProfileInfoInBackgroundWithBlock:(void(^)(NSError *error))refreshUIBlock;

- (BOOL)isProfileInfoChanged;

@end

NS_ASSUME_NONNULL_END
