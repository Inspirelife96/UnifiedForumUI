//
//  UFUITimeLineLikeTopicCell.h
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2023/2/20.
//

#import "UFUITimeLineCell.h"

NS_ASSUME_NONNULL_BEGIN

@class UFUITimeLineLikeTopicCell;

@protocol UFUITimeLineLikeTopicCellDelegate <NSObject>

- (void)clickAvatarButtonInCell:(UFUITimeLineLikeTopicCell *)timeLineLikeTopicCell;
- (void)clickTopicButtonInCell:(UFUITimeLineLikeTopicCell *)timeLineLikeTopicCell;
- (void)clickTopicFromUserButtonInCell:(UFUITimeLineLikeTopicCell *)timeLineLikeTopicCell;

@end

@interface UFUITimeLineLikeTopicCell : UFUITimeLineCell

// 发布者信息
@property (nonatomic, strong) UIButton *avatarButton;
@property (nonatomic, strong) UILabel *titleLabel; // xxxx 赞了文章
@property (nonatomic, strong) UILabel *timestampLabel;

// Topic预览
@property (nonatomic, strong) UILabel *topicTitleLabel; // Topic标题
@property (nonatomic, strong) UILabel *topicContentLabel; // Topic内容
@property (nonatomic, strong) UIButton *topicButton;
@property (nonatomic, strong) UIButton *topicFromUserButton;
@property (nonatomic, strong) UIButton *topicPostInfoButton;
@property (nonatomic, strong) UIButton *topicLikeInfoButton;

@end

NS_ASSUME_NONNULL_END
