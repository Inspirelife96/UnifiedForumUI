//
//  SCLAlertView+ShowOnMostTopViewController.h
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2021/6/27.
//

#import <SCLAlertView_Objective_C/SCLAlertView.h>

NS_ASSUME_NONNULL_BEGIN

@interface SCLAlertView (ShowOnMostTopViewController)

- (void)ufui_showSuccessOnMostTopViewControllerWithTitle:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration;

- (void)ufui_showErrorOnMostTopViewControllerWithTitle:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration;

- (void)ufui_showNoticeOnMostTopViewControllerWithTitle:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration;

- (void)ufui_showWarningOnMostTopViewControllerWithTitle:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration;

- (void)ufui_showInfoOnMostTopViewControllerWithTitle:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration;

- (void)ufui_showEditOnMostTopViewControllerWithTitle:(NSString *)title subTitle:(NSString *)subTitle closeButtonTitle:(NSString *)closeButtonTitle duration:(NSTimeInterval)duration;

@end

NS_ASSUME_NONNULL_END
