//
//  UFMUserModel.h
//  Bolts
//
//  Created by XueFeng Chen on 2022/10/22.
//

#import "UFMObjectModel.h"

@class UFMFileModel;

NS_ASSUME_NONNULL_BEGIN

@interface UFMUserModel : UFMObjectModel

// Id
@property (nonatomic, copy) NSString *userId;

// 用户名
@property (nonatomic, copy) NSString *username;

// 加入日期
@property (nonatomic, strong) NSDate *joinedAt;

// 浏览次数
@property (nonatomic, assign) NSInteger profileviews;

// 积分
@property (nonatomic, assign) NSInteger reputation;

// 话题数
@property (nonatomic, assign) NSInteger topicCount;

// 回复数
@property (nonatomic, assign) NSInteger postCount;

// 粉丝数
@property (nonatomic, assign) NSInteger followerCount;

// 关注数
@property (nonatomic, assign) NSInteger followingCount;

// 收获的赞
@property (nonatomic, assign) NSInteger likedCount;

// 账号状态：是否锁定
@property (nonatomic, assign) BOOL isLocked;

// 账号状态：是否删除
@property (nonatomic, assign) BOOL isDeleted;

// 头像
@property (nonatomic, strong, nullable) UFMFileModel *avatarImageModel;

// 背景
@property (nonatomic, strong, nullable) UFMFileModel *backgroundImageModel;

// 个性签名
@property (nonatomic, copy, nullable) NSString *bio;

// 是否匿名用户
@property (nonatomic, assign) BOOL isAnonymousUser;

- (BOOL)isEqualToUserModel:(UFMUserModel *)userModel;

- (BOOL)isFollowedByUserModel:(UFMUserModel *)userModel;

- (void)upgradeBio:(NSString * __nullable)bio avatarImage:(UIImage * __nullable)avatarImage backgroundImage:(UIImage * __nullable)backgroundImage error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
