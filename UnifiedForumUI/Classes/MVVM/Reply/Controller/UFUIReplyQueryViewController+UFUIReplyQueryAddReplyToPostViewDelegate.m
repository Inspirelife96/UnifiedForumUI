//
//  UFUIReplyQueryViewController+UFUIReplyQueryAddReplyToPostViewDelegate.m
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2023/2/22.
//

#import "UFUIReplyQueryViewController+UFUIReplyQueryAddReplyToPostViewDelegate.h"

#import "UFUIReplyQueryAddReplyToPostView.h"

#import "UFUIReplyQueryAddReplyToPostViewModel.h"

#import "UFUIUFMServiceErrorHandler.h"

#import "UFUIConstants.h"

#import "UIViewController+UFUIRoute.h"

@implementation UFUIReplyQueryViewController (UFUIReplyQueryAddReplyToPostViewDelegate)

- (void)clickReplyButtonInAddReplyToPostView:(UFUIReplyQueryAddReplyToPostView *)addReplyToPostView {
    if (![self ufui_isLogIn]) {
        [self ufui_routeToLogInAlertView];
    } else {
        UFUIReplyQueryAddReplyToPostViewModel *addReplyToPostVM = addReplyToPostView.addReplyToPostVM;
        
        [self.view setUserInteractionEnabled:NO];
        [self.navigationController.navigationBar setUserInteractionEnabled:NO];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        WEAKSELF
        [addReplyToPostVM addReplyToPostInBackground:^(NSError * _Nullable error) {
            STRONGSELF
            [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
            [strongSelf.navigationController.navigationBar setUserInteractionEnabled:YES];
            [strongSelf.view setUserInteractionEnabled:YES];
            if (error) {
                [UFUIUFMServiceErrorHandler handleUFMServiceError:error];
            } else {
                // 取消
                [strongSelf.addReplyToPostView dismiss];
            }
        }];
    }
}

@end
