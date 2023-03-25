//
//  UFUIPageViewController.h
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2021/12/9.
//

#import <UIKit/UIKit.h>

#import "UFUIPageView.h"
#import "UFUIPageMenuView.h"

NS_ASSUME_NONNULL_BEGIN

@interface UFUIPageViewController : UIViewController <UFUIPageViewDelegate, UFUIPageViewDataSource, UFUIPageMenuViewDelegate, UFUIPageMenuViewDataSource>

@end

NS_ASSUME_NONNULL_END
