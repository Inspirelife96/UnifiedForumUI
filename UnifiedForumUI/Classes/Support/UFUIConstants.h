//
//  UnifiedForumUIConstants.h
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2021/6/24.
//

#import <Foundation/Foundation.h>

#import "UFUIBundle.h"

#define KUFUILocalization(key)  NSLocalizedStringFromTableInBundle(key, @"UnifiedForumUI", [UFUIBundle resourceBundle], nil)

#define WEAKSELF __weak __typeof(&*self)weakSelf = self;
#define STRONGSELF __strong __typeof(weakSelf)strongSelf = weakSelf;

//static inline void delay(NSTimeInterval delay, dispatch_block_t block) {
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
//}

extern NSString *const UFUIUserLoginNotification;
extern NSString *const UFUIUserLogoutNotification;
extern NSString *const UFUIUserSignUpNotification;

extern NSString *const UFUITopicAddedNotification;
extern NSString *const UFUIPostAddedNotification;
extern NSString *const UFUIReplyAddedNotification;

typedef void (^UFUIBooleanResultBlock)(BOOL succeeded, NSError *_Nullable error);

