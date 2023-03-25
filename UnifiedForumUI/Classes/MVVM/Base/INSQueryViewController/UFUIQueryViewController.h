//
//  UFUIQueryViewController.h
//  INSParseUI
//
//  Created by XueFeng Chen on 2021/6/26.
//

#import <UIKit/UIKit.h>

#import "UFUIUserInteractionProtocol.h"

#import "UFUIPageView.h"

@class UFUIQueryViewModel;

NS_ASSUME_NONNULL_BEGIN

@interface UFUIQueryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UFUIPageContentViewControllerProtocol>

// UI全交给一个tableView
@property (nonatomic, strong) UITableView *tableView;

// tableView的核心数据源
@property (nonatomic, strong) UFUIQueryViewModel *queryVM;

@property (nonatomic, assign) BOOL enableMJHeader;
@property (nonatomic, assign) BOOL enableMJFooter;

// queryVM必须设置
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithQueryVM:(UFUIQueryViewModel *)queryVM;

// 加载首页
- (void)loadFirstPage;

// 加载下一页
- (void)loadNextPage;

@end

NS_ASSUME_NONNULL_END
