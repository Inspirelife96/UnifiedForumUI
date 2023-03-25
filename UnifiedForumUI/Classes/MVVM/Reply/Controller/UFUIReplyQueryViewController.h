//
//  UFUIReplyQueryViewController.h
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2023/2/18.
//

#import "UFUIQueryViewController.h"

@class UFUIReplyQueryViewModel;
@class UFUIReplyQueryHeaderView;
@class UFUIReplyQuerySectionView;
@class UFUIReplyQueryFooterView;
@class UFUIReplyQueryAddReplyToPostView;
@class UFUIReplyQueryAddReplyToReplyView;

NS_ASSUME_NONNULL_BEGIN

@interface UFUIReplyQueryViewController : UFUIQueryViewController

// 同父类的queryVM，基于一个给定的Post，返回他的Replies。
@property (nonatomic, strong) UFUIReplyQueryViewModel *replyQueryVM;

// 顶部展示给定的Post的内容
@property (nonatomic, strong) UFUIReplyQueryHeaderView *replyQueryHeaderView;

// Section展示该Post有多少条回复
@property (nonatomic, strong) UFUIReplyQuerySectionView *replyQuerySectionView;

// 不是TableView的FooterView，而是整个视图底部用于交互的一个工具条，点击后会弹出回复Post的界面
@property (nonatomic, strong) UFUIReplyQueryFooterView *replyQueryFooterView;

// 向Post添加Reply
@property (nonatomic, strong) UFUIReplyQueryAddReplyToPostView *addReplyToPostView;

// 向指定的Reply添加Reply
@property (nonatomic, strong) UFUIReplyQueryAddReplyToReplyView *addReplyToReplyView;

// 辅助按钮，点击后撤销从底部弹出的addReplyToPostView或者addReplyToReplyView
@property (nonatomic, strong) UIButton *dismissAddViewButton;

@end

NS_ASSUME_NONNULL_END
