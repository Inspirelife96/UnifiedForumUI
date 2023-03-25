//
//  UFUIPostQueryViewController+UFUIPostQueryAddPostToTopicViewDelegate.m
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2022/12/8.
//

#import "UFUIPostQueryViewController+UFUIPostQueryAddPostToTopicViewDelegate.h"

#import "UFUIPostQueryAddPostToTopicView.h"
#import "UFUIPostQueryAddPostToTopicViewModel.h"
#import "UFUIImagePickerModel.h"

#import "UFUIUFMServiceErrorHandler.h"

#import "UIViewController+UFUIRoute.h"

#import "UFUIPostQueryViewModel.h"

@implementation UFUIPostQueryViewController (UFUIPostQueryAddPostToTopicViewDelegate)

- (void)clickPostButtonInAddPostView:(UFUIPostQueryAddPostToTopicView *)addPostView {
    if (![self ufui_isLogIn]) {
        [self ufui_routeToLogInAlertView];
    } else {
        UFUIPostQueryAddPostToTopicViewModel *addPostVM = addPostView.addPostVM;

        [self.view setUserInteractionEnabled:NO];
        [self.navigationController.navigationBar setUserInteractionEnabled:NO];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];

        WEAKSELF
        [addPostVM addPostInBackground:^(NSError * _Nullable error) {
            STRONGSELF
            [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
            [strongSelf.navigationController.navigationBar setUserInteractionEnabled:YES];
            [strongSelf.view setUserInteractionEnabled:YES];
            if (error) {
                [UFUIUFMServiceErrorHandler handleUFMServiceError:error];
            } else {
                [strongSelf.postQueryVM.addPostVM clear];
                [strongSelf.addPostView dismiss];
                [[NSNotificationCenter defaultCenter] postNotificationName:UFUIPostAddedNotification object:strongSelf];
            }
        }];
    }
}

- (void)clickAddImageButtonInAddPostView:(UFUIPostQueryAddPostToTopicView *)addPostView {
    UFUIPostQueryAddPostToTopicViewModel *addPostVM = addPostView.addPostVM;

    // 点击图片选择，则先导航去图片选择控制器
    [self ufui_routeToImagePickerController:addPostVM.imagePickerModel completion:^{
        // 如果选择了图片，则导航去AddPostViewController
        if (addPostVM.imagePickerModel.selectedPhotos.count > 0) {
            [self ufui_routeToAddPostViewController:addPostVM];
        } else {
            
        }
    }];
}

@end
