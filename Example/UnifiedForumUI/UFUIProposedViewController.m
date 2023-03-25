//
//  UFUIProposedViewController.m
//  UnifiedForumUI_Example
//
//  Created by XueFeng Chen on 2023/3/6.
//  Copyright © 2023 inspirelife@hotmail.com. All rights reserved.
//

#import "UFUIProposedViewController.h"

#import <UnifiedForumUI/UnifiedForumUI-umbrella.h>


@interface UFUIProposedViewController ()

@end

@implementation UFUIProposedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"PageViewController";
    [self.navigationController.navigationBar setTranslucent:NO];
    
    // 最新
    UFUITopicQueryViewModel *latestTopicQueryVM = [[UFUITopicQueryViewModel alloc] initQueryTopicWithOrderBy:@"createdAt"];
    UFUITopicQueryViewController *latestTopicQueryVC = [[UFUITopicQueryViewController alloc] initWithQueryVM:latestTopicQueryVM];
    
    // 热门
    UFUITopicQueryViewModel *hotestTopicQueryVM = [[UFUITopicQueryViewModel alloc] initQueryTopicWithOrderBy:@"postCount"];
    UFUITopicQueryViewController *hotestTopicQueryVC = [[UFUITopicQueryViewController alloc] initWithQueryVM:hotestTopicQueryVM];
    
    // 高赞
    UFUITopicQueryViewModel *mostLikeTopicQueryVM = [[UFUITopicQueryViewModel alloc] initQueryTopicWithOrderBy:@"likeCount"];
    UFUITopicQueryViewController *mostLikeTopicQueryVC = [[UFUITopicQueryViewController alloc] initWithQueryVM:mostLikeTopicQueryVM];
    
    // 课程学习
    UFUITopicQueryViewModel *studyTopicQueryVM = [[UFUITopicQueryViewModel alloc] initQueryTopicWithCategory:@"学习"];
    UFUITopicQueryViewController *studyTopicQueryVC = [[UFUITopicQueryViewController alloc] initWithQueryVM:studyTopicQueryVM];
    
    // 品画交流
    UFUITopicQueryViewModel *appreciateTopicQueryVM = [[UFUITopicQueryViewModel alloc] initQueryTopicWithCategory:@"品画交流"];
    UFUITopicQueryViewController *appreciateTopicQueryVC = [[UFUITopicQueryViewController alloc] initWithQueryVM:appreciateTopicQueryVM];
    
    
    [self yh_addChildController:latestTopicQueryVC title:@"最新"];
    [self yh_addChildController:hotestTopicQueryVC title:@"热门"];
    [self yh_addChildController:mostLikeTopicQueryVC title:@"高赞"];
    [self yh_addChildController:studyTopicQueryVC title:@"课程学习"];
    [self yh_addChildController:appreciateTopicQueryVC title:@"品画交流"];
    
    //self.canPanPopBackWhenAtFirstPage = YES;
//    self.frameForMenuView = CGRectMake(0, 0, CGRectGetHeight(self.view.frame), 60);
    
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
