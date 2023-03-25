//
//  UFUITimeLineAddTopicCell.h
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2023/2/20.
//

#import "UFUITimeLineCell.h"

NS_ASSUME_NONNULL_BEGIN

@class UFUITimeLineHeaderView;

@class UFUITimeLineAddTopicCell;

@interface UFUITimeLineAddTopicCell : UFUITimeLineCell

// timeLine信息
@property (nonatomic, strong) UFUITimeLineHeaderView *timeLineHeaderView;

// Topic预览
@property (nonatomic, strong) UIButton *topicButton;
@property (nonatomic, strong) UILabel *topicTitleLabel; // Topic标题
@property (nonatomic, strong) UIImageView *topicMediaImageView; // Topic内容
@property (nonatomic, strong) UILabel *topicContentLabel; // Topic内容
@property (nonatomic, strong) UIButton *topicPostInfoButton;
@property (nonatomic, strong) UIButton *topicLikeInfoButton;
@property (nonatomic, strong) UIButton *topicShareInfoButton;

@end

NS_ASSUME_NONNULL_END
