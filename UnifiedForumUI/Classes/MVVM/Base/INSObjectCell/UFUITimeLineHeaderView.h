//
//  UFUITimeLineHeaderView.h
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2023/3/21.
//

#import <UIKit/UIKit.h>

@class UFUITimeLineHeaderViewModel;

NS_ASSUME_NONNULL_BEGIN

@interface UFUITimeLineHeaderView : UIView

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeInfoLabel;

- (void)configWithTimeLineHeaderViewModel:(UFUITimeLineHeaderViewModel *)timeLineHeaderVM;

@end

NS_ASSUME_NONNULL_END
