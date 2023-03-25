//
//  UIViewController+SCAlertView.m
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2021/6/30.
//

#import "UIViewController+SCAlertView.h"

#import "SCLAlertView+ShowOnMostTopViewController.h"

#import "UFUIConstants.h"

@implementation UIViewController (SCAlertView)

- (void)ufui_alertErrorWithMessage:(NSString *)message {
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    NSString *title = KUFUILocalization(@"SCAlertView.title.default.error");
    NSString *closeButtonTitle = KUFUILocalization(@"SCAlertView.closeButton.title.default.ok");
    [alert ufui_showErrorOnMostTopViewControllerWithTitle:title subTitle:message closeButtonTitle:closeButtonTitle duration:0.0f];
}

- (void)ufui_alertInfoWithMessage:(NSString *)message {
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    NSString *title = KUFUILocalization(@"SCAlertView.title.default.info");
    NSString *closeButtonTitle = KUFUILocalization(@"SCAlertView.closeButton.title.default.ok");
    [alert ufui_showInfoOnMostTopViewControllerWithTitle:title subTitle:message closeButtonTitle:closeButtonTitle duration:0.0f];
}

@end
