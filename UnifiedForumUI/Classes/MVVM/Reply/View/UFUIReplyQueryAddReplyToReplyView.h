//
//  UFUIReplyQueryAddReplyToReplyView.h
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2023/2/22.
//

#import <UIKit/UIKit.h>

@class UFUIReplyQueryAddReplyToReplyView;
@class UFUIReplyQueryAddReplyToReplyViewModel;
@class UFUISplitLineView;

NS_ASSUME_NONNULL_BEGIN

@protocol UFUIReplyQueryAddReplyToReplyViewDelegate <NSObject>

- (void)clickReplyButtonInAddReplyToReplyView:(UFUIReplyQueryAddReplyToReplyView *)addReplyToReplyView;

@end

@interface UFUIReplyQueryAddReplyToReplyView : UIView

// 回复哪个Reply，单行，格式为回复：XXXXXX
@property (nonatomic, strong) UILabel *toLabel;

// 具体回复的内容，由UITextView进行编辑
@property (nonatomic, strong) UITextView *replyTextView;

// 回复按钮
@property (nonatomic, strong) UIButton *replyButton;

// 分割线
@property (nonatomic, strong) UFUISplitLineView *splitLineView;

// 视图模型
@property (nonatomic, strong) UFUIReplyQueryAddReplyToReplyViewModel *addReplyToReplyVM;

// 代理，交由VC去处理
@property (weak, nonatomic) id<UFUIReplyQueryAddReplyToReplyViewDelegate> delegate;

// 视图的具体内容由VM来提供
- (void)configWithAddReplyToReplyVM:(UFUIReplyQueryAddReplyToReplyViewModel *)addReplyToReplyVM;

// 显示
- (void)show;

// 取消
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
