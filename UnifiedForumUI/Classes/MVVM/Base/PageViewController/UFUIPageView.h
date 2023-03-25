//
//  UFUIPageView.h
//  UFUITabPageViewController
//
//  Created by XueFeng Chen on 2021/12/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class UFUIPageMenuView;

@protocol UFUIPageMenuViewProtocol <NSObject>

@required

- (void)scrollViewDidScrollToIndex:(NSInteger)index;

@optional

- (void)scrollViewHorizontalScrolledContentOffsetX:(CGFloat)contentOffsetX;
- (void)pageViewheaderViewVerticalScrolledContentPercentY:(CGFloat)contentPercentY;
- (void)scrollViewWillScrollFromIndex:(NSInteger)index;

@end

@class UFUIPageView;

@protocol UFUIPageContentViewControllerProtocol

@required

@property (nonatomic, strong) UIViewController  * _Nullable pageViewController;

- (UIScrollView *)pageContentScrollView;

@end

@protocol UFUIPageViewDataSource <NSObject>

@required

- (CGFloat)heightForNavigationBarInPagerView:(UFUIPageView *)pagerView;

- (CGFloat)heightForHeaderViewInPagerView:(UFUIPageView *)pagerView;

- (UIView *)headerViewInPagerView:(UFUIPageView *)pagerView;

- (CGFloat)heightForTabViewInPagerView:(UFUIPageView *)pagerView;

- (UIView<UFUIPageMenuViewProtocol> *)tabViewInPagerView:(UFUIPageView *)pagerView;

- (NSInteger)numberOfPagesInPagerView:(UFUIPageView *)pagerView;

- (UIViewController<UFUIPageContentViewControllerProtocol> *)pageView:(UFUIPageView *)pagerView initPageContentViewControllerAtIndex:(NSInteger)index;

@end

@protocol UFUIPageViewDelegate <NSObject>

@optional

- (void)pageView:(UFUIPageView *)pageView headerViewVerticalScrolledContentPercentY:(CGFloat)contentPercentY;

- (void)pageView:(UFUIPageView *)pageView scrollViewHorizontalScrolledContentOffsetX:(CGFloat)contentOffsetX;

- (void)pageView:(UFUIPageView *)pageView scrollViewWillScrollFromIndex:(NSInteger)index;

- (void)pageView:(UFUIPageView *)pageView scrollViewDidScrollToIndex:(NSInteger)index;

@end

@interface UFUIPageView : UIView

@property (nonatomic, weak) id<UFUIPageViewDataSource> pageViewDataSource;
@property (nonatomic, weak) id<UFUIPageViewDelegate> pageViewDelegate;
@property (nonatomic, weak) UIViewController *pageViewController;

@property (nonatomic, assign, readonly) NSInteger currentIndex;

- (instancetype)initWithFrame:(CGRect)frame pageViewDataSource:(id<UFUIPageViewDataSource>)pageViewDataSource pageViewDelegate:(id<UFUIPageViewDelegate>)pageViewDelegate pageViewController:(UIViewController *)pageViewController NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
