//
//  UFUIReplyQueryAddReplyToPostView.h
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2023/2/22.
//

#import <UIKit/UIKit.h>

@class UFUIReplyQueryAddReplyToPostView;
@class UFUIReplyQueryAddReplyToPostViewModel;
@class UFUISplitLineView;

NS_ASSUME_NONNULL_BEGIN

@protocol UFUIReplyQueryAddReplyToPostViewDelegate <NSObject>

- (void)clickReplyButtonInAddReplyToPostView:(UFUIReplyQueryAddReplyToPostView *)addReplyToPostView;

@end

// UFUIReplyQueryAddReplyToPostView 和 UFUIReplyQueryAddReplyToReplyView
// 目前看来其实没有特别大的区别，但还是单独设计成类。没有做成继承或者组合的设计。
// 理由就是任何一个具有独立意义的功能视图，都单独处理，因为你不知道下回需求会怎么改。
@interface UFUIReplyQueryAddReplyToPostView : UIView

// 回复Post的内容，单行，格式为“回复：XXXXXX”
@property (nonatomic, strong) UILabel *toLabel;

// 具体回复的内容，由UITextView进行编辑
@property (nonatomic, strong) UITextView *replyTextView;

// 回复按钮
@property (nonatomic, strong) UIButton *replyButton;

// 分割线
@property (nonatomic, strong) UFUISplitLineView *splitLineView;

// 视图模型
@property (nonatomic, strong) UFUIReplyQueryAddReplyToPostViewModel *addReplyToPostVM;

// 代理，交互交由VC去处理
@property (weak, nonatomic) id<UFUIReplyQueryAddReplyToPostViewDelegate> delegate;

// 视图的具体内容由VM来提供
- (void)configWithAddReplyToPostVM:(UFUIReplyQueryAddReplyToPostViewModel *)addReplyToPostVM;

// 显示
- (void)show;

// 取消
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
