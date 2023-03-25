//
//  UFUIPostQueryViewController+UFUIPostQueryHeaderViewDelegate.m
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2022/12/10.
//

#import "UFUIPostQueryViewController+UFUIPostQueryHeaderViewDelegate.h"

#import "UFUIPostQueryViewModel.h"
#import "UFUIPostQueryHeaderView.h"

#import "UFUIPostQueryHeaderViewModel.h"

#import "UFUIUFMServiceErrorHandler.h"

#import "UIViewController+UFUIRoute.h"

@implementation UFUIPostQueryViewController (UFUIPostQueryHeaderViewDelegate)

- (void)clickAvatarButtonInPostQueryHeaderView:(UFUIPostQueryHeaderView *)postQueryHeaderView {
    UFUIPostQueryViewModel *postQueryVM = (UFUIPostQueryViewModel *)self.queryVM;
    [self ufui_routeToUserProfileViewController:postQueryVM.topicModel.fromUserModel];
}

- (void)clickUserNameButtonInPostQueryHeaderView:(UFUIPostQueryHeaderView *)postQueryHeaderView {
    [self clickAvatarButtonInPostQueryHeaderView:postQueryHeaderView];
}

- (void)clickFollowStatusButtonInPostQueryHeaderView:(UFUIPostQueryHeaderView *)postQueryHeaderView {
    UFUIPostQueryHeaderViewModel *postQueryHeaderVM = postQueryHeaderView.postQueryHeaderVM;

    [self.view setUserInteractionEnabled:NO];
    [self.navigationController.navigationBar setUserInteractionEnabled:NO];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    WEAKSELF
    [postQueryHeaderVM changeIsFollowedByCurrentUserInbackgroundWithBlock:^(NSError * _Nullable error) {
        STRONGSELF
        [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
        [strongSelf.navigationController.navigationBar setUserInteractionEnabled:YES];
        [strongSelf.view setUserInteractionEnabled:YES];
        if (error) {
            [UFUIUFMServiceErrorHandler handleUFMServiceError:error];
        }
    }];
}

- (void)clickFileCollectionViewIndexPath:(NSIndexPath *)indexPath inPostQueryHeaderView:(UFUIPostQueryHeaderView *)postQueryHeaderView {
    UFUIPostQueryHeaderViewModel *postQueryHeaderVM = postQueryHeaderView.postQueryHeaderVM;
    [self ufui_routeToImageBrowser:postQueryHeaderVM.imageDataArray currentPage:indexPath.row];
}

@end
