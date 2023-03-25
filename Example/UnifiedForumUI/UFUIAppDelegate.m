//
//  UFUIAppDelegate.m
//  UnifiedForumUI
//
//  Created by inspirelife@hotmail.com on 11/09/2022.
//  Copyright (c) 2022 inspirelife@hotmail.com. All rights reserved.
//

#import "UFUIAppDelegate.h"

#import <UnifiedForumUI/UnifiedForumUI-umbrella.h>
#import <UnifiedForumModelParseImpl/UnifiedForumModelParseImpl-umbrella.h>

#import "UFUIDiscoveryViewController.h"

@implementation UFUIAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    UINavigationBarAppearance *navigationBarAppearance = [[UINavigationBarAppearance alloc] init];
    [navigationBarAppearance configureWithDefaultBackground];
    [[UINavigationBar appearance] setStandardAppearance:navigationBarAppearance];
    [[UINavigationBar appearance] setScrollEdgeAppearance:navigationBarAppearance];
    [[UINavigationBar appearance] setCompactAppearance:navigationBarAppearance];
    if (@available(iOS 15.0, *)) {
        [[UINavigationBar appearance] setCompactScrollEdgeAppearance:navigationBarAppearance];
    }
    
    UITabBarAppearance *tabBarAppearance = [[UITabBarAppearance alloc] init];
    [tabBarAppearance configureWithDefaultBackground];
    [[UITabBar appearance] setStandardAppearance:tabBarAppearance];
    if (@available(iOS 15.0, *)) {
        [[UITabBar appearance] setScrollEdgeAppearance:tabBarAppearance];
    }
    
    // Override point for customization after application launch.
    
//    [ThemeManager setThemeWithPlistInMainBundle:@"lightTheme"];
    
//    UILabel *label = [[UILabel alloc] init];
//    label.textColor = [UIColor secondaryLabelColor];
//
//    [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    
    // 初始化Parse
    
    [UFMService initializeWithConfiguration:@{@"applicationId": @"APPLICATION_ID", @"clientKey":@"", @"server":@"https://inspirelife.test/parse"}];

    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UFUILogInViewModel *logInVM = [[UFUILogInViewModel alloc] init];
    
    UFUILogInViewController *loginVC = [[UFUILogInViewController alloc] initWithLogInViewModel:logInVM];
    loginVC.tabBarItem.image = [UIImage systemImageNamed:@"books.vertical.fill"];
    loginVC.tabBarItem.title = @"30天学习";
    
    UFUIUserProfileViewController *userProfileVC = [[UFUIUserProfileViewController alloc] initWithUserModel:[UFMService currentUserModel]];
    
    userProfileVC.tabBarItem.image = [UIImage systemImageNamed:@"books.vertical.fill"];
    userProfileVC.tabBarItem.title = @"我的";
    
    UINavigationController *userProfileNV = [[UINavigationController alloc] initWithRootViewController:userProfileVC];
    
    
    UFUITopicQueryViewModel *topicQueryVM = [[UFUITopicQueryViewModel alloc] initQueryTopicWithOrderBy:@"createdAt"];
    
    UFUITopicQueryViewController *topicQueryVC = [[UFUITopicQueryViewController alloc] initWithQueryVM:topicQueryVM];
    topicQueryVC.tabBarItem.image = [UIImage systemImageNamed:@"magnifyingglass"];
    topicQueryVC.tabBarItem.title = @"发现";
    UINavigationController *queryNV = [[UINavigationController alloc] initWithRootViewController:topicQueryVC];
    
    UFUIDiscoveryViewController *discoveryVC = [[UFUIDiscoveryViewController alloc] init];
    UINavigationController *discoveryNC = [[UINavigationController alloc] initWithRootViewController:discoveryVC];
    
    
    UITabBarController *tabbarVC = [[UITabBarController alloc] init];
    tabbarVC.viewControllers = @[discoveryNC, loginVC, userProfileNV, queryNV];
    
    
    UIFont *font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    NSLog(@"当前字体。。。%@",font);
    
    
    self.window.rootViewController = tabbarVC;

    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
