//
//  UFUIQueryViewController.m
//  INSParseUI
//
//  Created by XueFeng Chen on 2021/6/26.
//

#import "UFUIQueryViewController.h"

#import "UFUIConstants.h"

#import "UFUIObjectCell.h"

#import "UFUIObjectCellViewModel.h"

#import "UFUIEmptyDataSetView.h"

#import "UFUIQueryViewModel.h"

#import "UFUIUFMServiceErrorHandler.h"

#import "UFUIQueryViewController+Topic.h"

#import "UFUIQueryViewController+User.h"

@interface UFUIQueryViewController ()

@property (nonatomic, strong) UIView *emptyView;

@end

@implementation UFUIQueryViewController

@synthesize pageViewController;

- (instancetype)initWithQueryVM:(UFUIQueryViewModel *)queryVM {
    if (self = [super init]) {
        self.queryVM = queryVM;
        self.enableMJHeader = YES;
        self.enableMJFooter = YES;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
        
    [self loadFirstPage];
}

#pragma mark - Tab Content for KQTabViewController

- (UIScrollView *)pageContentScrollView {
    return self.tableView;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.queryVM.objectCellVMArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 获取当前要展示的内容对应的CellVM
    UFUIObjectCellViewModel *objectCellVM = self.queryVM.objectCellVMArray[indexPath.row];

    // 非常重要，设置indexPath
    objectCellVM.indexPath = indexPath;
    
    // 根据objectCellVM.cellIdentifier获取对应的Cell
    UFUIObjectCell *cell = [tableView dequeueReusableCellWithIdentifier:objectCellVM.cellIdentifier forIndexPath:indexPath];
    
    // 非常重要，设置Cell的代理
    cell.delegate = self;
    
    // 根据CellVM的设置Cell的具体内容
    [cell configWithObjectCellViewModel:objectCellVM];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //具体的由子类来实现
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (self.queryVM.queryStatus == UFUIQueryStatusDone && self.queryVM.totalLoadCount == 0) {
        return self.emptyView;
    } else {
        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.1f)];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.queryVM.queryStatus == UFUIQueryStatusDone && self.queryVM.totalLoadCount == 0) {
        CGFloat tableHeaderViewHeight = 0.0f;
        CGFloat sectionHeaderViewHeight = 0.0f;
        CGFloat tableViewHeight = self.tableView.frame.size.height;
        
        if (self.tableView.tableHeaderView) {
            tableHeaderViewHeight = self.tableView.tableHeaderView.frame.size.height;
        }
        
        if ([self respondsToSelector:@selector(tableView:heightForHeaderInSection:)]) {
            sectionHeaderViewHeight = [self tableView:tableView heightForHeaderInSection:section];
        }
        
        if ((tableHeaderViewHeight + sectionHeaderViewHeight) > tableViewHeight/2.0f) {
            return tableViewHeight/2.0f;
        } else {
            return tableViewHeight - tableHeaderViewHeight - sectionHeaderViewHeight;
        }
    } else {
        return 0.1f;
    }
}

#pragma mark - Public Methods

- (void)loadFirstPage {
    [self updateUIBeforeLoad];
    
    [self.queryVM loadFirstPageInBackgroundSuccess:^{
        [self updateUIAfterLoad:nil];
    } failure:^(NSError * _Nonnull error) {
        [self updateUIAfterLoad:error];
    }];
    
}

- (void)loadNextPage {
    [self updateUIBeforeLoad];
    
    [self.queryVM loadNextPageInBackgroundSuccess:^{
        [self updateUIAfterLoad:nil];
    } failure:^(NSError * _Nonnull error) {
        [self updateUIAfterLoad:error];
    }];
}

#pragma mark - Private Methods

- (void)updateUIBeforeLoad {
    // 显示进度条
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // 停止交互
    [self.view setUserInteractionEnabled:NO];
}

- (void)updateUIAfterLoad:(NSError *)error {
    // 取消进度条
    [MBProgressHUD hideHUDForView:self.view animated:YES];

    // 取消表头尾的刷新
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
    if (error) {
        [UFUIUFMServiceErrorHandler handleUFMServiceError:error];
    } else {
        // 如果没有错误，且最后加载的数据小于期望加载的数据，说明数据没有多余的了。
        // 所以表尾提示设置为“没有更多数据了”
        if (self.queryVM.lastLoadCount < self.queryVM.objectsPerPage) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        // 重新加载表
        [self.tableView reloadData];
    }
    
    // 允许用户交互
    [self.view setUserInteractionEnabled:YES];
}

#pragma mark - Getter/Setter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 1)];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 1)];
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 100;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        _tableView.backgroundColor = [UIColor secondarySystemBackgroundColor];
    }
    
    return _tableView;
}

- (void)setQueryVM:(UFUIQueryViewModel *)queryVM {
    _queryVM = queryVM;
    
    // 从QueryViewModel中获取这个TableView使用的UITableViewCell的类型，并进行注册。
    NSArray *objectCellClassArray = [queryVM objectCellClassArray];
    [objectCellClassArray enumerateObjectsUsingBlock:^(Class _Nonnull objectCellClass, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.tableView registerClass:objectCellClass forCellReuseIdentifier:NSStringFromClass(objectCellClass)];
    }];
}

- (UIView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[UFUIEmptyDataSetView alloc] initWithFrame:CGRectMake(0, 0, 0, 1)];
    }
    
    return _emptyView;
}

- (void)setEnableMJHeader:(BOOL)enableMJHeader {
    _enableMJHeader = enableMJHeader;
    if (enableMJHeader) {
        WEAKSELF
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            STRONGSELF
            [strongSelf loadFirstPage];
        }];
    } else {
        self.tableView.mj_header = nil;
    }
}

- (void)setEnableMJFooter:(BOOL)enableMJFooter {
    _enableMJFooter = enableMJFooter;
    if (_enableMJFooter) {
        WEAKSELF
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            STRONGSELF;
            [strongSelf loadNextPage];
        }];
    } else {
        self.tableView.mj_footer = nil;
    }
}

@end
