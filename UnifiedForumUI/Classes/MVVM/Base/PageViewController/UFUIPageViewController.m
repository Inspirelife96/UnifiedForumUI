//
//  UFUIPageViewController.m
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2021/12/9.
//

#import "UFUIPageViewController.h"

@interface UFUIPageViewController ()

@property (nonatomic, strong) UFUIPageView *pageView;
@property (nonatomic, strong) UFUIPageMenuView *tabView;
@property (nonatomic, strong) UIView *headerView;

@end

@implementation UFUIPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.pageView];
}

#pragma mark UFUIPageViewDataSource

- (CGFloat)heightForNavigationBarInPagerView:(UFUIPageView *)pagerView {
    if (self.navigationController.navigationBar) {
        return self.navigationController.navigationBar.frame.size.height;
    } else {
        return 0.0f;
    }
}

- (CGFloat)heightForHeaderViewInPagerView:(UFUIPageView *)pagerView {
    return 200.0f;
}

- (UIView *)headerViewInPagerView:(UFUIPageView *)pagerView {
    return self.headerView;
}

- (CGFloat)heightForTabViewInPagerView:(UFUIPageView *)pagerView {
    return 44.0f;
}

- (UIView *)tabViewInPagerView:(UFUIPageView *)pagerView {
    return self.tabView;
}

- (NSInteger)numberOfPagesInPagerView:(UFUIPageView *)pagerView {
    return 0;
}

- (UIViewController<UFUIPageContentViewControllerProtocol> *)pageView:(UFUIPageView *)pagerView initPageContentViewControllerAtIndex:(NSInteger)index {
    return nil;
    //return [[UFUIPageContentViewController alloc] init];
}


#pragma mark UFUIPageViewDelegate
- (void)pageView:(UFUIPageView *)pageView headerViewVerticalScrolledContentPercentY:(CGFloat)contentPercentY {
    CGFloat red = 0;
    CGFloat blue = 0;
    CGFloat green = 0;
    CGFloat alpha = 0;
    
    UIColor *finalbackgroundColor = [UIColor secondarySystemBackgroundColor];
    [finalbackgroundColor getRed:&red green:&green blue:&blue alpha:&alpha];
    UIColor *backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:contentPercentY];
    
    UIColor *finalShadowColor = [UIColor separatorColor];
    [finalShadowColor getRed:&red green:&green blue:&blue alpha:&alpha];
    UIColor *shadowColor = [UIColor colorWithRed:red green:green blue:blue alpha:contentPercentY];
    
    UIColor *finalLabelColor = [UIColor labelColor];
    [finalLabelColor getRed:&red green:&green blue:&blue alpha:&alpha];
    UIColor *labelColor = [UIColor colorWithRed:red green:green blue:blue alpha:contentPercentY];

    UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
    // 注意，一定得是Opaque，不能使用configureWithDefaultBackground。
    // 通过backgroundColor的alpha来决定视图的透明度
    [appearance configureWithOpaqueBackground];
    appearance.backgroundColor = backgroundColor;
    appearance.shadowColor = shadowColor;
    appearance.titleTextAttributes = @{NSForegroundColorAttributeName:labelColor};
    
    self.navigationItem.standardAppearance = appearance;
    self.navigationItem.scrollEdgeAppearance = appearance;
}

#pragma mark UFUIPageMenuViewDataSource

- (NSInteger)numberOfMenusInPageMenuView:(UFUIPageMenuView *)tabView {
    return 0;
}

- (NSString *)pageMenuView:(UFUIPageMenuView *)pageMenuView menuTitleAtIndex:(NSInteger)index {
    return nil;
}

#pragma mark UFUIPageMenuViewDelegate
 
- (void)tabView:(UFUIPageMenuView *)tabView didSelectIndex:(NSInteger)index {
    BOOL animated = labs(index - self.pageView.currentIndex) > 1 ? NO: YES;
    [self.pageView scrollToIndex:index animated:animated];
}


- (UFUIPageView *)pageView {
    if (!_pageView) {
        _pageView = [[UFUIPageView alloc] initWithFrame:self.view.bounds pageViewDataSource:self pageViewDelegate:self pageViewController:self];
    }
    
    return _pageView;
}

- (UFUIPageMenuView *)tabView {
    if (!_tabView) {
        _tabView = [[UFUIPageMenuView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44.0f) pageMenuViewDataSource:self pageMenuViewDelegate:self pageMenuViewStyle:UFUIPageMenuViewStyleFixed];
    }
    
    return _tabView;
}

- (UIView *)headerView {
    if (!_headerView) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200.0f)];
        imageView.image = [UIImage imageNamed:@"user_profile_background0"];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
    
        _headerView = imageView;
    }
    
    return _headerView;
}

@end
