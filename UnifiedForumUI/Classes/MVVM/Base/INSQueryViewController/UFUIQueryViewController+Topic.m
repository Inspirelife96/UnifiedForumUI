//
//  UFUIQueryViewController+Topic.m
//  INSParseUI
//
//  Created by XueFeng Chen on 2021/7/5.
//

#import "UFUIQueryViewController+Topic.h"

//#import "UIViewController+INS_OpenLinkInSafari.h"
//
//#import "UFUIPostQueryViewModel.h"
//#import "UFUIPostQueryViewController.h"

@implementation UFUIQueryViewController (Topic)

//- (void)clickTopicForwardFrom:(INSTopic *)topic {
//    //[self ins_openLinkInSafari:topic.forwardFrom];
//}
//
//- (void)commentTopic:(UFMTopicModel *)topicModel {
////    UFUIPostQueryViewModel *commentQueryVM = [[UFUIPostQueryViewModel alloc] initWithTopicModel:topicModel];
////    UFUIPostQueryViewController *commentQyeryVC = [[UFUIPostQueryViewController alloc] initWithQueryVM:commentQueryVM topicModel:topicModel];
////    commentQyeryVC.hidesBottomBarWhenPushed = YES;
////    [self.navigationController pushViewController:commentQyeryVC animated:YES];
//}
//
//- (void)likeTopic:(UFMTopicModel *)topicModel {
//    
//}
//
//- (void)shareTopic:(UFMTopicModel *)topicModel {
//    
//}

//- (void)likeArticle:(PFArticleObjectViewModel *)articleObjectVM {
//    if (![self isLogin]) {
//        [self showLoginAlertViewWithSubTitle:@"只有登录用户才可以进行操作"];
//        return;
//    }
//
//    [self showProgress:@""];
//    [self.tableView setUserInteractionEnabled:NO];
//
//    [articleObjectVM likeArticleWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
//        [self dissmissProgress];
//        [self.tableView setUserInteractionEnabled:YES];
//        if (succeeded) {
//            PFObjectCell *cell = [self.tableView cellForRowAtIndexPath:articleObjectVM.indexPath];
//            [cell configWithObjectVM:articleObjectVM];
//        } else {
//            [KQParseErrorHandler handleParseError:error];
//        }
//    }];
//}
//
//- (void)tagArticle:(PFArticleObjectViewModel *)articleObjectVM {
//    NSArray *tags = articleObjectVM.articleObject.tags;
//    if (tags && tags.count > 0) {
//        [self showAlertViewWithTags:tags clickTagAction:^(NSString *tagString) {
//            KQQueryArticleViewModel *queryArticleVM = [[KQQueryArticleViewModel alloc] initQueryArticleWithTag:tagString];
//            KQQueryViewController *queryVC = [[KQQueryViewController alloc] initWithQueryVM:queryArticleVM];
//            queryVC.title =  [NSString stringWithFormat:@"标签：%@", tagString];
//            [self.navigationController pushViewController:queryVC animated:YES];
//        }];
//    }
//}
//
//- (void)shareArticle:(PFArticleObjectViewModel *)articleObjectVM {
//    NSString *shareText = articleObjectVM.articleObject.title;
//    NSURL *shareUrl = [NSURL URLWithString:articleObjectVM.articleObject.originalLink];
//    UIImage *shareImage = [UIImage imageNamed:@"Icon.png"];
//
//    [self shareWithText:shareText url:shareUrl image:shareImage CompletionWithItemsHandler:^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
//        if (completed) {
//            [articleObjectVM shareArticle:activityType];
//            PFObjectCell *cell = [self.tableView cellForRowAtIndexPath:articleObjectVM.indexPath];
//            [cell configWithObjectVM:articleObjectVM];
//        } else {
//            //
//        }
//    }];
//}
//
//- (void)reviewArticle:(PFArticleObjectViewModel *)articleObjectVM {
//    if ([self isLogin] && [[PFUser currentUser].username isEqualToString:@"酷奇"]){
//        // 开始审核
//        // 审核后需要做两件事
//        // 1. 修改审核状态，即通过还是拒绝
//        // 2. 添加一条活动记录，fromUser = 当前用户（即“酷奇”）, toUser = recommendedUser。用于发送推送消息。
//        // 3. 修改当前记录的状态。
//        PFObjectCell *cell = [self.tableView cellForRowAtIndexPath:articleObjectVM.indexPath];
//        [self showAlertViewWithReview:@"审核通过后将向所有用户开放，链请确认提问推荐的内容，链接符合规范！" passedBlock:^{
//            [articleObjectVM reviewArticle:KQArticleReviewStatusPassed];
//            [cell configWithObjectVM:articleObjectVM];
//        } rejectedBlock:^{
//            [articleObjectVM reviewArticle:KQArticleReviewStatusRejected];
//            [cell configWithObjectVM:articleObjectVM];
//        }];
//    }
//
//    NSString *title = @"";
//    NSString *subTitle = @"";
//
//    if (articleObjectVM.reviewStatus == KQQuestionReviewStatusRejected) {
//        title = @"审核拒绝";
//        subTitle = @"该文章审核拒绝，可能是链接不正确，或内容不符合规定。";
//    } else if (articleObjectVM.reviewStatus == KQQuestionReviewStatusPassed) {
//        title = @"审核通过";
//        subTitle = @"该文章审核通过，已经向所有用户开发。";
//    } else {
//        title = @"等待审核";
//        subTitle = @"该文章正在等待审核，仅作者自己可见。";
//    }
//
//    [self kq_alertInfoWithTitle:title subTitle:subTitle];
//}
//
//- (void)reportArticle:(PFArticleObjectViewModel *)articleObjectVM {
//    [self showAlertViewForReport:^(NSString *reason) {
//        [articleObjectVM reportArticle:reason];
//    }];
//}

@end
