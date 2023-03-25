//
//  UIViewController+SCAlertView.h
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2021/6/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (SCAlertView)

- (void)ufui_alertErrorWithMessage:(NSString *)message;

- (void)ufui_alertInfoWithMessage:(NSString *)message;

@end

NS_ASSUME_NONNULL_END
