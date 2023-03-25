//
//  UFUIReplyQueryHeaderView.h
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2023/2/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class UFUIReplyQueryHeaderView;
@class UFUIReplyQueryHeaderViewModel;
@class UFUISplitLineView;

@protocol UFUIReplyQueryHeaderViewDelegate <NSObject>

- (void)clickAvatarButtonInHeaderView:(UFUIReplyQueryHeaderView *)headerView;
- (void)clickUserNameButtonInHeaderView:(UFUIReplyQueryHeaderView *)headerView;
- (void)clickLikeButtonInHeaderView:(UFUIReplyQueryHeaderView *)headerView;
- (void)clickMoreButtonInHeaderView:(UFUIReplyQueryHeaderView *)headerView;
- (void)clickFileCollectionViewAtIndexPath:(NSIndexPath *)indexPath inHeaderView:(UFUIReplyQueryHeaderView *)headerView;

@end

@interface UFUIReplyQueryHeaderView : UIView

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

// 分割线
@property (nonatomic, strong) UFUISplitLineView *splitLineView;

// 视图模型
@property (nonatomic, strong) UFUIReplyQueryHeaderViewModel *replyQueryHeaderVM;

// 代理
@property (nonatomic, weak) id<UFUIReplyQueryHeaderViewDelegate> delegate;

// 根据视图模型配置视图
- (void)configWithReplyQueryHeaderViewModel:(UFUIReplyQueryHeaderViewModel *)replyQueryHeaderVM;

// 更新Like按钮的状态
- (void)updateLikeButton;

@end

NS_ASSUME_NONNULL_END
