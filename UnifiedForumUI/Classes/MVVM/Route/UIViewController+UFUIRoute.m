//
//  UIViewController+UFUIRoute.m
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2022/11/21.
//

#import "UIViewController+UFUIRoute.h"

#import "UFUIUserProfileViewController.h"

#import "UFUILogInViewController.h"
#import "UFUILogInViewModel.h"

#import "UFUIImagePickerModel.h"

#import "UFUIPostQueryAddPostToTopicViewModel.h"

#import "UFUIAddPostViewController.h"

#import "UFUILogInViewController.h"

#import "UFUIConstants.h"

#import "SCLAlertView+ShowOnMostTopViewController.h"

@implementation UIViewController (UFUIRoute)


- (void)ufui_routeToUserProfileViewController:(UFMUserModel *)userModel {
    UFUIUserProfileViewController *userProfileVC = [[UFUIUserProfileViewController alloc] initWithUserModel:userModel];
    [self.navigationController pushViewController:userProfileVC animated:YES];
}

- (void)ufui_routToLogInViewController {
    UFUILogInViewModel *logInVM = [[UFUILogInViewModel alloc] init];
    UFUILogInViewController *logInVC = [[UFUILogInViewController alloc] initWithLogInViewModel:logInVM];
    [self presentViewController:logInVC animated:YES completion:nil];
}

- (void)ufui_routeToImagePickerController:(UFUIImagePickerModel *)imagePickerModel completion:(void (^)(void))completion {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:imagePickerModel.maxSelectedPhotoCount columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    imagePickerVc.isSelectOriginalPhoto = imagePickerModel.isSelectOriginalPhoto;
    
    if (imagePickerModel.maxSelectedPhotoCount > 1) {
        // 1.设置目前已经选中的图片数组
        imagePickerVc.selectedAssets = imagePickerModel.selectedAssets; // 目前已经选中的图片数组
    }
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

        imagePickerModel.selectedPhotos = [NSMutableArray arrayWithArray:photos];
        imagePickerModel.selectedAssets = [NSMutableArray arrayWithArray:assets];
        imagePickerModel.isSelectOriginalPhoto = isSelectOriginalPhoto;

        completion();
    }];
    
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)ufui_routeToAddPostViewController:(UFUIPostQueryAddPostToTopicViewModel *)addPostVM {
    UFUIAddPostViewController *addPostVC = [[UFUIAddPostViewController alloc] initWithAddPostViewModel:addPostVM];
    UINavigationController *addPostNC = [[UINavigationController alloc] initWithRootViewController:addPostVC];
    addPostNC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:addPostNC animated:YES completion:nil];
}

- (void)ufui_routeToImageBrowser:(nonnull NSArray<YBIBImageData *> *)imageDataArray currentPage:(NSInteger)currentPage {
    YBImageBrowser *browser = [YBImageBrowser new];
    browser.defaultToolViewHandler.topView.operationType = YBIBTopViewOperationTypeSave;
    browser.dataSourceArray = imageDataArray;
    browser.currentPage = currentPage;
    [browser showToView:[[UIApplication sharedApplication] windows][0]];
}

- (void)ufui_routeToLogInAlertView {
    SCLAlertView *logInAlertView = [[SCLAlertView alloc] init];
    [logInAlertView addButton:KUFUILocalization(@"logInAlertView.logInButton.title") actionBlock:^{
        [self ufui_routeToLogInViewController];
    }];
    
    NSString *title = KUFUILocalization(@"logInAlertView.title");
    NSString *subTitle = KUFUILocalization(@"logInAlertView.subTitle");
    NSString *closeButtonTitle = KUFUILocalization(@"logInAlertView.closeButton.title");

    [logInAlertView ufui_showInfoOnMostTopViewControllerWithTitle:title subTitle:subTitle closeButtonTitle:closeButtonTitle duration:0.0];
}

- (void)ufui_routeToLogInViewController {
    UFUILogInViewController *logInVC = [[UFUILogInViewController alloc] init];
    logInVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:logInVC animated:YES completion:nil];
}

- (BOOL)ufui_isLogIn {
    if ([UFMService currentUserModel]) {
        return YES;
    } else {
        return NO;
    }
}

@end
