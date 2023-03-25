//
//  UFUIUserProfileView.h
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2022/2/19.
//

#import "UFUIPageHeaderView.h"

NS_ASSUME_NONNULL_BEGIN

@class UFMUserModel;
@class UFUIUserProfileViewModel;

@protocol UFUIUserProfileViewDelegate <NSObject>

- (void)follow:(UFUIUserProfileViewModel *)userProfileVM;
- (void)edit:(UFUIUserProfileViewModel *)userProfileVM;
- (void)login:(UFUIUserProfileViewModel *)userProfileVM;
- (void)followInfo:(UFUIUserProfileViewModel *)userProfileVM;
- (void)followedInfo:(UFUIUserProfileViewModel *)userProfileVM;
- (void)topicInfo:(UFUIUserProfileViewModel *)userProfileVM;
- (void)likedInfo:(UFUIUserProfileViewModel *)userProfileVM;

@end

@interface UFUIUserProfileView : UFUIPageHeaderView

@property (nonatomic, strong) UIImageView *backgroundImageView; // 背景图片，可定制，为系统提供给用户选择
@property (nonatomic, strong) UIView *userInfoContainerView; // 圆角背景

@property (nonatomic, strong) UIImageView *iconContainerView; // 用户icon的容器
@property (nonatomic, strong) UIButton *iconButton; // 用户的icon，可定制，由用户上传
@property (nonatomic, strong) UILabel *usernameLabel; // 用户名
@property (nonatomic, strong) UILabel *bioLabel; // 个性签名

@property (nonatomic, strong) UIButton *followButton; // 关注/取消关注按钮
@property (nonatomic, strong) UIButton *editButton; // 编辑按钮
@property (nonatomic, strong) UIButton *loginButton; // 登录按钮

@property (nonatomic, strong) UIButton *followCountButton;
@property (nonatomic, strong) UIButton *followedCountButton;
@property (nonatomic, strong) UIButton *topicCountButton;
@property (nonatomic, strong) UIButton *likedCountButton;

@property (nonatomic, strong) UIView *splitLine1View;
@property (nonatomic, strong) UIView *splitLine2View;
@property (nonatomic, strong) UIView *splitLine3View;

@property (nonatomic, strong) UFUIUserProfileViewModel *userProfileVM;

@property (nonatomic, weak) id<UFUIUserProfileViewDelegate> delegate;

- (void)configWithUserProfileViewModel:(UFUIUserProfileViewModel *)userProfileVM;

@end

NS_ASSUME_NONNULL_END
