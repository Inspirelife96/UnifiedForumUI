//
//  UFUIReplyQueryViewController+UFUIReplyQueryHeaderViewDelegate.m
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2023/2/23.
//

#import "UFUIReplyQueryViewController+UFUIReplyQueryHeaderViewDelegate.h"

#import "UFUIReplyQueryViewModel.h"
#import "UFUIReplyQueryHeaderView.h"
#import "UFUIReplyQueryHeaderViewModel.h"

#import "UFUIUFMServiceErrorHandler.h"

#import "UFUIReplyQueryAddReplyToPostViewModel.h"
#import "UFUIReplyQueryAddReplyToPostView.h"

#import "UIViewController+UFUIRoute.h"

#import "SCLAlertView+ShowOnMostTopViewController.h"

@implementation UFUIReplyQueryViewController (UFUIReplyQueryHeaderViewDelegate)

- (void)clickAvatarButtonInHeaderView:(UFUIReplyQueryHeaderView *)headerView {
    UFUIReplyQueryViewModel *replyQueryVM = (UFUIReplyQueryViewModel *)self.queryVM;
    [self ufui_routeToUserProfileViewController:replyQueryVM.postModel.fromUserModel];
}

- (void)clickUserNameButtonInHeaderView:(UFUIReplyQueryHeaderView *)headerView {
    [self clickAvatarButtonInHeaderView:headerView];
}

- (void)clickLikeButtonInHeaderView:(UFUIReplyQueryHeaderView *)headerView {
    if (![self ufui_isLogIn]) {
        [self ufui_routeToLogInAlertView];
    } else {
        UFUIReplyQueryHeaderViewModel *replyQueryHeaderVM = headerView.replyQueryHeaderVM;
        
        [self.view setUserInteractionEnabled:NO];
        [self.navigationController.navigationBar setUserInteractionEnabled:NO];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        WEAKSELF
        [replyQueryHeaderVM likePostInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            STRONGSELF
            [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
            [strongSelf.navigationController.navigationBar setUserInteractionEnabled:YES];
            [strongSelf.view setUserInteractionEnabled:YES];
            if (error) {
                [UFUIUFMServiceErrorHandler handleUFMServiceError:error];
            } else {
                [self.replyQueryHeaderView updateLikeButton];
            }
        }];
    }
}

- (void)clickMoreButtonInHeaderView:(UFUIReplyQueryHeaderView *)headerView {
    if (![self ufui_isLogIn]) {
        [self ufui_routeToLogInAlertView];
    } else {
        SCLAlertView *moreAlertView = [[SCLAlertView alloc] init];
        
        NSString *title = KUFUILocalization(@"UFUIReplyQueryViewController.replyQueryHeaderView.moreAlertView.title");
        NSString *subTitle = KUFUILocalization(@"UFUIReplyQueryViewController.replyQueryHeaderView.moreAlertView.subTitle");
        NSString *replyButtonText = KUFUILocalization(@"UFUIReplyQueryViewController.replyQueryHeaderView.moreAlertView.replyButton.title");
        NSString *reportButtonText = KUFUILocalization(@"UFUIReplyQueryViewController.replyQueryHeaderView.moreAlertView.reportButton.title");
        NSString *closeButtonText = KUFUILocalization(@"UFUIReplyQueryViewController.replyQueryHeaderView.moreAlertView.closeButton.title");

        // 回复
        [moreAlertView addButton:replyButtonText actionBlock:^{
            if (!self.replyQueryVM.addReplyToPostVM) {
                self.replyQueryVM.addReplyToPostVM = [[UFUIReplyQueryAddReplyToPostViewModel alloc] initWithPostModel:self.replyQueryVM.postModel];
            }
            
            [self.addReplyToPostView configWithAddReplyToPostVM:self.replyQueryVM.addReplyToPostVM];
            
            [self.addReplyToPostView show];
            
        }];
        
        // 举报
        [moreAlertView addButton:reportButtonText actionBlock:^{
            // Todo:
        }];
        
        [moreAlertView ufui_showInfoOnMostTopViewControllerWithTitle:title subTitle:subTitle closeButtonTitle:closeButtonText duration:0.0f];
    }
}

- (void)clickFileCollectionViewAtIndexPath:(NSIndexPath *)indexPath inHeaderView:(UFUIReplyQueryHeaderView *)headerView {
    UFUIReplyQueryHeaderViewModel *replyQueryHeaderVM = headerView.replyQueryHeaderVM;
    [self ufui_routeToImageBrowser:replyQueryHeaderVM.imageDataArray currentPage:indexPath.row];
}

@end
