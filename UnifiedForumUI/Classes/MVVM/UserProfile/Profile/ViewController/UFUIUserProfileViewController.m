//
//  UFUIUserProfileViewController.m
//  Bolts
//
//  Created by XueFeng Chen on 2021/7/5.
//

#import "UFUIUserProfileViewController.h"

#import "UFUIUserProfileEditViewController.h"

#import "UFUIUserProfileView.h"

#import "UFUIUserProfileViewModel.h"

#import "UFMUserModel.h"

#import "UFUIUserProfileEditDetailViewController.h"

#import "UFUIUserProfileEditViewModel.h"

#import "UFUITopicQueryViewModel.h"
#import "UFUITopicQueryViewController.h"

#import <YHPageViewControllerFramework/YHPageViewControllerFramework-umbrella.h>

//#import "UFUITopicQueryViewModel.h"
//#import "INSActivityQueryViewModel.h"
//#import "INSQueryFollowUserViewModel.h"
//#import "INSQueryFollowedUserViewModel.h"
//#import "UFUIQueryViewController.h"
//#import "INSParseErrorHandler.h"

//#import "UIViewController+INSLogin.h"
//#import "UIViewController+INSLoginNotifications.h"

#import "UFUILogInViewController.h"

@interface UFUIUserProfileViewController () <UFUIUserProfileViewDelegate>

@property (nonatomic, strong) UFUIUserProfileView *userProfileView;

@end

@implementation UFUIUserProfileViewController

#pragma mark - UIViewController LifeCycle

- (instancetype)init {
    if (self = [super init]) {
        _userModel = [UFMService currentUserModel];
        _userProfileVM = [[UFUIUserProfileViewModel alloc] initWithUserModel:self.userModel];
    }
    
    return self;
}

- (instancetype)initWithUserModel:(UFMUserModel *)userModel {
    if (self = [super init]) {
        _userModel = userModel;
        _userProfileVM = [[UFUIUserProfileViewModel alloc] initWithUserModel:self.userModel];
    }
    
    return self;
}

- (instancetype)initWithUserProfileViewModel:(UFUIUserProfileViewModel *)userProfileVM {
    if (self = [super init]) {
        _userModel = userProfileVM.userModel;
        _userProfileVM = userProfileVM;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self ins_registerLoginNotifications];
    
    UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
    [appearance configureWithOpaqueBackground];
    appearance.backgroundColor = [UIColor clearColor];
    appearance.shadowColor = [UIColor clearColor];
    appearance.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor labelColor]};
    
    self.navigationItem.standardAppearance = appearance;
    self.navigationItem.scrollEdgeAppearance = appearance;
    
    UFUITopicQueryViewModel *topicQueryVM = [[UFUITopicQueryViewModel alloc] initQueryTopicWithCreatedByUserModel:self.userModel];

    UFUITopicQueryViewController *queryVC1 = [[UFUITopicQueryViewController alloc] initWithQueryVM:topicQueryVM];
    queryVC1.enableMJHeader = NO;
        
    UFUITopicQueryViewController *queryVC2 = [[UFUITopicQueryViewController alloc] initWithQueryVM:topicQueryVM];
    
    UFUITopicQueryViewController *queryVC3 = [[UFUITopicQueryViewController alloc] initWithQueryVM:topicQueryVM];
    
    UFUITopicQueryViewController *queryVC4 = [[UFUITopicQueryViewController alloc] initWithQueryVM:topicQueryVM];
    
    UFUITopicQueryViewController *queryVC5 = [[UFUITopicQueryViewController alloc] initWithQueryVM:topicQueryVM];
    
    self.pageViewController.segmentControl.backgroundColor = [UIColor secondarySystemBackgroundColor];
    
    
    [self.pageViewController yh_addChildController:queryVC1 title:@"动态"];
    [self.pageViewController yh_addChildController:queryVC2 title:@"创作"];
    [self.pageViewController yh_addChildController:queryVC3 title:@"获赞"];
    [self.pageViewController yh_addChildController:queryVC4 title:@"粉丝"];
    [self.pageViewController yh_addChildController:queryVC5 title:@"关注"];
    
    [self.pageViewController yh_reloadController];
}

- (void)dealloc {
//    [self ins_unregisterLoginNotifications];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self _updateUserProfileView];
}

- (void)viewWillDisappear:(BOOL)animated {

}

//- (void)loginStatusChanged {
//    [self updateFollowStatus];
//}

#pragma mark UFUIPageMenuViewDataSource

//- (NSInteger)numberOfMenusInPageMenuView:(UFUIPageMenuView *)tabView {
//    return 5;
//}
//
//- (NSString *)pageMenuView:(UFUIPageMenuView *)pageMenuView menuTitleAtIndex:(NSInteger)index {
//    return @[@"动态", @"创作", @"获赞", @"粉丝", @"关注"][index];
//}

#pragma mark UFUIPageViewDataSource

//- (CGFloat)heightForNavigationBarInPagerView:(UFUIPageView *)pagerView {
//    if (self.navigationController.navigationBar) {
//        return self.navigationController.navigationBar.frame.size.height;
//    } else {
//        return 0.0f;
//    }
//}
//
//- (CGFloat)heightForHeaderViewInPagerView:(UFUIPageView *)pagerView {
//    return floor([UIScreen jk_width] * 2.0f / 3.0f);
//}
//
//- (UIView *)headerViewInPagerView:(UFUIPageView *)pagerView {
//    return self.userProfileView;
//}
//
//// 必须和numberOfMenusInPageMenuView返回的一致
//- (NSInteger)numberOfPagesInPagerView:(UFUIPageView *)pagerView {
//    return 5;
//}
//
//- (UIViewController<UFUIPageContentViewControllerProtocol> *)pageView:(UFUIPageView *)pagerView initPageContentViewControllerAtIndex:(NSInteger)index {
//    if (index == 0) {
//        UFUITopicQueryViewModel *topicQueryVM = [[UFUITopicQueryViewModel alloc] initQueryTopicWithCreatedByUserModel:self.userModel];
//        UFUITopicQueryViewController *queryVC = [[UFUITopicQueryViewController alloc] initWithQueryVM:topicQueryVM];
//        return queryVC;
//    } else if (index == 1) {
////        UFUITopicQueryViewModel *topicQueryVM = [[UFUITopicQueryViewModel alloc] initQueryTopicWithFromUserModel:self.userModel];
////        UFUIQueryViewController *queryVC = [[UFUIQueryViewController alloc] initWithQueryVM:topicQueryVM];
////        return queryVC;
////        INSActivityQueryViewModel *activityQueryVM = [[INSActivityQueryViewModel alloc] initQueryActivityFromUser:self.user];
////        UFUIQueryViewController *queryVC = [[UFUIQueryViewController alloc] initWithQueryVM:activityQueryVM];
////        return queryVC;
//    }
//
//    UFUITopicQueryViewModel *topicQueryVM = [[UFUITopicQueryViewModel alloc] initQueryTopicWithCreatedByUserModel:self.userModel];
//    UFUITopicQueryViewController *queryVC = [[UFUITopicQueryViewController alloc] initWithQueryVM:topicQueryVM];
//    return queryVC;
//
//    //return [[UFUIPageContentViewController alloc] init];
//}

#pragma mark - UFUIUserProfileHeaderViewDelegate

- (void)follow:(UFUIUserProfileViewModel *)userProfileVM {
    
}

- (void)edit:(UFUIUserProfileViewModel *)userProfileVM {
    UFUIUserProfileEditViewController *userProfileEditVC = [[UFUIUserProfileEditViewController alloc] initWithUserModel:userProfileVM.userModel];
    [self.navigationController pushViewController:userProfileEditVC animated:YES];
}

- (void)login:(UFUIUserProfileViewModel *)userProfileVM {
    
}

- (void)followInfo:(UFUIUserProfileViewModel *)userProfileVM {
    
}

- (void)followedInfo:(UFUIUserProfileViewModel *)userProfileVM {
    
}

- (void)topicInfo:(UFUIUserProfileViewModel *)userProfileVM {
    
}

- (void)likedInfo:(UFUIUserProfileViewModel *)userProfileVM {
    
}


//- (void)follow {
//    if (![self ins_isLogin]) {
//        [self ins_login];
//    } else {
//        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        [self.view setUserInteractionEnabled:NO];
//
//        [self.userVM changeFollowedByCurrentUserStatus:^(BOOL succeeded, NSError * _Nullable error) {
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//            [self.view setUserInteractionEnabled:YES];
//            if (!succeeded) {
//                [INSParseErrorHandler handleParseError:error];
//            } else {
//                [self _updateUserProfileHeaderView];
//            }
//        }];
//    }
//}
//
//- (void)edit {
//    UFUIUserProfileEditViewController *userProfileEditVC = [[UFUIUserProfileEditViewController alloc] initWithUserViewModel:self.userVM];
//    [self.navigationController pushViewController:userProfileEditVC animated:YES];
//}
//
//
//- (void)login {
//    INSLoginViewConfig *loginViewConfig = [[INSLoginViewConfig alloc] init];
//    loginViewConfig.enableAnonymousLogin = YES;
//    loginViewConfig.logoImage = [INSParseUIBundle imageNamed:@"logo_default"];
//    loginViewConfig.userTermLink = @"https://www.baidu.com";
//
//    INSLogInViewController *loginVC = [[INSLogInViewController alloc] initWithLoginViewConfig:loginViewConfig];
//    loginVC.modalPresentationStyle = UIModalPresentationFullScreen;
//    [self presentViewController:loginVC animated:YES completion:nil];
//}

#pragma mark - UIBarButtonItem Actions

- (void)clickMessage:(id)sender {
    
}

- (void)clickMore:(id)sender {
    
}

#pragma mark - Private Methods

- (void)_updateUserProfileView {
    [self.userProfileView configWithUserProfileViewModel:self.userProfileVM];
}

- (void)_updateNavigationItems {
//    self.navigationItem.title = self.userVM.userName;
//    if (self.userVM && !self.userVM.isCurrentUser) {
//        UIBarButtonItem *messageButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"message"] style:UIBarButtonItemStylePlain target:self action:@selector(clickMessage:)];
//        UIBarButtonItem *moreButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"ellipsis"] style:UIBarButtonItemStylePlain target:self action:@selector(clickMore:)];
//
//        self.navigationItem.rightBarButtonItems =@[moreButtonItem, messageButtonItem];
//    }
}

#pragma mark - Getter/Setter

- (UIView<UFUIPageHeaderViewProtocol> *)pageHeaderView {
    return self.userProfileView;
}

- (UFUIUserProfileView *)userProfileView {
    if (!_userProfileView) {
        _userProfileView = [[UFUIUserProfileView alloc] init];
        [_userProfileView configWithUserProfileViewModel:self.userProfileVM];
        _userProfileView.delegate = self;
    }
    
    return _userProfileView;
}

@end
