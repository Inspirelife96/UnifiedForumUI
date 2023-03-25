//
//  UFUIPostQueryFilterView.h
//  INSParseUI
//
//  Created by XueFeng Chen on 2021/12/23.
//

#import <UIKit/UIKit.h>

@class UFUIPostQueryFilterView;
@class UFUIPostQueryFilterViewModel;

NS_ASSUME_NONNULL_BEGIN

@protocol UFUIPostQueryFilterViewDelegate <NSObject>

- (void)clickFilterToAllButtonInPostQueryFilterView:(UFUIPostQueryFilterView *)postQueryFilterView;
- (void)clickFilterToTopicHostOnlyButtonInPostQueryFilterView:(UFUIPostQueryFilterView *)postQueryFilterView;
- (void)clickAscendButtonInPostQueryFilterView:(UFUIPostQueryFilterView *)postQueryFilterView;
- (void)clickDescendButtonInPostQueryFilterView:(UFUIPostQueryFilterView *)postQueryFilterView;

@end

@interface UFUIPostQueryFilterView : UIView

@property (nonatomic, strong) UIButton *filterToAllButton;  // 所有Post
@property (nonatomic, strong) UIButton *filterToTopicHostOnlyButton; // 仅显示楼主（Topic Host）发布的Post
@property (nonatomic, strong) UIButton *ascendButton; // 正序
@property (nonatomic, strong) UIButton *descendButton; // 倒序

@property (nonatomic, strong) UFUIPostQueryFilterViewModel *postQueryFilterVM;

@property (nonatomic, weak) id<UFUIPostQueryFilterViewDelegate> delegate;

- (void)configWithPostQueryFilterViewModel:(UFUIPostQueryFilterViewModel *)postQueryFilterVM;

@end

NS_ASSUME_NONNULL_END
