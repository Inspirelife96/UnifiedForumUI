//
//  UFUIPostQueryViewController+UFUIPostQueryAddReplyToPostViewDelegate.m
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2022/12/7.
//

#import "UFUIPostQueryViewController+UFUIPostQueryAddReplyToPostViewDelegate.h"

#import "UFUIConstants.h"

#import "UFUIPostQueryAddReplyToPostViewModel.h"

#import "UFUIUFMServiceErrorHandler.h"

#import "UFUIPostCell.h"

#import "UFUIPostQueryAddReplyToPostView.h"

#import "UFUIPostCellViewModel.h"

#import "UIViewController+UFUIRoute.h"

@implementation UFUIPostQueryViewController (UFUIPostQueryAddReplyToPostViewDelegate)

- (void)clickReplyButtonInAddReplyView:(UFUIPostQueryAddReplyToPostView *)addReplyView {
    if (![self ufui_isLogIn]) {
        [self ufui_routeToLogInAlertView];
    } else {
        UFUIPostQueryAddReplyToPostViewModel *addReplyVM = addReplyView.addReplyVM;
        UFUIPostCellViewModel *postCellVM = addReplyVM.postCellVM;
        
        [self.view setUserInteractionEnabled:NO];
        [self.navigationController.navigationBar setUserInteractionEnabled:NO];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        WEAKSELF
        [addReplyVM addReplyInBackground:^(NSError * _Nullable error) {
            STRONGSELF
            [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
            [strongSelf.navigationController.navigationBar setUserInteractionEnabled:YES];
            [strongSelf.view setUserInteractionEnabled:YES];
            if (error) {
                [UFUIUFMServiceErrorHandler handleUFMServiceError:error];
            } else {
                // 需要重新规划ReplyTableView的内容
                [postCellVM sizeReplyTableView];
                
                // 这边为了防止刷新时的动画
                [UIView setAnimationsEnabled:NO];
                [strongSelf.tableView performBatchUpdates:^{
                    [strongSelf.tableView reloadRowsAtIndexPaths:@[postCellVM.indexPath] withRowAnimation:UITableViewRowAnimationNone];
                } completion:^(BOOL finished) {
                    [UIView setAnimationsEnabled:YES];
                }];
                
                // 取消
                [strongSelf.addReplyView dismiss];
            }
        }];
    }
}

@end
