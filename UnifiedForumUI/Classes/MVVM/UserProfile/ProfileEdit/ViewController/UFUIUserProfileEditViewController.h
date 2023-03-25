//
//  UFUIUserProfileEditViewController.h
//  UnifiedForumUI-INSParseUI
//
//  Created by XueFeng Chen on 2021/10/24.
//

#import "UFUIPageViewController.h"

@class UFMUserModel;

NS_ASSUME_NONNULL_BEGIN

@interface UFUIUserProfileEditViewController : UFUIPageViewController

- (instancetype)initWithUserModel:(UFMUserModel *)userModel;

@end

NS_ASSUME_NONNULL_END
