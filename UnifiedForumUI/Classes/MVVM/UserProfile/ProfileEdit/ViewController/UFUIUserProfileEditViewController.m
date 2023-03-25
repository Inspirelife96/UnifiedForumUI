//
//  UFUIUserProfileEditViewController.m
//  UnifiedForumUI-INSParseUI
//
//  Created by XueFeng Chen on 2021/10/24.
//

#import "UFUIUserProfileEditViewController.h"

#import "UFUIUserProfileEditDetailViewController.h"

#import "UFUIUserProfileEditHeaderView.h"

#import "UFUIUserProfileEditViewModel.h"
#import "UFMUserModel.h"

#import "UFUIUFMServiceErrorHandler.h"

#import "SCLAlertView+ShowOnMostTopViewController.h"

#import "UFUIConstants.h"

@interface UFUIUserProfileEditViewController () <UFUIUserProfileEditHeaderViewDelegate, TZImagePickerControllerDelegate>

// 右上角保存按钮
@property (nonatomic, strong) UIBarButtonItem *saveBarButtonItem;

// 头部视图
@property (nonatomic, strong) UFUIUserProfileEditHeaderView *userProfileEditHeaderView;

@property (nonatomic, strong) UFUIUserProfileEditViewModel *userProfileEditVM;
@property (nonatomic, strong) UFMUserModel *userModel;

@end

@implementation UFUIUserProfileEditViewController

#pragma mark - UIViewController Life Cycle

- (instancetype)initWithUserModel:(UFMUserModel *)userModel {
    if (self = [super init]) {
        _userModel = userModel;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 配置右侧导航栏"保存"按钮
    self.navigationItem.rightBarButtonItem = self.saveBarButtonItem;
        
    // 监控内容是否有修改
    [self addObserver:self forKeyPath:@"userProfileEditVM.isBackgroundImageChanged" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"userProfileEditVM.isAvatarChanged" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"userProfileEditVM.isSignatureChanged" options:NSKeyValueObservingOptionNew context:nil];
}

// 拦截导航栏返回事件
- (BOOL)navigationShouldPopOnBackButton {
    // 如果内容被修改了，则需要询问是否需要保存
    if (self.userProfileEditVM.isProfileInfoChanged) {
        NSString *title = KUFUILocalization(@"userProfileChangedAlertView.title");
        NSString *subTitle = KUFUILocalization(@"userProfileChangedAlertView.subTitle");
        NSString *withoutSaveButtonTitle = KUFUILocalization(@"userProfileChangedAlertView.withoutSaveButton.title");
        NSString *waitButtonTitle = KUFUILocalization(@"userProfileChangedAlertView.waitButton.title");

        SCLAlertView *userProfileChangedAlertView = [[SCLAlertView alloc] init];
        [userProfileChangedAlertView addButton:withoutSaveButtonTitle actionBlock:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
        [userProfileChangedAlertView ufui_showWarningOnMostTopViewControllerWithTitle:title subTitle:subTitle closeButtonTitle:waitButtonTitle duration:0];
        
        return NO;
    } else {
        return YES;
    }
}

- (void)dealloc{
    [self removeObserver:self forKeyPath:@"userProfileEditVM.isBackgroundImageChanged"];
    [self removeObserver:self forKeyPath:@"userProfileEditVM.isAvatarChanged"];
    [self removeObserver:self forKeyPath:@"userProfileEditVM.isSignatureChanged"];
}

# pragma mark KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"userProfileEditVM.isBackgroundImageChanged"] ||
        [keyPath isEqualToString:@"userProfileEditVM.isAvatarChanged"] ||
        [keyPath isEqualToString:@"userProfileEditVM.isSignatureChanged"]) {
        // 安全起见，我们可能会在子线程更新KVO监控的值，因此如果需要UI更新的话，务必在主线程中执行。
        dispatch_async(dispatch_get_main_queue(), ^{
            [self _updateSaveBarButtonItemStatus];
        });
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - UI Actions

- (void)clickSaveBarButtonItem:(id)sender {
    NSAssert([self.userProfileEditVM isProfileInfoChanged], @"Nothing Changed, Save Button Should Be Disabled");
    
    // 保存到数据库，成功则返回，出错则显示错误信息并保持当前页面。
    [self.view setUserInteractionEnabled:NO];
    [self.navigationController.navigationBar setUserInteractionEnabled:NO];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    WEAKSELF
    [self.userProfileEditVM saveUserProfileInfoInBackgroundWithBlock:^(NSError * _Nonnull error) {
        STRONGSELF
        [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
        [strongSelf.navigationController.navigationBar setUserInteractionEnabled:YES];
        [strongSelf.view setUserInteractionEnabled:YES];
        
        if (error) {
            [UFUIUFMServiceErrorHandler handleUFMServiceError:error];
        } else {
            // 保存成功，则不需要做任何事。
        }
    }];
}

#pragma mark UFUIPageMenuViewDataSource

- (NSInteger)numberOfMenusInPageMenuView:(UFUIPageMenuView *)tabView {
    return 0;
}

- (NSString *)pageMenuView:(UFUIPageMenuView *)pageMenuView menuTitleAtIndex:(NSInteger)index {
    return @"";
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
    return floor([UIScreen jk_width] * 2.0f / 3.0f);
}

- (UIView *)headerViewInPagerView:(UFUIPageView *)pagerView {
    return self.userProfileEditHeaderView;
}

- (NSInteger)numberOfPagesInPagerView:(UFUIPageView *)pagerView {
    return 1;
}

- (UIViewController<UFUIPageContentViewControllerProtocol> *)pageView:(UFUIPageView *)pagerView initPageContentViewControllerAtIndex:(NSInteger)index {
    
    UFUIUserProfileEditDetailViewController *userProfileEditDetailVC = [[UFUIUserProfileEditDetailViewController alloc] initWithUserProfileEditViewModel:self.userProfileEditVM];
    
    return userProfileEditDetailVC;
}

- (CGFloat)heightForTabViewInPagerView:(UFUIPageView *)pagerView {
    return 0.0f;
}

#pragma mark - UFUIUserProfileEditHeaderViewDelegate

- (void)changeBackgroundImage {
    [self _pushTZImagePickerControllerWithDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        if (photos && photos.count > 0) {
            self.userProfileEditVM.selectedBackgroundImage = photos[0];
            self.userProfileEditVM.isBackgroundImageChanged = YES;
            [self.userProfileEditHeaderView configWithUserProfileEditViewModel:self.userProfileEditVM];
        }
    }];
}

- (void)changeAvatarImage {
    [self _pushTZImagePickerControllerWithDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        if (photos && photos.count > 0) {
            self.userProfileEditVM.selectedAvatarImage = photos[0];
            self.userProfileEditVM.isAvatarImageChanged = YES;
            [self.userProfileEditHeaderView configWithUserProfileEditViewModel:self.userProfileEditVM];
        }
    }];
}

#pragma mark - Private Methods

// 如果内容有修改，则激活右上角的保存按钮。
- (void)_updateSaveBarButtonItemStatus {
    if ([self.userProfileEditVM isProfileInfoChanged]) {
        [self.saveBarButtonItem setEnabled:YES];
    } else {
        [self.saveBarButtonItem setEnabled:NO];
    }
}

// 图片选择其，由TZImagePickerController提供
- (void)_pushTZImagePickerControllerWithDidFinishPickingPhotosHandle:(void (^)(NSArray<UIImage *> *photos,NSArray *assets,BOOL isSelectOriginalPhoto))didFinishPickingPhotosHandle {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    imagePickerVc.isSelectOriginalPhoto = NO;
    
    imagePickerVc.allowTakePicture = YES; // 在内部显示拍照按钮
    imagePickerVc.allowTakeVideo = NO;   // 在内部显示拍视频按

    // 2. 在这里设置imagePickerVc的外观
    imagePickerVc.iconThemeColor = [UIColor colorWithRed:31 / 255.0 green:185 / 255.0 blue:34 / 255.0 alpha:1.0];
    imagePickerVc.showPhotoCannotSelectLayer = YES;
    imagePickerVc.cannotSelectLayerColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.allowPickingGif = NO;
    imagePickerVc.allowPickingMultipleVideo = NO; // 是否可以多选视频
    
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = YES;
    
    
    // 5. Single selection mode, valid when maxImagesCount = 1
    // 5. 单选模式,maxImagesCount为1时才生效

    // 设置竖屏下的裁剪尺寸
    NSInteger left = 30;
    NSInteger widthHeight = self.view.jk_width - 2 * left;
    NSInteger top = (self.view.jk_height - widthHeight) / 2;
    imagePickerVc.cropRect = CGRectMake(left, top, widthHeight, widthHeight);
    imagePickerVc.scaleAspectFillCrop = YES;

    imagePickerVc.statusBarStyle = UIStatusBarStyleLightContent;
    
    // 设置是否显示图片序号
    imagePickerVc.showSelectedIndex = YES;
    
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        didFinishPickingPhotosHandle(photos, assets, isSelectOriginalPhoto);
    }];
    
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark - Getter/Setter

- (UFUIUserProfileEditHeaderView *)userProfileEditHeaderView {
    if (!_userProfileEditHeaderView) {
        _userProfileEditHeaderView = [[UFUIUserProfileEditHeaderView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen jk_width], 256.0f)];
        [_userProfileEditHeaderView configWithUserProfileEditViewModel:self.userProfileEditVM];
        _userProfileEditHeaderView.delegate = self;
    }
    
    return _userProfileEditHeaderView;
}

- (UFUIUserProfileEditViewModel *)userProfileEditVM {
    if (!_userProfileEditVM) {
        _userProfileEditVM = [[UFUIUserProfileEditViewModel alloc] initWithUserViewModel:self.userModel];
    }
    
    return _userProfileEditVM;
}

- (UIBarButtonItem *)saveBarButtonItem {
    if (!_saveBarButtonItem) {
        _saveBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:KUFUILocalization(@"userProfileEditViewController.saveBarButtonItem.title") style:UIBarButtonItemStylePlain target:self action:@selector(clickSaveBarButtonItem:)];
        [_saveBarButtonItem setEnabled:NO];
    }
    
    return _saveBarButtonItem;
}

@end
