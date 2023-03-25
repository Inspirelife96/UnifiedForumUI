//
//  UFUIUserProfileEditHeaderView.h
//  UnifiedForumUI-INSParseUI
//
//  Created by XueFeng Chen on 2021/10/24.
//

#import <UIKit/UIKit.h>

@class UFUIUserProfileEditViewModel;

NS_ASSUME_NONNULL_BEGIN

// 由代理处理点击按钮的事件
@protocol UFUIUserProfileEditHeaderViewDelegate <NSObject>

- (void)changeBackgroundImage;
- (void)changeAvatarImage;

@end

@interface UFUIUserProfileEditHeaderView : UIView

@property (nonatomic, weak) id<UFUIUserProfileEditHeaderViewDelegate> delegate;

- (void)configWithUserProfileEditViewModel:(UFUIUserProfileEditViewModel *)userProfileEditVM;

@end

NS_ASSUME_NONNULL_END
