//
//  UFUIPostQueryFooterView.h
//  Bolts
//
//  Created by XueFeng Chen on 2022/1/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class UFUIPostQueryFooterView;
@class UFUISplitLineView;
@class UFUIPostQueryFooterViewModel;

@protocol UFUIPostQueryFooterViewDelegate <NSObject>

- (void)clickScrollToTopButtonInPostQueryFooterView:(UFUIPostQueryFooterView *)postQueryFooterView;
- (void)clickLikeButtonInPostQueryFooterView:(UFUIPostQueryFooterView *)postQueryFooterView;
- (void)clickShareButtonInPostQueryFooterView:(UFUIPostQueryFooterView *)postQueryFooterView;
- (void)clickPostTextFieldInPostQueryFooterView:(UFUIPostQueryFooterView *)postQueryFooterView;

@end

@interface UFUIPostQueryFooterView : UIView <UITextFieldDelegate>

// 登录用户的头像
@property (nonatomic, strong) UIImageView *avatarImageView;

// 编辑框
@property (nonatomic, strong) UITextField *postTextField;

// 回到顶部按钮
@property (nonatomic, strong) UIButton *scrollToTopButton;

// 点赞按钮
@property (nonatomic, strong) UIButton *likeButton;

// 分享按钮
@property (nonatomic, strong) UIButton *shareButton;

// 顶部的分割先
@property (nonatomic, strong) UFUISplitLineView *splitLineView;

// 视图模型
@property (nonatomic, strong) UFUIPostQueryFooterViewModel *postQueryFooterVM;

// 编辑容器，包含avatarImageView和postTextField
@property (nonatomic, strong) UIView *editContainerView;

// 交互代理
@property (nonatomic, weak) id<UFUIPostQueryFooterViewDelegate> delegate;

// 根据视图模型进行配置
- (void)configWithPostQueryFooterViewModel:(UFUIPostQueryFooterViewModel *)postQueryFooterVM;

@end

NS_ASSUME_NONNULL_END
