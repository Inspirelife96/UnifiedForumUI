//
//  UFUIAddTopicViewController.m
//  INSParseUI
//
//  Created by XueFeng Chen on 2021/7/1.
//

#import "UFUIAddTopicViewController.h"

#import "UFUITagsViewController.h"
#import "UFUICategoryViewController.h"

#import "UFUIPickedImageCell.h"
#import "UFUIAutoHeightTextView.h"
#import "UFUISplitLineView.h"
#import "JCTagListView.h"

#import "UFUIAddTopicViewModel.h"
#import "UFUIImagePickerModel.h"

#import "UFUIUFMServiceErrorHandler.h"

#import "UIViewController+UFUIRoute.h"
#import "UIViewController+SCAlertView.h"

@interface UFUIAddTopicViewController () <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITextViewDelegate, UITextFieldDelegate, UFUIPickedImageCellDelegate>

// 导航栏左边的关闭按钮
@property (nonatomic, strong) UIButton *closeButton;

// 导航栏右边的发送按钮
@property (nonatomic, strong) UIButton *publishButton;

// 主体内容由TableView来呈现
@property (nonatomic, strong) UITableView *tableView;

// 固定的TableViewCell

// Topic的板块显示/选择Cell，标准value1型+categorySplitLineView分割线
@property (nonatomic, strong) UITableViewCell *categoryCell;
@property (nonatomic, strong) UFUISplitLineView *categorySplitLineView;

// Topic的标题，自定义，Cell内部包含titleTextField输入框以及titleSplitLineView分割线
@property (nonatomic, strong) UITableViewCell *titleCell;
@property (nonatomic, strong) UITextField *titleTextField;
@property (nonatomic, strong) UFUISplitLineView *titleSplitLineView;

// Topic的具体内容，自定义，内嵌contentTextView
@property (nonatomic, strong) UITableViewCell *contentCell;
@property (nonatomic, strong) UFUIAutoHeightTextView *contentTextView;

// 选择的图片，自定义，内嵌selectedPhotoesCollectionView
@property (nonatomic, strong) UITableViewCell *selectedPhotoesCell;
@property (nonatomic, strong) UICollectionView *selectedPhotoesCollectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

// 指定的标签，自定义，内嵌selectedTagsView
@property (nonatomic, strong) UITableViewCell *selectedTagsCell;
@property (nonatomic, strong) JCTagListView *selectedTagsView;

// TableView和底部交互按钮的分割线
@property (nonatomic, strong) UFUISplitLineView *splitLineView;

// 底部交互：添加图片按钮
@property (nonatomic, strong) UIButton *addPhotoButton;

// 底部交互：添加标签按钮
@property (nonatomic, strong) UIButton *addTagButton;

// 曲线救国 https://www.jianshu.com/p/436fef66f6dc
// 理论上SCLAlertView做成属性是有风险的，也确实如此，测试发现closebutton会一直叠加。
// 因此使用的是不带closebutton的
@property (nonatomic, strong) SCLAlertView *titleAlertView;

// 视图模型
@property (nonatomic, strong) UFUIAddTopicViewModel *addTopicVM;

// 基于视图模型定义的需要显示的Cell数组
@property (nonatomic, copy) NSArray *cellArray;

@end

@implementation UFUIAddTopicViewController

#pragma mark UIViewController LifeCyle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor systemBackgroundColor];

    self.navigationItem.title = KUFUILocalization(@"UFUIAddTopicViewController.navigationBar.title");
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.closeButton];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.publishButton];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.splitLineView];
    [self.view addSubview:self.addPhotoButton];
    [self.view addSubview:self.addTagButton];
    
    [self.addPhotoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft).with.offset(12.0f);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).with.offset(- 12.0f);
        make.height.mas_equalTo(30.0f);
        make.width.mas_equalTo(30.0f);
    }];
    
    // addTagButton布局以addPhotoButton为参照
    // 当键盘弹出时，调整addPhotoButton的位置就可以同时调整addTagButton的位置。
    [self.addTagButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.addPhotoButton.mas_right).with.offset(12.0f);
        make.bottom.equalTo(self.addPhotoButton);
        make.height.mas_equalTo(30.0f);
        make.width.mas_equalTo(30.0f);
    }];
    
    // splitLineView布局以addPhotoButton为参照
    // 当键盘弹出时，调整addPhotoButton的位置就可以同时调整splitLineView的位置。
    [self.splitLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.addPhotoButton.mas_top).with.offset(-12.0f);
        make.height.mas_equalTo(1.0f);
    }];
  
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(self.splitLineView.mas_top);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark Notifications

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary* info = [notification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;

    [self.addPhotoButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).with.offset(-keyboardSize.height - 12.0f + self.view.safeAreaInsets.bottom);
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [self.addPhotoButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).with.offset(- 12.0f);
    }];
}

#pragma mark TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = self.cellArray[indexPath.row];

    if (cell == self.categoryCell) {
        if (self.addTopicVM.category && ![self.addTopicVM.category isEqualToString:@""]) {
            self.categoryCell.textLabel.text = self.addTopicVM.category;
            self.categoryCell.detailTextLabel.text = @"";
        } else {
            self.categoryCell.textLabel.text = KUFUILocalization(@"UFUIAddTopicViewController.categoryView.textLabel.text");
            self.categoryCell.detailTextLabel.text = KUFUILocalization(@"UFUIAddTopicViewController.categoryView.detailTextLabel.text");
        }
    }

    if (cell == self.titleCell) {
        self.titleTextField.text = self.addTopicVM.title;
    }

    if (cell == self.contentCell) {
        self.contentTextView.text = self.addTopicVM.content;
    }
    
    if (cell == self.selectedPhotoesCell) {
        [self.selectedPhotoesCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.addTopicVM.pickedPhotoCollectionViewSize.width);
            make.height.mas_equalTo(self.addTopicVM.pickedPhotoCollectionViewSize.height);
        }];
        [self.selectedPhotoesCollectionView reloadData];
    }
    
    if (cell == self.selectedTagsCell) {
        self.selectedTagsView.tags = [self.addTopicVM.selectedTags mutableCopy];
        self.selectedTagsView.selectedTags = [self.addTopicVM.selectedTags mutableCopy];
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = self.cellArray[indexPath.row];
    if (cell == self.categoryCell) {
        return 44.0f;
    }

    if (cell == self.titleCell) {
        return 44.0f;
    }

    if (cell == self.contentCell) {
        return UITableViewAutomaticDimension;
    }
    
    if (cell == self.selectedPhotoesCell) {
        return [self.addTopicVM pickedPhotoCollectionViewSize].height + 12.0f * 2;
    }
    
    if (cell == self.selectedTagsCell) {
        return [self.addTopicVM heightForSelectedTagsView] + 12.0f * 2;
    }

    return UITableViewAutomaticDimension;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UFUICategoryViewController *categoryVC = [[UFUICategoryViewController alloc] initWithSelectedCategory:self.addTopicVM.category didFinishSelectingCategoryHandle:^(NSString * _Nonnull selectedCategory) {
            self.addTopicVM.category = selectedCategory;
            [self _reloadUI];
        }];
        [self.navigationController pushViewController:categoryVC animated:YES];
    }
}

#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger count = [self.addTopicVM.imagePickerModel.selectedPhotos count];
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UFUIPickedImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UFUIPickedImageCell class]) forIndexPath:indexPath];
    
    [cell configWithImage:self.addTopicVM.imagePickerModel.selectedPhotos[indexPath.row] indexPath:indexPath];
    cell.delegate = self;

    return cell;
}

#pragma mark UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.addTopicVM.pickedPhotoCellSize;
}

#pragma mark UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self ufui_routeToImagePickerController:self.addTopicVM.imagePickerModel completion:^{
        // 图片选择完毕后需要重新加载UI
        [self _reloadUI];
    }];
}

#pragma mark UFUIPickedImageCellDelegate

- (void)deleteSelectedPhotoCell:(NSIndexPath *)indexPath {
    [self.addTopicVM.imagePickerModel.selectedPhotos removeObjectAtIndex:indexPath.row];
    [self.addTopicVM.imagePickerModel.selectedAssets removeObjectAtIndex:indexPath.row];
    [self.selectedPhotoesCollectionView performBatchUpdates:^{
        [self.selectedPhotoesCollectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        // 删除图片后也需要重新加载UI
        [self _reloadUI];
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // https://www.jianshu.com/p/436fef66f6dc
    
    if (string.length <= 0) {
        return YES;
    }

    // 高亮选择状态中，例如中文输入拼音时
    UITextRange *selectedRange = textField.markedTextRange;
    if (selectedRange && ![selectedRange isEmpty]) {
        return YES;
    }

    // 先看看更新后的字符串是什么
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];

    // 更新后是否长度溢出，这边31是最长长度，暂时硬编码了
    NSInteger overflowedLength = 31 - [newString length];

    if (overflowedLength >= 0) {
        // 没有溢出，那么就直接返回YES
        return YES;
    } else {
        // 溢出了，那看看允许添加多少长度的内容
        NSInteger allowedLength = [string length] + overflowedLength;
        if (allowedLength > 0) {
            // 原则上，我们把string前allowedLength的字串进行替换
            // 但考虑emoji的情况，需要考虑不要截断这种特殊字符
            NSString *subString = @"";
            NSRange rangeIndex = [string rangeOfComposedCharacterSequenceAtIndex:(allowedLength - 1)];
            
            if (rangeIndex.location + rangeIndex.length > allowedLength) {
                subString = [string substringToIndex:rangeIndex.location];
            } else {
                subString = [string substringToIndex:allowedLength];
            }
            
            // 最后如果子字符串不为空，则替换
            if (![subString isEqualToString:@""]) {
                [textField setText:[textField.text stringByReplacingCharactersInRange:range withString:subString]];
            }
        }
        
        // 这种情况下由于返回NO，需要在这里把值传递给self.addTopicVM.title
        // 其他的由titleTextFieldDidChanged里面处理
        self.addTopicVM.title = textField.text;

        // 给出警告，提示超过字符串最大容量。
        if (![self.titleAlertView isBeingPresented]) {
            NSString *subTitle = KUFUILocalization(@"UFUIAddTopicViewController.titleCharacterReachesMax.alertView.title");
            [self.titleAlertView showInfo:self title:nil subTitle:subTitle closeButtonTitle:nil duration:1.0f];
        }

        // 返回NO，我们处理完了。
        return NO;
    }
    
    return YES;
}

- (void)titleTextFieldDidChanged:(UITextField *)textField {
    // 高亮状态，处于选词状态，直接跳过
    UITextRange *selectedRange = textField.markedTextRange;
    if (selectedRange != nil && !selectedRange.isEmpty) {
        return;
    }
    
    self.addTopicVM.title = textField.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.titleTextField resignFirstResponder];
    [self.contentTextView becomeFirstResponder];
    return YES;
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView {
    // 输入的时候字符限制
    // 判断是否存在高亮字符，如果有，则不进行字数统计和字符串截断
    UITextRange *selectedRange = textView.markedTextRange;
    if (selectedRange != nil && !selectedRange.isEmpty) {
        return;
    }
    
    self.addTopicVM.content = textView.text;
}

#pragma mark UI Actions

- (void)clickSendButton:(UIButton *)sender {
    [self.contentTextView resignFirstResponder];
    
    NSString *errorMessage = @"";
    if (![self.addTopicVM isAbleToPublish:&errorMessage]) {
        [self ufui_alertErrorWithMessage:errorMessage];
    } else {
        [self.view setUserInteractionEnabled:NO];
        [self.navigationController.navigationBar setUserInteractionEnabled:NO];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];

        WEAKSELF
        [self.addTopicVM addTopicInBackground:^(NSError * _Nullable error) {
            STRONGSELF
            [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
            [strongSelf.navigationController.navigationBar setUserInteractionEnabled:YES];
            [strongSelf.view setUserInteractionEnabled:YES];
            if (error) {
                [UFUIUFMServiceErrorHandler handleUFMServiceError:error];
            } else {
                [strongSelf.addTopicVM clear];
                [[NSNotificationCenter defaultCenter] postNotificationName:UFUITopicAddedNotification object:strongSelf];
                [strongSelf dismissViewControllerAnimated:YES completion:nil];
            }
        }];
    }
}

- (void)clickCloseButton:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clickAddPhotoButton:(UIButton *)sender {
    [self ufui_routeToImagePickerController:self.addTopicVM.imagePickerModel completion:^{
        [self _reloadUI];
    }];
}

- (void)clickAddTagButton:(UIButton *)sender {
    UFUITagsViewController *tagVC = [[UFUITagsViewController alloc] initWithSelectedTagArray:self.addTopicVM.selectedTags];
    [tagVC setDidFinishSelectingTagsHandle:^(NSArray<NSString *> * _Nonnull selectedTags) {
        self.addTopicVM.selectedTags = selectedTags;
        [self _reloadUI];
    }];
    
    UINavigationController *tagNC = [[UINavigationController alloc] initWithRootViewController:tagVC];
    [self presentViewController:tagNC animated:YES completion:nil];
}

# pragma mark Private Methods

- (void)_buildCellArray {
    NSMutableArray *mutalbeCellArray = [[NSMutableArray alloc] init];
    
    [mutalbeCellArray addObject:self.categoryCell];
    [mutalbeCellArray addObject:self.titleCell];
    [mutalbeCellArray addObject:self.contentCell];

    if (self.addTopicVM.imagePickerModel.selectedPhotos.count > 0) {
        [mutalbeCellArray addObject:self.selectedPhotoesCell];
    }
    
    if (self.addTopicVM.selectedTags.count > 0) {
        [mutalbeCellArray addObject:self.selectedTagsCell];
    }

    self.cellArray = [mutalbeCellArray copy];
}

- (void)_reloadUI {
    [self _buildCellArray];
    [self.tableView reloadData];
}

#pragma mark Getter/Setter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        _tableView.allowsSelection = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 100;
        _tableView.backgroundColor = [UIColor systemBackgroundColor];
    }

    return _tableView;
}

- (UITableViewCell *)categoryCell {
    if (!_categoryCell) {
        _categoryCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CategoryCell"];
        _categoryCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _categoryCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        _categoryCell.detailTextLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
        [_categoryCell addSubview:self.categorySplitLineView];
        [self.categorySplitLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_categoryCell).with.offset(20.0f);
            make.right.equalTo(_categoryCell).with.offset(-20.0f);
            make.bottom.equalTo(_categoryCell);
            make.height.mas_equalTo(0.5f);
        }];
    }
    
    return _categoryCell;
}

- (UITableViewCell *)titleCell {
    if (!_titleCell) {
        _titleCell = [[UITableViewCell alloc] init];
        _titleCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [_titleCell.contentView addSubview:self.titleTextField];
        [self.titleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_titleCell.contentView).with.offset(20.0f);
            make.right.equalTo(_titleCell.contentView).with.offset(-20.0f);
            make.top.equalTo(_titleCell.contentView).with.offset(12.0f);
            make.bottom.equalTo(_titleCell.contentView).with.offset(-12.0f);
        }];
        
        [_titleCell.contentView addSubview:self.titleSplitLineView];
        [self.titleSplitLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_titleCell.contentView).with.offset(20.0f);
            make.right.equalTo(_titleCell.contentView).with.offset(-20.0f);
            make.bottom.equalTo(_titleCell.contentView);
            make.height.mas_equalTo(0.5f);
        }];
    }
    
    return _titleCell;
}

- (UITableViewCell *)contentCell {
    if (!_contentCell) {
        _contentCell = [[UITableViewCell alloc] init];
        _contentCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [_contentCell.contentView addSubview:self.contentTextView];
        [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_contentCell.contentView).with.offset(12.0f).priority(999);
            make.bottom.equalTo(_contentCell.contentView).with.offset(-12.0f).priority(777);
            make.left.equalTo(_contentCell.contentView).with.offset(15.0f);
            make.right.equalTo(_contentCell.contentView).with.offset(-15.0f);
            make.height.mas_greaterThanOrEqualTo(@(14)).priority(888);
        }];
        
        WEAKSELF
        self.contentTextView.textViewHeightChangeBlock = ^(CGFloat textViewHeight) {
            STRONGSELF
            [strongSelf.contentTextView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_greaterThanOrEqualTo(@(textViewHeight)).priority(888);
            }];
            
            [strongSelf.tableView beginUpdates];
            [strongSelf.tableView endUpdates];
        } ;
    }
    
    return _contentCell;
}

- (UITableViewCell *)selectedPhotoesCell {
    if (!_selectedPhotoesCell) {
        _selectedPhotoesCell = [[UITableViewCell alloc] init];
        _selectedPhotoesCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [_selectedPhotoesCell.contentView addSubview:self.selectedPhotoesCollectionView];
        [self.selectedPhotoesCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_selectedPhotoesCell.contentView).with.offset(20.0f);
            make.top.equalTo(_selectedPhotoesCell.contentView).with.offset(12.0f);
            make.width.mas_equalTo([self.addTopicVM pickedPhotoCollectionViewSize].width);
            make.height.mas_equalTo([self.addTopicVM pickedPhotoCollectionViewSize].height);
        }];
    }
    
    return _selectedPhotoesCell;
}

- (UITableViewCell *)selectedTagsCell {
    if (!_selectedTagsCell) {
        _selectedTagsCell = [[UITableViewCell alloc] init];
        _selectedTagsCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [_selectedTagsCell.contentView addSubview:self.selectedTagsView];
        [self.selectedTagsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_selectedTagsCell.contentView).with.offset(20.0f);
            make.right.equalTo(_selectedTagsCell.contentView).with.offset(-20.0f);
            make.top.equalTo(_selectedTagsCell.contentView).with.offset(12.0f);
            make.bottom.equalTo(_selectedTagsCell.contentView).with.offset(-12.0f);
        }];
    }
    
    return _selectedTagsCell;
}

- (JCTagListView *)selectedTagsView {
    if (!_selectedTagsView) {
        _selectedTagsView = [[JCTagListView alloc] initWithFrame:CGRectZero];
        
        _selectedTagsView.tagTextColor = [UIColor secondaryLabelColor];
        _selectedTagsView.tagSelectedTextColor = [UIColor labelColor];
        
        _selectedTagsView.tagBackgroundColor = [UIColor tertiarySystemBackgroundColor];
        _selectedTagsView.tagSelectedBackgroundColor = [UIColor systemBackgroundColor];
    }
    
    return _selectedTagsView;
}

- (UITextField *)titleTextField {
    if (!_titleTextField) {
        _titleTextField = [[UITextField alloc] init];
        _titleTextField.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
        _titleTextField.placeholder = KUFUILocalization(@"UFUIAddTopicViewController.titleTextView.placeholder");
        _titleTextField.delegate = self;
        [_titleTextField addTarget:self action:@selector(titleTextFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    
    return _titleTextField;
}

- (UFUIAutoHeightTextView *)contentTextView {
    if (!_contentTextView) {
        _contentTextView = [[UFUIAutoHeightTextView alloc] initWithFrame:CGRectZero];
        _contentTextView.placeholder = KUFUILocalization(@"UFUIAddTopicViewController.contentTextView.placeholder");
        _contentTextView.minNumberOfLines = 3;
        _contentTextView.maxNumberOfLines = NSIntegerMax;
        _contentTextView.delegate = self;
    }
    
    return _contentTextView;
}

- (UICollectionView *)selectedPhotoesCollectionView {
    if (!_selectedPhotoesCollectionView) {
        _selectedPhotoesCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen jk_width], 0) collectionViewLayout:self.layout];
        _selectedPhotoesCollectionView.alwaysBounceVertical = YES;
        _selectedPhotoesCollectionView.backgroundColor = [UIColor systemBackgroundColor];
        _selectedPhotoesCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _selectedPhotoesCollectionView.dataSource = self;
        _selectedPhotoesCollectionView.delegate = self;
        _selectedPhotoesCollectionView.scrollEnabled = NO;
        _selectedPhotoesCollectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_selectedPhotoesCollectionView registerClass:[UFUIPickedImageCell class] forCellWithReuseIdentifier:NSStringFromClass([UFUIPickedImageCell class])];
    }

    return _selectedPhotoesCollectionView;
}

- (UICollectionViewFlowLayout *)layout {
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.minimumInteritemSpacing = 5.0f;
        _layout.minimumLineSpacing = 5.0f;
    }

    return _layout;
}

- (UIButton *)addPhotoButton {
    if (!_addPhotoButton) {
        _addPhotoButton = [[UIButton alloc] init];
        UIImageSymbolConfiguration *imageSymbolConfig = [UIImageSymbolConfiguration configurationWithPointSize:24.0f];
        [_addPhotoButton setImage:[UIImage systemImageNamed:@"photo.circle" withConfiguration:imageSymbolConfig] forState:UIControlStateNormal];
        [_addPhotoButton addTarget:self action:@selector(clickAddPhotoButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _addPhotoButton;
}

- (UIButton *)addTagButton {
    if (!_addTagButton) {
        _addTagButton = [[UIButton alloc] init];
        UIImageSymbolConfiguration *imageSymbolConfig = [UIImageSymbolConfiguration configurationWithPointSize:24.0f];
        [_addTagButton setImage:[UIImage systemImageNamed:@"tag.circle" withConfiguration:imageSymbolConfig] forState:UIControlStateNormal];
        [_addTagButton addTarget:self action:@selector(clickAddTagButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _addTagButton;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [[UIButton alloc] init];
        [_closeButton setImage:[UIImage systemImageNamed:@"xmark"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(clickCloseButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _closeButton;
}

- (UIButton *)publishButton {
    if (!_publishButton) {
        _publishButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 60.0f, 24.0f)];
        _publishButton.backgroundColor = [UIColor linkColor];
        
        [_publishButton setTitleColor:[UIColor systemBackgroundColor] forState:UIControlStateNormal];
        [_publishButton setTitleColor:[UIColor secondarySystemBackgroundColor] forState:UIControlStateDisabled];
        [_publishButton setEnabled:NO];
        
        [_publishButton addTarget:self action:@selector(clickSendButton:) forControlEvents:UIControlEventTouchUpInside];
        
        _publishButton.layer.cornerRadius = 12.0f;
        _publishButton.layer.masksToBounds = YES;
        [_publishButton setTitle:KUFUILocalization(@"UFUIAddTopicViewController.publishButton.title") forState:UIControlStateNormal];
        _publishButton.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    }
    
    return _publishButton;
}

- (UFUISplitLineView *)splitLineView {
    if (!_splitLineView) {
        _splitLineView = [[UFUISplitLineView alloc] init];
    }
    
    return _splitLineView;
}

- (UFUISplitLineView *)categorySplitLineView {
    if (!_categorySplitLineView) {
        _categorySplitLineView = [[UFUISplitLineView alloc] init];
    }
    
    return _categorySplitLineView;
}

- (UFUISplitLineView *)titleSplitLineView {
    if (!_titleSplitLineView) {
        _titleSplitLineView = [[UFUISplitLineView alloc] init];
    }
    
    return _titleSplitLineView;
}

- (NSArray *)cellArray {
    if (!_cellArray) {
        [self _buildCellArray];
    }
    
    return _cellArray;
}

- (UFUIAddTopicViewModel *)addTopicVM {
    if (!_addTopicVM) {
        _addTopicVM = [[UFUIAddTopicViewModel alloc] init];
    }
    
    return _addTopicVM;
}

- (SCLAlertView *)titleAlertView {
    if (!_titleAlertView) {
        _titleAlertView = [[SCLAlertView alloc] init];
        
    }
    
    return _titleAlertView;
}

@end
