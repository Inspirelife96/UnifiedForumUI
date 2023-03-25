//
//  UFUIAddPostViewController.m
//  INSParseUI
//
//  Created by XueFeng Chen on 2022/1/23.
//

#import "UFUIAddPostViewController.h"

#import "UFUIAutoHeightTextView.h"
#import "UFUIPickedImageCell.h"

#import "UFUIPostQueryAddPostToTopicViewModel.h"
#import "UFUIImagePickerModel.h"

#import "UFUIUFMServiceErrorHandler.h"

#import "UFUIConstants.h"

#import "UIViewController+SCAlertView.h"
#import "UIViewController+UFUIRoute.h"

@interface UFUIAddPostViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITextViewDelegate, UFUIPickedImageCellDelegate>

// 顶部左边关闭按钮
@property (nonatomic, strong) UIButton *closeButton;

// 右边的发送按钮
@property (nonatomic, strong) UIButton *postButton;

// ScrollView使用autolayout的两点要求：
//  - Scrollview只能有一个直接子视图，也就是ContentView
//  - ContentView的宽度要设置于Scrollview父视图的宽度一样
@property (nonatomic, strong) UIScrollView *scrollView; //评论内容和选择的图片都放到scrollView中
@property (nonatomic, strong) UIView *contentView; // scrollView唯一的子视图

// 回帖的文字部分，自增高
@property (nonatomic, strong) UFUIAutoHeightTextView *postTextView;

// 回帖的图片部分，显示选择的图片
@property (nonatomic, strong) UICollectionView *selectedPhotoesCollectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

// 底部分隔线
@property (nonatomic, strong) UIVisualEffectView *splitLineView;

// 添加图片按钮
@property (nonatomic, strong) UIButton *addImageButton;

// 视图模型
@property (nonatomic, strong) UFUIPostQueryAddPostToTopicViewModel *addPostVM;

@end

@implementation UFUIAddPostViewController

#pragma mark Init

// 必须使用这个API进行初始化
- (instancetype)initWithAddPostViewModel:(UFUIPostQueryAddPostToTopicViewModel *)addPostVM {
    if (self = [super init]) {
        self.addPostVM = addPostVM;
    }
    
    return self;
}

#pragma mark UIViewController LifeCyle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor systemBackgroundColor];

    self.navigationItem.title = KUFUILocalization(@"addPostViewController.navigationBar.title");
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.closeButton];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.postButton];
    
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.addImageButton];
    [self.view addSubview:self.splitLineView];
    
    [self.addImageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft).with.offset(12.0f);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).with.offset(- 12.0f);
        make.height.mas_equalTo(30.0f);
        make.width.mas_equalTo(30.0f);
    }];
    
    [self.splitLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.addImageButton.mas_top).with.offset(-12.0f);
        make.height.mas_equalTo(2.0f);
    }];
  
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(self.splitLineView.mas_top);
    }];
    
    [self.scrollView addSubview:self.contentView];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.mas_equalTo([UIScreen jk_width]);
    }];

    [self.contentView addSubview:self.postTextView];
    [self.contentView addSubview:self.selectedPhotoesCollectionView];
    
    [self.postTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(12.0f);
        make.top.equalTo(self.contentView).with.offset(12.0f);
        make.right.equalTo(self.contentView).with.offset(-12.0f);
        make.height.mas_equalTo(ceil(self.postTextView.font.lineHeight) * self.postTextView.minNumberOfLines);
    }];
    
    [self.selectedPhotoesCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView).with.offset(12.0f);
        make.top.equalTo(self.postTextView.mas_bottom).with.offset(12.0f);
        make.bottom.equalTo(self.scrollView).with.offset(-12.0f);
        make.width.mas_equalTo([self.addPostVM pickedPhotoCollectionViewSize].width);
        make.height.mas_equalTo([self.addPostVM pickedPhotoCollectionViewSize].height);
    }];
    
    WEAKSELF
    self.postTextView.textViewHeightChangeBlock = ^(CGFloat postTextViewHeight) {
        STRONGSELF
        [strongSelf.postTextView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(postTextViewHeight);
        }];
    };
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //[self.postTextView becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.postTextView resignFirstResponder];
}

#pragma mark Notifications

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary* info = [notification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;

    [self.addImageButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).with.offset(-keyboardSize.height - 12.0f + self.view.safeAreaInsets.bottom);
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [self.addImageButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).with.offset(- 12.0f);
    }];
}

#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.addPostVM.imagePickerModel.selectedPhotos count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UFUIPickedImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UFUIPickedImageCell class]) forIndexPath:indexPath];
    
    [cell configWithImage:self.addPostVM.imagePickerModel.selectedPhotos[indexPath.row] indexPath:indexPath];
    cell.delegate = self;

    return cell;
}

#pragma mark UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.addPostVM.pickedPhotoCellSize;
}

#pragma mark UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self ufui_routeToImagePickerController:self.addPostVM.imagePickerModel completion:^{
        [self _reloadSelectedPhotoesCollectionView];
    }];
}

#pragma mark UFUIPickedImageCellDelegate

- (void)deleteSelectedPhotoCell:(NSIndexPath *)indexPath {
    [self.addPostVM.imagePickerModel.selectedPhotos removeObjectAtIndex:indexPath.row];
    [self.addPostVM.imagePickerModel.selectedAssets removeObjectAtIndex:indexPath.row];
    [self.selectedPhotoesCollectionView performBatchUpdates:^{
        [self.selectedPhotoesCollectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [self.selectedPhotoesCollectionView reloadData];
    }];
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView {
    // 输入的时候字符限制
    // 判断是否存在高亮字符，如果有，则不进行字数统计和字符串截断
    UITextRange *selectedRange = textView.markedTextRange;
    UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
    
    if (position) {
        return;
    }
    
    self.addPostVM.content = textView.text;
}

#pragma mark UI Actions

- (void)clickSendButton:(UIButton *)sender {
    [self.postTextView resignFirstResponder];
    
    NSString *errorMessage = @"";
    if (![self.addPostVM isAbleToPublish:&errorMessage]) {
        [self ufui_alertErrorWithMessage:errorMessage];
    } else {
        [self.view setUserInteractionEnabled:NO];
        [self.navigationController.navigationBar setUserInteractionEnabled:NO];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];

        WEAKSELF
        [self.addPostVM addPostInBackground:^(NSError * _Nullable error) {
            STRONGSELF
            [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
            [strongSelf.navigationController.navigationBar setUserInteractionEnabled:YES];
            [strongSelf.view setUserInteractionEnabled:YES];
            if (error) {
                [UFUIUFMServiceErrorHandler handleUFMServiceError:error];
            } else {
                // 发布成功后就可以重置addPostVM了
                [strongSelf.addPostVM clear];
                [[NSNotificationCenter defaultCenter] postNotificationName:UFUIPostAddedNotification object:strongSelf];
                [strongSelf dismissViewControllerAnimated:YES completion:nil];
            }
        }];
    }
}

- (void)clickCloseButton:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clickAddImageButton:(UIButton *)sender {
    [self ufui_routeToImagePickerController:self.addPostVM.imagePickerModel completion:^{
        [self _reloadSelectedPhotoesCollectionView];
    }];
}

# pragma mark Private Methods

- (void)_reloadSelectedPhotoesCollectionView {
    [self.selectedPhotoesCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.addPostVM.pickedPhotoCollectionViewSize.height);
    }];

    [self.selectedPhotoesCollectionView reloadData];
}

#pragma mark Getter/Setter

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    }
    
    return _scrollView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
    }
    
    return _contentView;
}

- (UFUIAutoHeightTextView *)postTextView {
    if (!_postTextView) {
        _postTextView = [[UFUIAutoHeightTextView alloc] initWithFrame:CGRectZero];
        _postTextView.placeholder = KUFUILocalization(@"addPostViewController.postTextView.placeholder");
        _postTextView.minNumberOfLines = 3;
        _postTextView.maxNumberOfLines = NSIntegerMax;
        _postTextView.delegate = self;
    }
    
    return _postTextView;
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

- (UIButton *)addImageButton {
    if (!_addImageButton) {
        _addImageButton = [[UIButton alloc] init];
        UIImageSymbolConfiguration *imageSymbolConfig = [UIImageSymbolConfiguration configurationWithPointSize:24.0f];
        [_addImageButton setImage:[UIImage systemImageNamed:@"photo.circle" withConfiguration:imageSymbolConfig] forState:UIControlStateNormal];
        [_addImageButton addTarget:self action:@selector(clickAddImageButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _addImageButton;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [[UIButton alloc] init];
        [_closeButton setImage:[UIImage systemImageNamed:@"xmark"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(clickCloseButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _closeButton;
}

- (UIButton *)postButton {
    if (!_postButton) {
        _postButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 60.0f, 24.0f)];
        _postButton.backgroundColor = [UIColor linkColor];
        
        [_postButton setTitleColor:[UIColor systemBackgroundColor] forState:UIControlStateNormal];
        [_postButton setTitleColor:[UIColor secondarySystemBackgroundColor] forState:UIControlStateDisabled];
        [_postButton setEnabled:NO];
        
        [_postButton addTarget:self action:@selector(clickSendButton:) forControlEvents:UIControlEventTouchUpInside];
        
        _postButton.layer.cornerRadius = 12.0f;
        _postButton.layer.masksToBounds = YES;
        [_postButton setTitle:KUFUILocalization(@"addPostViewController.postButton.title") forState:UIControlStateNormal];
        _postButton.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    }
    
    return _postButton;
}

- (UIVisualEffectView *)splitLineView {
    if (!_splitLineView) {
        _splitLineView = [[UIVisualEffectView alloc] init];
        _splitLineView.backgroundColor = [UIColor secondarySystemBackgroundColor];
        _splitLineView.alpha = 0.5;
        _splitLineView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    }
    
    return _splitLineView;
}

@end
