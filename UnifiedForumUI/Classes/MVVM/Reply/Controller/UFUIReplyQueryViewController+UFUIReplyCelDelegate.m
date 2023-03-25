//
//  UFUIReplyQueryViewController+UFUIReplyCelDelegate.m
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2023/2/21.
//

#import "UFUIReplyQueryViewController+UFUIReplyCelDelegate.h"

#import "UFUIReplyCell.h"
#import "UFUIReplyQueryAddReplyToReplyView.h"

#import "UFUIReplyCellViewModel.h"
#import "UFUIReplyQueryViewModel.h"
#import "UFUIReplyQueryAddReplyToReplyViewModel.h"

#import "UFUIUFMServiceErrorHandler.h"

#import "UIViewController+UFUIRoute.h"
#import "SCLAlertView+ShowOnMostTopViewController.h"

@implementation UFUIReplyQueryViewController (UFUIReplyCelDelegate)

- (void)clickAvatarButtonInCell:(UFUIReplyCell *)replyCell {
    UFUIReplyCellViewModel *replyCellVM = (UFUIReplyCellViewModel *)replyCell.objectCellVM;
    [self ufui_routeToUserProfileViewController:replyCellVM.replyModel.fromUserModel];
}

- (void)clickUserNameButtonInCell:(UFUIReplyCell *)replyCell {
    [self clickAvatarButtonInCell:replyCell];
}

- (void)clickLikeButtonInCell:(UFUIReplyCell *)replyCell {
    if (![self ufui_isLogIn]) {
        [self ufui_routeToLogInAlertView];
    } else {
        UFUIReplyCellViewModel *replyCellVM = (UFUIReplyCellViewModel *)replyCell.objectCellVM;

        //
        [self.view setUserInteractionEnabled:NO];
        [self.navigationController.navigationBar setUserInteractionEnabled:NO];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];

        WEAKSELF
        [replyCellVM likeReplyInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            STRONGSELF
            [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
            [strongSelf.navigationController.navigationBar setUserInteractionEnabled:YES];
            [strongSelf.view setUserInteractionEnabled:YES];
            if (error) {
                [UFUIUFMServiceErrorHandler handleUFMServiceError:error];
            } else {
                [replyCell updateLikeButton];
            }
        }];
    }
}

- (void)clickMoreButtonInCell:(UFUIReplyCell *)replyCell {
    if (![self ufui_isLogIn]) {
        [self ufui_routeToLogInAlertView];
    } else {
        SCLAlertView *moreAlertView = [[SCLAlertView alloc] init];
        
        NSString *title = KUFUILocalization(@"UFUIReplyQueryViewController.replyCell.moreAlertView.title");
        NSString *subTitle = KUFUILocalization(@"UFUIReplyQueryViewController.replyCell.moreAlertView.subTitle");
        NSString *replyButtonText = KUFUILocalization(@"UFUIReplyQueryViewController.replyCell.moreAlertView.replyButton.title");
        NSString *reportButtonText = KUFUILocalization(@"UFUIReplyQueryViewController.replyCell.moreAlertView.reportButton.title");
        NSString *closeButtonText = KUFUILocalization(@"UFUIReplyQueryViewController.replyCell.moreAlertView.closeButton.title");

        
        // 回复
        [moreAlertView addButton:replyButtonText actionBlock:^{
            UFUIReplyCellViewModel *replyCellVM = (UFUIReplyCellViewModel *)replyCell.objectCellVM;
            
            self.replyQueryVM.addReplyToReplyVM = [[UFUIReplyQueryAddReplyToReplyViewModel alloc] initWithPostModel:self.replyQueryVM.postModel replyModel:replyCellVM.replyModel];

            [self.addReplyToReplyView configWithAddReplyToReplyVM:self.replyQueryVM.addReplyToReplyVM];
            [self.addReplyToReplyView show];
        }];
        
        // 举报
        [moreAlertView addButton:reportButtonText actionBlock:^{
            // Todo:
        }];
        
        [moreAlertView ufui_showInfoOnMostTopViewControllerWithTitle:title subTitle:subTitle closeButtonTitle:closeButtonText duration:0.0f];
    }
}

@end
