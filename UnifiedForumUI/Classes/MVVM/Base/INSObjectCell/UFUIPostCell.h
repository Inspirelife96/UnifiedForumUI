//
//  UFUIPostCell.h
//  INSParseUI
//
//  Created by XueFeng Chen on 2022/2/25.
//

#import "UFUIObjectCell.h"

NS_ASSUME_NONNULL_BEGIN

@class UFUIPostCell;
@class UFUISplitLineView;

@protocol UFUIPostCellDelegate <NSObject>

- (void)clickAvatarButtonInCell:(UFUIPostCell *)postCell;
- (void)clickUserNameButtonInCell:(UFUIPostCell *)postCell;
- (void)clickLikeButtonInCell:(UFUIPostCell *)postCell;
- (void)clickMoreButtonInCell:(UFUIPostCell *)postCell;
- (void)clickFileCollectionViewAtIndexPath:(NSIndexPath *)indexPath inCell:(UFUIPostCell *)postCell;
- (void)clickReplyTableViewAtIndexPath:(NSIndexPath *)indexPath inCell:(UFUIPostCell *)postCell;
- (void)clickMoreReplyButtonInCell:(UFUIPostCell *)postCell;

@end

@interface UFUIPostCell : UFUIObjectCell

// 发布者信息
@property (nonatomic, strong) UIButton *avatarButton;
@property (nonatomic, strong) UIButton *userNameButton;
@property (nonatomic, strong) UILabel *timestampLabel;

// 交互按钮
@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) UIButton *moreButton;

// Post内容
@property (nonatomic, strong) UILabel *contentLabel;

// 多媒体资源
@property (nonatomic, strong) UICollectionView *fileCollectionView;

// 回复信息
@property (nonatomic, strong) UITableView *replyTableView;
@property (nonatomic, strong) UIView *replyTableFooterView;
@property (nonatomic, strong) UIButton *moreReplyButton;

@property (nonatomic, strong) UFUISplitLineView *splitLineView;

- (void)updateLikeButton;

@end

NS_ASSUME_NONNULL_END
