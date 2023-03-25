//
//  UFUIPostQueryAddPostToTopicView.h
//  Bolts
//
//  Created by XueFeng Chen on 2022/1/18.
//

#import <UIKit/UIKit.h>

@class UFUIPostQueryAddPostToTopicView;

@class UFUIPostQueryAddPostToTopicViewModel;
@class UFUISplitLineView;

NS_ASSUME_NONNULL_BEGIN

@protocol UFUIPostQueryAddPostToTopicViewDelegate <NSObject>

- (void)clickPostButtonInAddPostView:(UFUIPostQueryAddPostToTopicView *)addPostView;
- (void)clickAddImageButtonInAddPostView:(UFUIPostQueryAddPostToTopicView *)addPostView;

//- (void)addPost:(UFUIPostQueryAddPostToTopicViewModel *)addPostVM;
//- (void)addImage:(UFUIPostQueryAddPostToTopicViewModel *)addPostVM;

//- (void)sendPost:(UIButton *)postButton;
//- (void)addImage:(UIButton *)addImageButton;

@end

@interface UFUIPostQueryAddPostToTopicView : UIView

// 顶部的分割线
@property (nonatomic, strong) UFUISplitLineView *splitLineView;

// 顶部的文字描述：一般是回复给XXX
@property (nonatomic, strong) UILabel *toLabel;

// 文字输入框
@property (nonatomic, strong) UITextView *postTextView;

// 发送按钮
@property (nonatomic, strong) UIButton *postButton;

// 添加图片按钮
@property (nonatomic, strong) UIButton *addImageButton;

// 视图模型
@property (nonatomic, strong) UFUIPostQueryAddPostToTopicViewModel *addPostVM;

// 代理
@property (weak, nonatomic) id<UFUIPostQueryAddPostToTopicViewDelegate> delegate;

- (void)configWithAddPostViewModel:(UFUIPostQueryAddPostToTopicViewModel *)addPostVM;

// 显示
- (void)show;

// 取消
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
