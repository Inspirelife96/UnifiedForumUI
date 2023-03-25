//
//  UFUIPostQueryHeaderView.h
//  INSParseUI
//
//  Created by XueFeng Chen on 2022/3/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class UFUISplitLineView;
@class UFUIPostQueryHeaderView;
@class UFUIPostQueryHeaderViewModel;

@protocol UFUIPostQueryHeaderViewDelegate <NSObject>

@optional
- (void)clickAvatarButtonInPostQueryHeaderView:(UFUIPostQueryHeaderView *)postQueryHeaderView;
- (void)clickFollowStatusButtonInPostQueryHeaderView:(UFUIPostQueryHeaderView *)postQueryHeaderView;
- (void)clickUserNameButtonInPostQueryHeaderView:(UFUIPostQueryHeaderView *)postQueryHeaderView;
- (void)clickFileCollectionViewIndexPath:(NSIndexPath *)indexPath inPostQueryHeaderView:(UFUIPostQueryHeaderView *)postQueryHeaderView;

@end

@interface UFUIPostQueryHeaderView : UIView <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UILabel *titleLabel; // Topic标题

@property (nonatomic, strong) UIButton *avatarButton; // Topic发布者的头像，可点击跳转到发布者的用户界面
@property (nonatomic, strong) UIButton *userNameButton; // Topic发布者名字，可点击跳转到发布者的用户界面
@property (nonatomic, strong) UIButton *followStatusButton; // 当前登录用户与发布者的关注关系，发布者是登录用户时，不显示
@property (nonatomic, strong) UILabel *timestampLabel; // Topic发布时间戳

@property (nonatomic, strong) UILabel *contentLabel; // Topic内容
@property (nonatomic, strong) UICollectionView *fileContentCollectionView; // 多媒体资源

@property (nonatomic, strong) UFUISplitLineView *splitLineView; // 分割线

@property (nonatomic, strong) UFUIPostQueryHeaderViewModel *postQueryHeaderVM;

@property (nonatomic, weak) id<UFUIPostQueryHeaderViewDelegate> delegate; // 交互代理

- (void)configWithPostQueryHeaderViewModel:(UFUIPostQueryHeaderViewModel *)postQueryHeaderVM;

@end

NS_ASSUME_NONNULL_END
