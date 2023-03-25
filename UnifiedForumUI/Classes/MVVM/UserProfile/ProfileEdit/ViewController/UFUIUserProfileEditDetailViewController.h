//
//  UFUIUserProfileEditDetailViewController.h
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2021/10/25.
//

#import <UIKit/UIKit.h>

#import "UFUIPageView.h"

@class UFUIUserProfileEditViewModel;

NS_ASSUME_NONNULL_BEGIN

@interface UFUIUserProfileEditDetailViewController : UIViewController <UFUIPageContentViewControllerProtocol>

- (instancetype)initWithUserProfileEditViewModel:(UFUIUserProfileEditViewModel *)userProfileEditVM;

@end

NS_ASSUME_NONNULL_END
