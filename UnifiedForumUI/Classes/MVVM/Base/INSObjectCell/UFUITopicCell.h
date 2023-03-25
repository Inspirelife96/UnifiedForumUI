//
//  UFUITopicCell.h
//  INSParseUI
//
//  Created by XueFeng Chen on 2022/2/15.
//

#import "UFUIObjectCell.h"

@class UFMUserModel;
@class UFUITopicCellViewModel;
@class YBIBImageData;
@class UFUITopicCell;

NS_ASSUME_NONNULL_BEGIN

@protocol UFUITopicCellDelegate <NSObject>

- (void)clickPostButtonInCell:(UFUITopicCell *)topicCell;
- (void)clickLikeButtonInCell:(UFUITopicCell *)topicCell;
- (void)clickShareButtonInCell:(UFUITopicCell *)topicCell;
- (void)clickAvatarButtonInCell:(UFUITopicCell *)topicCell;
- (void)clickUserNameButtonInCell:(UFUITopicCell *)topicCell;
- (void)clickFileCollectionViewIndexPath:(NSIndexPath *)indexPath inCell:(UFUITopicCell *)topicCell;

@end

@interface UFUITopicCell : UFUIObjectCell <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIView *topicViewContainer;

@property (nonatomic, strong) UIButton *avatarButton; // Topic发布者的头像，可点击跳转到发布者的用户界面
@property (nonatomic, strong) UIButton *userNameButton; // Topic发布者名字，可点击跳转到发布者的用户界面
@property (nonatomic, strong) UILabel *timestampLabel; // Topic发布时间戳

@property (nonatomic, strong) UILabel *titleLabel; // Topic标题
@property (nonatomic, strong) UILabel *contentLabel; // Topic内容

@property (nonatomic, strong) UICollectionView *fileCollectionView; // 多媒体资源

@property (nonatomic, strong) UIButton *postButton; // 评论按钮
@property (nonatomic, strong) UIButton *shareButton; // 分享按钮
@property (nonatomic, strong) UIButton *likeButton; // 点赞按钮

@property (nonatomic, strong) UFUITopicCellViewModel *topicCellVM; // TopicCell视图模型

- (void)updateLikeButton;
- (void)updateShareButton;

@end

NS_ASSUME_NONNULL_END
