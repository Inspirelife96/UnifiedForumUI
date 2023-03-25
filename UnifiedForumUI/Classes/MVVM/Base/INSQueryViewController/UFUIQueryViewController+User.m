//
//  UFUIQueryViewController+User.m
//  INSParseUI
//
//  Created by XueFeng Chen on 2021/7/5.
//

#import "UFUIQueryViewController+User.h"

#import "UFUIUserProfileViewController.h"

@implementation UFUIQueryViewController (User)

- (void)browseUserProfile:(UFMUserModel *)userModel {
    UFUIUserProfileViewController *userProfileVC = [[UFUIUserProfileViewController alloc] initWithUserModel:userModel];
    [self.navigationController pushViewController:userProfileVC animated:YES];
}

@end
