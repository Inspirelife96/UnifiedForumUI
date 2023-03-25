//
//  UFUIPostQueryViewController+UFUIPostCellDelegate.m
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2022/12/5.
//

#import "UFUIPostQueryViewController+UFUIPostCellDelegate.h"

#import "UFUIPostCell.h"
#import "UFUIPostCellViewModel.h"

#import "UFUIConstants.h"

#import "UFUIUFMServiceErrorHandler.h"

#import "UIViewController+UFUIRoute.h"
#import "SCLAlertView+ShowOnMostTopViewController.h"

#import "UFUIPostQueryAddReplyToPostView.h"
#import "UFUIPostQueryAddReplyToPostViewModel.h"

#import "UFUIPostQueryViewModel.h"

@implementation UFUIPostQueryViewController (UFUIPostCellDelegate)

- (void)clickAvatarButtonInCell:(UFUIPostCell *)postCell {
    UFUIPostCellViewModel *postCellVM = (UFUIPostCellViewModel *)postCell.objectCellVM;
    [self ufui_routeToUserProfileViewController:postCellVM.postModel.fromUserModel];
}

- (void)clickUserNameButtonInCell:(UFUIPostCell *)postCell {
    UFUIPostCellViewModel *postCellVM = (UFUIPostCellViewModel *)postCell.objectCellVM;
    [self ufui_routeToUserProfileViewController:postCellVM.postModel.fromUserModel];
}

- (void)clickLikeButtonInCell:(UFUIPostCell *)postCell {
    if (![self ufui_isLogIn]) {
        [self ufui_routeToLogInAlertView];
    } else {
        UFUIPostCellViewModel *postCellVM = (UFUIPostCellViewModel *)postCell.objectCellVM;

        //
        [self.view setUserInteractionEnabled:NO];
        [self.navigationController.navigationBar setUserInteractionEnabled:NO];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];

        WEAKSELF
        [postCellVM likePostInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            STRONGSELF
            [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
            [strongSelf.navigationController.navigationBar setUserInteractionEnabled:YES];
            [strongSelf.view setUserInteractionEnabled:YES];
            if (error) {
                [UFUIUFMServiceErrorHandler handleUFMServiceError:error];
            } else {
                [postCell updateLikeButton];
            }
        }];
    }
}

- (void)clickMoreButtonInCell:(UFUIPostCell *)postCell {
    if (![self ufui_isLogIn]) {
        [self ufui_routeToLogInAlertView];
    } else {
        SCLAlertView *moreAlertView = [[SCLAlertView alloc] init];
        
        // 回复
        [moreAlertView addButton:KUFUILocalization(@"postCell.moreButton.list.reply") actionBlock:^{
            UFUIPostCellViewModel *postCellVM = (UFUIPostCellViewModel *)postCell.objectCellVM;
            self.postQueryVM.addReplyVM = [[UFUIPostQueryAddReplyToPostViewModel alloc] initWithPostCellViewModel:postCellVM];
            [self.addReplyView configWithAddReplyVM:self.postQueryVM.addReplyVM];
            [self.addReplyView show];
        }];
        
        // 举报
        [moreAlertView addButton:KUFUILocalization(@"postCell.moreButton.list.report") actionBlock:^{
            // Todo:
        }];
        
        NSString *title = KUFUILocalization(@"postCell.moreAlertView.title");
        NSString *subTitle = KUFUILocalization(@"postCell.moreAlertView.subTitle");
        NSString *closeButtonTitle = KUFUILocalization(@"postCell.moreAlertView.closeButtonTitle");
        
        [moreAlertView ufui_showInfoOnMostTopViewControllerWithTitle:title subTitle:subTitle closeButtonTitle:closeButtonTitle duration:0.0f];
    }
}

- (void)clickFileCollectionViewAtIndexPath:(NSIndexPath *)indexPath inCell:(UFUIPostCell *)postCell {
    UFUIPostCellViewModel *postCellVM = (UFUIPostCellViewModel *)postCell.objectCellVM;
    [self ufui_routeToImageBrowser:postCellVM.imageDataArray currentPage:indexPath.row];
}

- (void)clickReplyTableViewAtIndexPath:(NSIndexPath *)indexPath inCell:(UFUIPostCell *)postCell {
    // Todo
}

- (void)clickMoreReplyButtonInCell:(UFUIPostCell *)postCell {
    // Todo
}

@end
