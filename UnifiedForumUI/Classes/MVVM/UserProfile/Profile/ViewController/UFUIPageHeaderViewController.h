//
//  UFUIPageHeaderViewController.h
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2023/3/9.
//

#import <UIKit/UIKit.h>

#import "UFUIPageHeaderView.h"

@class YHPageViewController;
@class YHPageScrollView;
@class UFUIPageHeaderView;

NS_ASSUME_NONNULL_BEGIN


@protocol UFUIPageHeaderViewControllerProtocol <NSObject>

- (UIView<UFUIPageHeaderViewProtocol> *)pageHeaderView;
- (void(^)(CGFloat offsetY))pageHeaderViewControllerScrollBlock;

@end

@interface UFUIPageHeaderViewController : UIViewController <UFUIPageHeaderViewControllerProtocol>

@property (nonatomic, strong, readonly) YHPageViewController *pageViewController;

@property (nonatomic, strong, readonly) YHPageScrollView *scrollView;

@end

NS_ASSUME_NONNULL_END
