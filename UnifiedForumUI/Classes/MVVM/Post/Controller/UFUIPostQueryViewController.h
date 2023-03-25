//
//  UFUIPostQueryViewController.h
//  INSParseUI
//
//  Created by XueFeng Chen on 2021/12/23.
//

#import "UFUIQueryViewController.h"

@class UFUIPostQueryHeaderView;
@class UFUIPostQueryFilterView;
@class UFUIPostQueryFooterView;
@class UFUIPostQueryAddPostToTopicView;
@class UFUIPostQueryAddReplyToPostView;

@class UFUIPostQueryViewModel;

NS_ASSUME_NONNULL_BEGIN

@interface UFUIPostQueryViewController : UFUIQueryViewController 

// 同父类的queryVM
@property (nonatomic, strong) UFUIPostQueryViewModel *postQueryVM;

// TableView的HeaderView，展示Topic的内容
@property (nonatomic, strong) UFUIPostQueryHeaderView *postQueryHeaderView;

// TableView的SectionView的内容，用于筛选排序
@property (nonatomic, strong) UFUIPostQueryFilterView *postQueryFilterView;

// 不是TableView的FooterView，而是整个视图底部用于交互的一个工具条
@property (nonatomic, strong) UFUIPostQueryFooterView *postQueryFooterView;

// 添加Post视图
@property (nonatomic, strong) UFUIPostQueryAddPostToTopicView *addPostView;

// 添加Reply视图
@property (nonatomic, strong) UFUIPostQueryAddReplyToPostView *addReplyView;

// 辅助按钮，撤销从底部弹出的addPostView或者addReplyView
@property (nonatomic, strong) UIButton *dismissAddViewButton;

@end

NS_ASSUME_NONNULL_END
