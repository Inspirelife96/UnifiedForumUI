//
//  UIViewController+OpenLinkInSafari.m
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2021/6/30.
//

#import "UIViewController+OpenLinkInSafari.h"

#import <SafariServices/SafariServices.h>

#import "SCLAlertView+ShowOnMostTopViewController.h"

@implementation UIViewController (INS_OpenLinkInSafari)

- (void)ufui_openLinkInSafari:(NSString *)linkString {
    NSString* shareUrlString = [linkString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    if ([shareUrlString jk_isValidUrl]) {
        SFSafariViewControllerConfiguration *config = [[SFSafariViewControllerConfiguration alloc] init];
        config.entersReaderIfAvailable = YES;
        SFSafariViewController *sfVC = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:shareUrlString] configuration:config];
        [self presentViewController:sfVC animated:YES completion:nil];
    } else {
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        [alert ufui_showErrorOnMostTopViewControllerWithTitle:@"非法的URL地址" subTitle:@"请确认您的链接地址后重试！" closeButtonTitle:@"确认" duration:0.0f];
    }
}

@end
