//
//  UFUIReplyQueryFooterView.h
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2023/2/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class UFUIReplyQueryFooterView;
@class UFUISplitLineView;

@protocol UFUIReplyQueryFooterViewDelegate <NSObject>

- (void)clickReplyTextFieldInReplyQueryFooterView:(UFUIReplyQueryFooterView *)replyQueryFooterView;

@end

@interface UFUIReplyQueryFooterView : UIView <UITextFieldDelegate>

// 登录用户的头像
@property (nonatomic, strong) UIImageView *avatarImageView;

// 编辑框
@property (nonatomic, strong) UITextField *replyTextField;

// 顶部的分割先
@property (nonatomic, strong) UFUISplitLineView *splitLineView;

// 编辑容器，包含avatarImageView和replyTextField
@property (nonatomic, strong) UIView *editContainerView;

// 交互代理
@property (nonatomic, weak) id<UFUIReplyQueryFooterViewDelegate> delegate;

// 该视图不需要视图模型进行配置，唯一需要展示的是左侧的登录用户的头像，直接配置了

@end

NS_ASSUME_NONNULL_END
