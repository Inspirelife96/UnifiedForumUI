//
//  UFUIAddPostViewController.h
//  INSParseUI
//
//  Created by XueFeng Chen on 2022/1/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class UFUIPostQueryAddPostToTopicViewModel;

@interface UFUIAddPostViewController : UIViewController

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithAddPostViewModel:(UFUIPostQueryAddPostToTopicViewModel *)addPostVM;

@end

NS_ASSUME_NONNULL_END
