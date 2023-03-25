//
//  UFUIReplyQueryViewController+UFUIReplyQueryAddReplyToReplyViewDelegate.m
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2023/2/22.
//

#import "UFUIReplyQueryViewController+UFUIReplyQueryAddReplyToReplyViewDelegate.h"

#import "UFUIReplyQueryAddReplyToReplyView.h"

#import "UFUIReplyQueryAddReplyToReplyViewModel.h"

#import "UFUIUFMServiceErrorHandler.h"

#import "UFUIConstants.h"

#import "UIViewController+UFUIRoute.h"

@implementation UFUIReplyQueryViewController (UFUIReplyQueryAddReplyToReplyViewDelegate)

- (void)clickReplyButtonInAddReplyToReplyView:(UFUIReplyQueryAddReplyToReplyView *)addReplyToReplyView {
    if (![self ufui_isLogIn]) {
        [self ufui_routeToLogInAlertView];
    } else {
        UFUIReplyQueryAddReplyToReplyViewModel *addReplyToReplyVM = addReplyToReplyView.addReplyToReplyVM;
        
        [self.view setUserInteractionEnabled:NO];
        [self.navigationController.navigationBar setUserInteractionEnabled:NO];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        WEAKSELF
        [addReplyToReplyVM addReplyToReplyInBackground:^(NSError * _Nullable error) {
            STRONGSELF
            [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
            [strongSelf.navigationController.navigationBar setUserInteractionEnabled:YES];
            [strongSelf.view setUserInteractionEnabled:YES];
            if (error) {
                [UFUIUFMServiceErrorHandler handleUFMServiceError:error];
            } else {
                // 取消
                [strongSelf.addReplyToReplyView dismiss];
            }
        }];
    }
}

@end
