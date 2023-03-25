//
//  UFUIReplyQueryViewController.m
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2023/2/18.
//

#import "UFUIReplyQueryViewController.h"

#import "UFUIReplyQueryHeaderView.h"
#import "UFUIReplyQuerySectionView.h"
#import "UFUIReplyQueryFooterView.h"
#import "UFUIReplyQueryAddReplyToPostView.h"
#import "UFUIReplyQueryAddReplyToReplyView.h"
#import "UFUIReplyCell.h"

#import "UFUIReplyQueryViewModel.h"
#import "UFUIReplyQueryHeaderViewModel.h"
#import "UFUIReplyCellViewModel.h"
#import "UFUIReplyQueryAddReplyToPostViewModel.h"
#import "UFUIReplyQueryAddReplyToReplyViewModel.h"

#import "UIViewController+UFUIRoute.h"

#import "UFUIConstants.h"

@interface UFUIReplyQueryViewController () <UFUIReplyQueryHeaderViewDelegate, UFUIReplyQueryFooterViewDelegate, UFUIReplyQueryAddReplyToPostViewDelegate, UFUIReplyQueryAddReplyToReplyViewDelegate, UFUIReplyCelDelegate>

@end

@implementation UFUIReplyQueryViewController

- (instancetype)initWithQueryVM:(UFUIQueryViewModel *)queryVM {
    if (self = [super initWithQueryVM:queryVM]) {
        NSAssert([queryVM isKindOfClass:[UFUIReplyQueryViewModel class]], @"调用方必须准确传入UFUIReplyQueryViewModel类型的queryVM");
        self.replyQueryVM = (UFUIReplyQueryViewModel *)queryVM;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor systemBackgroundColor];
    
    UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
    [appearance configureWithOpaqueBackground];
    appearance.backgroundColor = [UIColor systemBackgroundColor];
    appearance.shadowColor = [UIColor systemBackgroundColor];
    appearance.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor labelColor]};
    
    self.navigationItem.standardAppearance = appearance;
    self.navigationItem.scrollEdgeAppearance = appearance;
    
    // 配置tableHeaderView
    self.tableView.tableHeaderView = self.replyQueryHeaderView;
    
    // autolayout宽度即可
    [self.replyQueryHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.tableView);
    }];
    
    // 重新布局
    [self.replyQueryHeaderView layoutIfNeeded];
    
    [self.view addSubview:self.replyQueryFooterView];
    [self.view addSubview:self.addReplyToPostView];
    [self.view addSubview:self.addReplyToReplyView];
    [self.view addSubview:self.dismissAddViewButton];
    
    [self.replyQueryFooterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
        make.height.mas_equalTo (58.0f);
    }];
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
        make.bottom.equalTo(self.replyQueryFooterView.mas_top);
    }];
    
    [self.addReplyToPostView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_bottom);
        make.height.mas_equalTo(200);
    }];
    
    [self.addReplyToReplyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_bottom);
        make.height.mas_equalTo(200);
    }];
    
    [self.dismissAddViewButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    [self.dismissAddViewButton setHidden:YES];
    
    // 监控键盘
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    // 监控Reply添加
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(replyAdded:)
                                                 name:UFUIReplyAddedNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark Notifications

- (void)keyboardWillHide:(NSNotification *)notification {
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        [self.addReplyToPostView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_bottom);
        }];
        
        [self.addReplyToReplyView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_bottom);
        }];
        
        [self.dismissAddViewButton setHidden:YES];
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary* info = [notification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        if ([self.addReplyToPostView.replyTextView isFirstResponder]) {
            [self.addReplyToPostView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view.mas_bottom).with.offset(-200.0f - keyboardSize.height);
            }];
        } else {
            [self.addReplyToReplyView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view.mas_bottom).with.offset(-200.0f - keyboardSize.height);
            }];
        }
        
        [self.dismissAddViewButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).with.offset(-200.0f - keyboardSize.height);
        }];
        
        [self.dismissAddViewButton setHidden:NO];
        [self.view layoutIfNeeded];
    }];
}

- (void)replyAdded:(NSNotification *)notification {
    // Todo:这里还是有点问题的
    // 目前的想法是：
    // 当还支持加载下页时，直接调用loadNextPage
    // 否则，我们需要将当前添加的Reply直接添加到表中进行展示
    //self.replyQueryVM.totalLoadCount == self.replyQueryVM.postModel.replyCount &&
    if (self.replyQueryVM.lastLoadCount < self.replyQueryVM.objectsPerPage) {
        // 获取刚添加的评论
        UFMReplyModel *replyModel = (UFMReplyModel *)[notification object];
        
        // 根据评论生成对应的CellVM
        UFUIReplyCellViewModel *replyCellVM = [[UFUIReplyCellViewModel alloc] initWithObjectModel:replyModel];

        // 更新QueryVM的内容
        NSMutableArray *objectCellVMMutalbeArray = [self.replyQueryVM.objectCellVMArray mutableCopy];
        [objectCellVMMutalbeArray addObject:replyCellVM];
        self.replyQueryVM.objectCellVMArray = [objectCellVMMutalbeArray copy];
        self.replyQueryVM.totalLoadCount++;

        // 注意UI更新必须用煮主线程更新
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self loadNextPage];
        });
    }
}

#pragma mark Actions

- (void)clickDismissTextViewButton:(id)sender {
    [self.addReplyToPostView dismiss];
    [self.addReplyToReplyView dismiss];
}

#pragma mark UITableViewDelegate, UITableViewDataSource

// 覆盖父类的方法
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.replyQueryVM.objectCellVMArray.count > 0) {
        NSString *sectionDescriptionFormat = KUFUILocalization(@"UFUIReplyQueryViewController.replyQuerySectionView.sectionDescriptionLabel.text");
        NSString *sectionDescription = [NSString stringWithFormat:sectionDescriptionFormat, self.replyQueryVM.postModel.replyCount];
        [self.replyQuerySectionView configWithSectionDescription:sectionDescription];
        return self.replyQuerySectionView;
    } else {
        return [[UIView alloc] initWithFrame:CGRectZero];
    }
}

// 覆盖父类的方法
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.replyQueryVM.objectCellVMArray.count > 0) {
        return 40.0f;
    } else {
        return 0.0f;
    }
}

#pragma mark Getter/Setter

- (UFUIReplyQueryHeaderView *)replyQueryHeaderView {
    if (!_replyQueryHeaderView) {
        _replyQueryHeaderView = [[UFUIReplyQueryHeaderView alloc] init];
        _replyQueryHeaderView.delegate = self;
        [_replyQueryHeaderView configWithReplyQueryHeaderViewModel:self.replyQueryVM.replyQueryHeaderVM];
    }
    
    return _replyQueryHeaderView;
}

- (UFUIReplyQuerySectionView *)replyQuerySectionView {
    if (!_replyQuerySectionView) {
        _replyQuerySectionView = [[UFUIReplyQuerySectionView alloc] init];
    }
    
    return _replyQuerySectionView;
}

- (UFUIReplyQueryFooterView *)replyQueryFooterView {
    if (!_replyQueryFooterView) {
        _replyQueryFooterView = [[UFUIReplyQueryFooterView alloc] init];
        _replyQueryFooterView.delegate = self;
    }
    
    return _replyQueryFooterView;
}

- (UFUIReplyQueryAddReplyToPostView *)addReplyToPostView {
    if (!_addReplyToPostView) {
        _addReplyToPostView = [[UFUIReplyQueryAddReplyToPostView alloc] init];
        _addReplyToPostView.delegate = self;
    }
    return _addReplyToPostView;
}

- (UFUIReplyQueryAddReplyToReplyView *)addReplyToReplyView {
    if (!_addReplyToReplyView) {
        _addReplyToReplyView = [[UFUIReplyQueryAddReplyToReplyView alloc] init];
        _addReplyToReplyView.delegate = self;
    }
    return _addReplyToReplyView;
}

- (UIButton *)dismissAddViewButton {
    if (!_dismissAddViewButton) {
        _dismissAddViewButton = [[UIButton alloc] init];
        _dismissAddViewButton.backgroundColor = [UIColor secondarySystemBackgroundColor];
        _dismissAddViewButton.alpha = 0.5;
        [_dismissAddViewButton addTarget:self action:@selector(clickDismissTextViewButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _dismissAddViewButton;
}

@end
