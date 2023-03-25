//
//  UFUIPostQueryViewController.m
//  INSParseUI
//
//  Created by XueFeng Chen on 2021/12/23.
//

#import "UFUIPostQueryViewController.h"

#import "UFUIPostQueryFilterView.h"

#import "UFUIPostCellViewModel.h"

#import "UFUIQueryViewModel.h"

#import "UFUIPostQueryFooterView.h"
#import "UFUIPostQueryAddPostToTopicView.h"
#import "UFUIPostQueryAddReplyToPostView.h"

#import "UFUIPostQueryAddPostToTopicViewModel.h"
#import "UFUIPostQueryAddReplyToPostViewModel.h"

#import "UFMPostModel.h"

#import "UFUIPostCell.h"

#import "UFUIImagePickerModel.h"

#import "UFUIUFMServiceErrorHandler.h"

#import "UFUIAddPostViewController.h"

#import "UFUIPostQueryViewModel.h"

#import "UFUIReplyQueryViewModel.h"
#import "UFUIReplyQueryViewController.h"


//#import "UIViewController+INSTZImagePickerController.h"
//#import "UIViewController+INS_AlertView.h"

#import "UFUIPostQueryHeaderView.h"

#import "UIViewController+UFUIRoute.h"

// 所有和视图的交互代理，都交由VC来处理
@interface UFUIPostQueryViewController () <UFUIPostQueryHeaderViewDelegate, UFUIPostQueryFilterViewDelegate, UFUIPostCellDelegate, UFUIPostQueryFooterViewDelegate, UFUIPostQueryAddPostToTopicViewDelegate, UFUIPostQueryAddReplyToPostViewDelegate>

@end

@implementation UFUIPostQueryViewController

#pragma mark UIViewController LifeCyle

- (instancetype)initWithQueryVM:(UFUIQueryViewModel *)queryVM {
    if (self = [super initWithQueryVM:queryVM]) {
        NSAssert([queryVM isKindOfClass:[UFUIPostQueryViewModel class]], @"调用方必须准确传入UFUIPostQueryViewModel类型的queryVM");
        self.postQueryVM = (UFUIPostQueryViewModel *)queryVM;
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
    self.tableView.tableHeaderView = self.postQueryHeaderView;
    
    // autolayout宽度即可
    [self.postQueryHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.tableView);
    }];
    
    // 重新布局
    [self.postQueryHeaderView layoutIfNeeded];
    
    [self.view addSubview:self.postQueryFooterView];
    [self.view addSubview:self.addPostView];
    [self.view addSubview:self.addReplyView];
    [self.view addSubview:self.dismissAddViewButton];
    
    [self.postQueryFooterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
        make.height.mas_equalTo (58.0f);
    }];
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
        make.bottom.equalTo(self.postQueryFooterView.mas_top);
    }];
    
    [self.addPostView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_bottom);
        make.height.mas_equalTo(200);
    }];
    
    [self.addReplyView mas_makeConstraints:^(MASConstraintMaker *make) {
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
    
    // 监控Post添加
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(postAdded:)
                                                 name:UFUIPostAddedNotification object:nil];
}

#pragma mark Notifications

- (void)keyboardWillHide:(NSNotification *)notification {
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        [self.addPostView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_bottom);
        }];
        
        [self.addReplyView mas_updateConstraints:^(MASConstraintMaker *make) {
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
        if ([self.addPostView.postTextView isFirstResponder]) {
            [self.addPostView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view.mas_bottom).with.offset(-200.0f - keyboardSize.height);
            }];
            
            [self.dismissAddViewButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.view).with.offset(-200.0f - keyboardSize.height);
            }];
        } else {
            [self.addReplyView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view.mas_bottom).with.offset(-200.0f - keyboardSize.height);
            }];
            
            [self.dismissAddViewButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.view).with.offset(-200.0f - keyboardSize.height);
            }];
        }
        
        [self.dismissAddViewButton setHidden:NO];
        [self.view layoutIfNeeded];
    }];
}

- (void)postAdded:(NSNotification *)notification {
    
}

#pragma mark Actions

- (void)clickDismissTextViewButton:(id)sender {
    [self.addPostView dismiss];
    [self.addReplyView dismiss];
}

#pragma mark UITableViewDelegate, UITableViewDataSource

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.postQueryFilterView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UFUIObjectCellViewModel *objectCellVM = self.queryVM.objectCellVMArray[indexPath.row];

    if ([objectCellVM isKindOfClass:[UFUIPostCellViewModel class]]) {
        UFMPostModel *postModel = (UFMPostModel *)objectCellVM.objectModel;
        
        UFUIReplyQueryViewModel *replyQueryVM = [[UFUIReplyQueryViewModel alloc] initWithPostModel:postModel];
        
        UFUIReplyQueryViewController *replyQueryVC = [[UFUIReplyQueryViewController alloc] initWithQueryVM:replyQueryVM];

        [self.navigationController pushViewController:replyQueryVC animated:YES];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UFUIPostCellViewModel *objectCellVM = (UFUIPostCellViewModel *)self.queryVM.objectCellVMArray[indexPath.row];
    // 非常重要，必须设置
    objectCellVM.indexPath = indexPath;
    
    UFUIPostCell *cell = [tableView dequeueReusableCellWithIdentifier:objectCellVM.cellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    [cell configWithObjectCellViewModel:objectCellVM];
    
    return cell;
}


#pragma mark Getter/Setter

- (UFUIPostQueryHeaderView *)postQueryHeaderView {
    if (!_postQueryHeaderView) {
        _postQueryHeaderView = [[UFUIPostQueryHeaderView alloc] init];
        _postQueryHeaderView.delegate = self;
        [_postQueryHeaderView configWithPostQueryHeaderViewModel:self.postQueryVM.postQueryHeaderVM];
    }
    
    return _postQueryHeaderView;
}

- (UFUIPostQueryFilterView *)postQueryFilterView {
    if (!_postQueryFilterView) {
        _postQueryFilterView = [[UFUIPostQueryFilterView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen jk_width], 40.0f)];
        _postQueryFilterView.delegate = self;
        [_postQueryFilterView configWithPostQueryFilterViewModel:self.postQueryVM.postQueryFilterVM];
    }
    
    return _postQueryFilterView;
}

- (UFUIPostQueryFooterView *)postQueryFooterView {
    if (!_postQueryFooterView) {
        _postQueryFooterView = [[UFUIPostQueryFooterView alloc] init];
        [_postQueryFooterView configWithPostQueryFooterViewModel:self.postQueryVM.postQueryFooterVM];
        _postQueryFooterView.delegate = self;
    }
    
    return _postQueryFooterView;
}

- (UFUIPostQueryAddPostToTopicView *)addPostView {
    if (!_addPostView) {
        _addPostView = [[UFUIPostQueryAddPostToTopicView alloc] init];
        _addPostView.delegate = self;
    }
    return _addPostView;
}

- (UFUIPostQueryAddReplyToPostView *)addReplyView {
    if (!_addReplyView) {
        _addReplyView = [[UFUIPostQueryAddReplyToPostView alloc] init];
        _addReplyView.delegate = self;
    }
    return _addReplyView;
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
