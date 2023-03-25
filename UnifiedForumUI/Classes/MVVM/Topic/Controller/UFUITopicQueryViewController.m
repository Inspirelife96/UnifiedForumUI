//
//  UFUITopicQueryViewController.m
//  INSParseUI
//
//  Created by XueFeng Chen on 2022/4/6.
//

#import "UFUITopicQueryViewController.h"

#import "UFUIUserProfileViewController.h"
#import "UFUIAddTopicViewController.h"

#import "UFUITopicCell.h"
#import "UFUITopicCellViewModel.h"

#import "UFUIPostQueryViewController.h"
#import "UFUIPostQueryViewModel.h"

#import "UFUIUFMServiceErrorHandler.h"

#import "UIViewController+UFUIRoute.h"

#import "UFUITopicCell.h"
#import "UFUITopicCellViewModel.h"
#import "UFUIUFMServiceErrorHandler.h"

#import "UFUIAddTopicViewModel.h"

#import "UFUIAddPostViewController.h"
#import "UFUIPostQueryAddPostToTopicViewModel.h"

@interface UFUITopicQueryViewController () <UFUITopicCellDelegate>

@property (nonatomic, strong) UIBarButtonItem *newTopicBarButtonItem;

@end

@implementation UFUITopicQueryViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    self.navigationItem.rightBarButtonItem = self.newTopicBarButtonItem;

    // Do any additional setup after loading the view.
    
    
}

- (void)clickNewTopicButton:(UIButton *)sender {
    UFUIAddTopicViewModel *addTopicVM = [[UFUIAddTopicViewModel alloc] init];
    UFUIAddTopicViewController *addTopicVC = [[UFUIAddTopicViewController alloc] init];
    UINavigationController *addTopicNC = [[UINavigationController alloc] initWithRootViewController:addTopicVC];
    addTopicNC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:addTopicNC animated:YES completion:nil];
//    UFUITopicCellViewModel *topicCellVM = (UFUITopicCellViewModel *)self.queryVM.objectCellVMArray[0];
//
//
//
//    UFUIPostQueryAddPostToTopicViewModel *addPostVM = [[UFUIPostQueryAddPostToTopicViewModel alloc] initWithTopicModel:topicCellVM.topicModel];
//    UFUIAddPostViewController *addPostVC = [[UFUIAddPostViewController alloc] initWithAddPostViewModel:addPostVM];
//    UINavigationController *addPostNC = [[UINavigationController alloc] initWithRootViewController:addPostVC];
//    addPostNC.modalPresentationStyle = UIModalPresentationFullScreen;
//    [self presentViewController:addPostNC animated:YES completion:nil];
}

- (void)clickAvatarButtonInCell:(nonnull UFUITopicCell *)topicCell {
    [self ufui_routeToUserProfileViewController:topicCell.topicCellVM.topicModel.fromUserModel];
}

- (void)clickUserNameButtonInCell:(nonnull UFUITopicCell *)topicCell {
    [self ufui_routeToUserProfileViewController:topicCell.topicCellVM.topicModel.fromUserModel];
}

- (void)clickFileCollectionViewIndexPath:(nonnull NSIndexPath *)indexPath inCell:(nonnull UFUITopicCell *)topicCell {
    YBImageBrowser *browser = [YBImageBrowser new];
    browser.dataSourceArray = topicCell.topicCellVM.imageDataArray;
    browser.currentPage = indexPath.row;
    browser.defaultToolViewHandler.topView.operationType = YBIBTopViewOperationTypeSave;
    [browser showToView:[[UIApplication sharedApplication] windows][0]];
}

- (void)clickLikeButtonInCell:(nonnull UFUITopicCell *)topicCell {
    [self.view setUserInteractionEnabled:NO];
    [self.navigationController.navigationBar setUserInteractionEnabled:NO];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    WEAKSELF
    [topicCell.topicCellVM likeTopicInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        STRONGSELF
        [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
        [strongSelf.navigationController.navigationBar setUserInteractionEnabled:YES];
        [strongSelf.view setUserInteractionEnabled:YES];
        if (!succeeded) {
            [UFUIUFMServiceErrorHandler handleUFMServiceError:error];
        } else {
            [topicCell updateLikeButton];
        }
    }];
}

- (void)clickPostButtonInCell:(nonnull UFUITopicCell *)topicCell {
    UFUIPostQueryViewModel *postQueryVM = [[UFUIPostQueryViewModel alloc] initWithTopicModel:topicCell.topicCellVM.topicModel];
    UFUIPostQueryViewController *postQueryVC = [[UFUIPostQueryViewController alloc] initWithQueryVM:postQueryVM];
    postQueryVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:postQueryVC animated:YES];
}

- (void)clickShareButtonInCell:(nonnull UFUITopicCell *)topicCell {
    [self.view setUserInteractionEnabled:NO];
    [self.navigationController.navigationBar setUserInteractionEnabled:NO];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    WEAKSELF
    [topicCell.topicCellVM shareTopicToPlatformInBackgound:@"platform" withBlock:^(BOOL succeeded, NSError * _Nullable error) {
        STRONGSELF
        [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
        [strongSelf.navigationController.navigationBar setUserInteractionEnabled:YES];
        [strongSelf.view setUserInteractionEnabled:YES];
        if (!succeeded) {
            [UFUIUFMServiceErrorHandler handleUFMServiceError:error];
        } else {
            [topicCell updateShareButton];
        }
    }];
}

- (UIBarButtonItem *)newTopicBarButtonItem {
    if (!_newTopicBarButtonItem) {
        _newTopicBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"plus"] style:UIBarButtonItemStylePlain target:self action:@selector(clickNewTopicButton:)];
        _newTopicBarButtonItem.tintColor = [UIColor linkColor];
    }
    
    return _newTopicBarButtonItem;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//- (void)browseImageData:(nonnull NSArray<YBIBImageData *> *)imageDataArray currentPage:(NSInteger)currentPage {
//    YBImageBrowser *browser = [YBImageBrowser new];
//    browser.dataSourceArray = imageDataArray;
//    browser.currentPage = currentPage;
//    // 只有一个保存操作的时候，可以直接右上角显示保存按钮
//    browser.defaultToolViewHandler.topView.operationType = YBIBTopViewOperationTypeSave;
//    [browser showToView:[[UIApplication sharedApplication] windows][0]];
//}

//- (void)browseUserProfile:(INSUserViewModel *)userVM {
//    INSUserProfileViewController *userProfileVC = [[INSUserProfileViewController alloc] initWithUserViewModel:userVM];
//    [self.navigationController pushViewController:userProfileVC animated:YES];
//}
//
//- (void)commentTopic:(UFUITopicCellViewModel *)topicCellVM {
//    UFUIPostQueryViewModel *commentQueryVM = [[UFUIPostQueryViewModel alloc] initWithTopicModel:topicCellVM.topicModel];
//    UFUIPostQueryViewController *commentQyeryVC = [[UFUIPostQueryViewController alloc] initWithQueryVM:commentQueryVM topicModel:topicCellVM.topicModel];
//    commentQyeryVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:commentQyeryVC animated:YES];
//}
//
//- (void)likeTopic:(UFUITopicCellViewModel *)topicCellVM {
//    [self.view setUserInteractionEnabled:NO];
//    [self.navigationController.navigationBar setUserInteractionEnabled:NO];
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    
//    WEAKSELF
//    [topicCellVM likeTopicInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
//        STRONGSELF
//        [MBProgressHUD hideHUDForView:strongSelf.view animated:YES];
//        [strongSelf.navigationController.navigationBar setUserInteractionEnabled:YES];
//        [strongSelf.view setUserInteractionEnabled:YES];
//        if (!succeeded) {
//            [INSParseErrorHandler handleParseError:error];
//        } else {
//            UFUITopicCell *topicCell = [self.tableView cellForRowAtIndexPath:topicCellVM.indexPath];
//            [topicCell updateLikeButton];
//        }
//    }];
//}
//
//- (void)shareTopic:(UFUITopicCellViewModel *)topicCellVM {
//    NSString *shareText = topicCellVM.title;
//    NSURL *shareUrl = [NSURL URLWithString:articleObjectVM.articleObject.originalLink];
//    if
//    
//    
//    UIImage *shareImage = [UIImage imageNamed:@"Icon.png"];
//    
//    [self shareWithText:shareText url:shareUrl image:shareImage CompletionWithItemsHandler:^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
//        if (completed) {
//            [articleObjectVM shareArticleEventually:activityType];
//            PFObjectCell *cell = [self.tableView cellForRowAtIndexPath:articleObjectVM.indexPath];
//            [cell configWithObjectVM:articleObjectVM];
//        } else {
//            //
//        }
//    }];
//}

@end
