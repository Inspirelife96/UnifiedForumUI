//
//  UFUIDiscoveryViewController.m
//  UnifiedForumUI_Example
//
//  Created by XueFeng Chen on 2023/3/6.
//  Copyright © 2023 inspirelife@hotmail.com. All rights reserved.
//

#import "UFUIDiscoveryViewController.h"

#import <UnifiedForumUI/UnifiedForumUI-umbrella.h>

#import <UnifiedForumModelParseImpl/UnifiedForumModelParseImpl-umbrella.h>

#import "UFUIProposedViewController.h"

@interface UFUIDiscoveryViewController ()

@end

@implementation UFUIDiscoveryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.segmentControl.config.layoutType = YHSegmentLayoutType_Center;
    self.segmentControl.backgroundColor = [UIColor systemBackgroundColor];
    self.title = @"PageViewController";
    
    UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
    [appearance configureWithOpaqueBackground];
    appearance.backgroundColor = [UIColor systemBackgroundColor];
    appearance.shadowColor = [UIColor systemBackgroundColor];
    appearance.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor labelColor]};
    
    self.navigationItem.standardAppearance = appearance;
    self.navigationItem.scrollEdgeAppearance = appearance;
    // 推荐
    UFUIProposedViewController *proposedVC = [[UFUIProposedViewController alloc] init];
    
    
    // 关注
    UFUITopicQueryViewModel *followedTopicQueryVM = [[UFUITopicQueryViewModel alloc] initQueryTopicWithFollowedByUser:[UFMService currentUserModel]];
    UFUITopicQueryViewController *followedTopicQueryVC = [[UFUITopicQueryViewController alloc] initWithQueryVM:followedTopicQueryVM];
//    UINavigationController *followedTopicQueryNC = [[UINavigationController alloc] initWithRootViewController:followedTopicQueryVC];
    
    self.segmentMenuShowOnNavigationBar = YES;
    
    [self yh_addChildController:proposedVC title:@"推荐"];
    [self yh_addChildController:followedTopicQueryVC title:@"关注"];
    
    [self yh_reloadController];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
