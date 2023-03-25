//
//  UFUIPostQueryAddReplyToPostView.h
//  INSParseUI
//
//  Created by XueFeng Chen on 2022/2/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class UFUIPostQueryAddReplyToPostView;

@class UFUIPostQueryAddReplyToPostViewModel;
@class UFUIPostCellViewModel;

@class UFUISplitLineView;

@protocol UFUIPostQueryAddReplyToPostViewDelegate <NSObject>

// 向指定的PostCell追加回复（Reply）
- (void)clickReplyButtonInAddReplyView:(UFUIPostQueryAddReplyToPostView *)addReplyView;
//- (void)addReply:(UFUIPostQueryAddReplyToPostViewModel *)addReplyVM toPostCell:(UFUIPostCellViewModel *)postCellVM;

@end

@interface UFUIPostQueryAddReplyToPostView : UIView

// 回复哪个Post或者Reply，单行，格式为回复：XXXXXX
@property (nonatomic, strong) UILabel *toLabel;

// 具体回复的内容，由UITextView进行编辑
@property (nonatomic, strong) UITextView *replyTextView;

// 回复按钮
@property (nonatomic, strong) UIButton *replyButton;

// 分割线
@property (nonatomic, strong) UFUISplitLineView *splitLineView;

// 视图模型
@property (nonatomic, strong) UFUIPostQueryAddReplyToPostViewModel *addReplyVM;

// 代理，交由VC去处理
@property (weak, nonatomic) id<UFUIPostQueryAddReplyToPostViewDelegate> delegate;

// 视图的具体内容由VM来提供
- (void)configWithAddReplyVM:(UFUIPostQueryAddReplyToPostViewModel *)addReplyVM;

// 显示
- (void)show;

// 取消
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
