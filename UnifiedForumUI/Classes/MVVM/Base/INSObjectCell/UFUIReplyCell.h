//
//  UFUIReplyCell.h
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2023/2/19.
//

#import "UFUIObjectCell.h"

@class UFUIReplyCell;
@class UFUISplitLineView;

NS_ASSUME_NONNULL_BEGIN

@protocol UFUIReplyCelDelegate <NSObject>

- (void)clickAvatarButtonInCell:(UFUIReplyCell *)replyCell;
- (void)clickUserNameButtonInCell:(UFUIReplyCell *)replyCell;
- (void)clickLikeButtonInCell:(UFUIReplyCell *)replyCell;
- (void)clickMoreButtonInCell:(UFUIReplyCell *)replyCell;

@end

@interface UFUIReplyCell : UFUIObjectCell

// 发布者信息
@property (nonatomic, strong) UIButton *avatarButton;
@property (nonatomic, strong) UIButton *userNameButton;
@property (nonatomic, strong) UILabel *timestampLabel;

// 交互按钮
@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) UIButton *moreButton;

// Post内容
@property (nonatomic, strong) UILabel *contentLabel;

// 分割线
@property (nonatomic, strong) UFUISplitLineView *splitLineView;

- (void)updateLikeButton;

@end

NS_ASSUME_NONNULL_END
