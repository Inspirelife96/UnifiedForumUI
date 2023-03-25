//
//  UFUIPostQueryViewController+UFUIPostQueryFooterViewDelegate.m
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2022/12/8.
//

#import "UFUIPostQueryViewController+UFUIPostQueryFooterViewDelegate.h"

#import "UFUIPostQueryAddPostToTopicView.h"
#import "UFUIPostQueryAddPostToTopicViewModel.h"
#import "UFUIImagePickerModel.h"

#import "UFUIPostQueryViewModel.h"

#import "UFUIUFMServiceErrorHandler.h"

#import "UFUIPostQueryFooterViewModel.h"

#import "UIViewController+UFUIRoute.h"

#import "UFUIPostQueryFooterView.h"

@implementation UFUIPostQueryViewController (UFUIPostQueryFooterViewDelegate)

- (void)clickShareButtonInPostQueryFooterView:(UFUIPostQueryFooterView *)postQueryFooterView {
    
}

- (void)clickLikeButtonInPostQueryFooterView:(UFUIPostQueryFooterView *)postQueryFooterView {
    if (![self ufui_isLogIn]) {
        [self ufui_routeToLogInAlertView];
    } else {
        UFUIPostQueryFooterViewModel *postQueryFooterVM = postQueryFooterView.postQueryFooterVM;
        
        [self.view setUserInteractionEnabled:NO];
        [self.navigationController.navigationBar setUserInteractionEnabled:NO];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        WEAKSELF
        [postQueryFooterVM likeTopicInBackgroundWithBlock:^(NSError * _Nullable error) {
            STRONGSELF
            [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
            [strongSelf.navigationController.navigationBar setUserInteractionEnabled:YES];
            [strongSelf.view setUserInteractionEnabled:YES];
            if (error) {
                [UFUIUFMServiceErrorHandler handleUFMServiceError:error];
            }
        }];
    }
}

- (void)clickScrollToTopButtonInPostQueryFooterView:(UFUIPostQueryFooterView *)postQueryFooterView {
    [self.tableView setContentOffset:CGPointZero animated:YES];
}

- (void)clickPostTextFieldInPostQueryFooterView:(UFUIPostQueryFooterView *)postQueryFooterView {
    if (![self ufui_isLogIn]) {
        [self ufui_routeToLogInAlertView];
    } else {
        if (self.postQueryVM.addPostVM.imagePickerModel.selectedPhotos.count > 0) {
            [self ufui_routeToAddPostViewController:self.postQueryVM.addPostVM];
        } else {
            [self.addPostView configWithAddPostViewModel:self.postQueryVM.addPostVM];
            [self.addPostView show];
        }
    }
}

//- (void)clearEdit:(UITextField *)editTextField {
//
//}

@end
