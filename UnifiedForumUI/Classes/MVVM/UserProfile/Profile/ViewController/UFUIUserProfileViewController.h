//
//  UFUIUserProfileViewController.h
//  Bolts
//
//  Created by XueFeng Chen on 2021/7/5.
//

#import "UFUIPageHeaderViewController.h"

@class UFMUserModel;
@class UFUIUserProfileViewModel;

NS_ASSUME_NONNULL_BEGIN

@interface UFUIUserProfileViewController : UFUIPageHeaderViewController

@property (nonatomic, strong) UFMUserModel *userModel;
@property (nonatomic, strong) UFUIUserProfileViewModel *userProfileVM;

- (instancetype)init;
- (instancetype)initWithUserModel:(UFMUserModel *)userModel;
- (instancetype)initWithUserProfileViewModel:(UFUIUserProfileViewModel *)userProfileVM;

@end

NS_ASSUME_NONNULL_END
