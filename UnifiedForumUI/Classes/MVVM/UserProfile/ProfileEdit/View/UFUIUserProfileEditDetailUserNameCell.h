//
//  UFUIUserProfileEditDetailUserNameCell.h
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2021/10/25.
//

#import <UIKit/UIKit.h>

@class UFUIUserProfileEditViewModel;

NS_ASSUME_NONNULL_BEGIN

@interface UFUIUserProfileEditDetailUserNameCell : UITableViewCell

- (void)configWithUserProfileEditViewModel:(UFUIUserProfileEditViewModel *)userProfileEditVM;

@end

NS_ASSUME_NONNULL_END
