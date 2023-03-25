//
//  UFUIReplyQueryViewController+UFUIReplyQueryFooterViewDelegate.m
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2023/2/23.
//

#import "UFUIReplyQueryViewController+UFUIReplyQueryFooterViewDelegate.h"

#import "UFUIReplyQueryFooterView.h"
#import "UFUIReplyQueryAddReplyToPostView.h"

#import "UFUIReplyQueryViewModel.h"
#import "UFUIReplyQUeryAddReplyToPostViewModel.h"

#import "UIViewController+UFUIRoute.h"

@implementation UFUIReplyQueryViewController (UFUIReplyQueryFooterViewDelegate)

- (void)clickReplyTextFieldInReplyQueryFooterView:(UFUIReplyQueryFooterView *)replyQueryFooterView {
    // 点击底部的工具条
    if (![self ufui_isLogIn]) {
        // 没有登录的话，直接跳转到登录界面
        [self ufui_routeToLogInAlertView];
    } else {
        // 看看是否存在草稿
        if (!self.replyQueryVM.addReplyToPostVM) {
            self.replyQueryVM.addReplyToPostVM = [[UFUIReplyQueryAddReplyToPostViewModel alloc] initWithPostModel:self.replyQueryVM.postModel];
        }
        
        // 配置addReplyToPostView的内容
        [self.addReplyToPostView configWithAddReplyToPostVM:self.replyQueryVM.addReplyToPostVM];
        
        // 展示addReplyToPostView，用户可以在这个视图里进行回复内容给的编辑
        [self.addReplyToPostView show];
    }
}

@end
