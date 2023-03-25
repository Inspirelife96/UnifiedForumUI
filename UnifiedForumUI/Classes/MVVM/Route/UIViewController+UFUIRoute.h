//
//  UIViewController+UFUIRoute.h
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2022/11/21.
//

#import <UIKit/UIKit.h>

@class UFUIImagePickerModel;
@class UFUIPostQueryAddPostToTopicViewModel;

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (UFUIRoute)

- (BOOL)ufui_isLogIn;

- (void)ufui_routeToLogInAlertView;

- (void)ufui_routeToLogInViewController;

- (void)ufui_routeToUserProfileViewController:(UFMUserModel *)userModel;

- (void)ufui_routeToImagePickerController:(UFUIImagePickerModel *)imagePickerModel completion:(void (^)(void))completion;

- (void)ufui_routeToAddPostViewController:(UFUIPostQueryAddPostToTopicViewModel *)addPostVM;

- (void)ufui_routeToImageBrowser:(nonnull NSArray<YBIBImageData *> *)imageDataArray currentPage:(NSInteger)currentPage;

//- (void)ufui_routToReplyReplyQueryViewController:();

@end

NS_ASSUME_NONNULL_END
