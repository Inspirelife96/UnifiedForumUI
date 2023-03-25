//
//  UFUIPageHeaderViewController.m
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2023/3/9.
//

#import "UFUIPageHeaderViewController.h"

#import "UFUIPageHeaderView.h"

#import "UFUIConstants.h"

#import <YHPageViewControllerFramework/YHPageViewControllerFramework-umbrella.h>

@interface UFUIPageHeaderViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) YHPageViewController *pageViewController;

@property (nonatomic, strong) YHPageScrollView *scrollView;

@property (nonatomic, strong) UFUIPageHeaderView *pageHeaderView;

@end

@implementation UFUIPageHeaderViewController

- (UFUIPageHeaderView *)pageHeaderView {
    return [[UFUIPageHeaderView alloc] init];
}

- (CGFloat)scrollViewMaxOffsetY {
    if (self.navigationController && [self.navigationController.navigationBar isTranslucent]) {
        CGRect statusBarRect = [[UIApplication sharedApplication] statusBarFrame];
        CGRect navigationBarRect = self.navigationController.navigationBar.frame;
        return [[self pageHeaderView] pageHeaderViewHeight] - (statusBarRect.size.height + navigationBarRect.size.height);
    } else {
        return [[self pageHeaderView] pageHeaderViewHeight];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    
    WEAKSELF
    
    self.scrollView = [[YHPageScrollView alloc] init];

    self.scrollView.maxOffsetY = [self scrollViewMaxOffsetY];

    [self.scrollView setDidScrollBlock:^(CGFloat offsetY) {
        STRONGSELF

        void (^pageHeaderViewScrollBlock)(CGFloat offsetY) = [[strongSelf pageHeaderView] pageHeaderViewScrollBlock];
        if (pageHeaderViewScrollBlock) {
            pageHeaderViewScrollBlock(offsetY);
        }
        
        void (^pageHeaderViewControllerScrollBlock)(CGFloat offsetY) = [strongSelf pageHeaderViewControllerScrollBlock];
        if (pageHeaderViewControllerScrollBlock) {
            pageHeaderViewControllerScrollBlock(offsetY);
        }

    }];
    
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.pageHeaderView = [self pageHeaderView];
    NSAssert(self.pageHeaderView, @"未设置header view ， yh_pageHeaderView 不能返回空");
    [self.scrollView addSubview:self.pageHeaderView];
    [self.pageHeaderView layoutSubviews];
    [self.pageHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.scrollView);
        make.width.equalTo(self.view);
        make.height.mas_equalTo([self.pageHeaderView pageHeaderViewHeight]);
    }];
    
    self.pageViewController = [YHPageViewController new];
    self.pageViewController.canPanPopBackWhenAtFirstPage = YES;
    self.pageViewController.relatePanParentViewController = self;
    [self addChildViewController:self.pageViewController];
    [self.scrollView addSubview:self.pageViewController.view];
    [self.pageViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView);
        make.top.equalTo(self.pageHeaderView.mas_bottom);
        make.width.equalTo(self.view);
        make.height.equalTo(self.view);
        make.bottom.equalTo(self.scrollView);
    }];
}

- (void(^)(CGFloat offsetY))pageHeaderViewControllerScrollBlock {
    WEAKSELF
    return ^(CGFloat offsetY) {
        if (self.navigationController) {
            CGFloat red = 0;
            CGFloat blue = 0;
            CGFloat green = 0;
            CGFloat alpha = 0;
            
            
            CGFloat percentY = 0;
            if (offsetY > 0) {
                percentY = offsetY / [self scrollViewMaxOffsetY];
            }
            
            percentY = MAX(0, percentY);
            percentY = MIN(1, percentY);
            
            UIColor *finalbackgroundColor = [UIColor secondarySystemBackgroundColor];
            [finalbackgroundColor getRed:&red green:&green blue:&blue alpha:&alpha];
            UIColor *backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:percentY];
            
            UIColor *finalShadowColor = [UIColor separatorColor];
            [finalShadowColor getRed:&red green:&green blue:&blue alpha:&alpha];
            UIColor *shadowColor = [UIColor colorWithRed:red green:green blue:blue alpha:percentY];
            
            UIColor *finalLabelColor = [UIColor labelColor];
            [finalLabelColor getRed:&red green:&green blue:&blue alpha:&alpha];
            UIColor *labelColor = [UIColor colorWithRed:red green:green blue:blue alpha:percentY];

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
    };
}

@end
