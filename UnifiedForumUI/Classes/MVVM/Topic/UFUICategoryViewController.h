//
//  UFUICategoryViewController.h
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2023/3/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^FinishSelectingCategoryHandle)(NSString *selectedCategory);

@interface UFUICategoryViewController : UIViewController

- (instancetype)initWithSelectedCategory:(NSString *)selectedCategory didFinishSelectingCategoryHandle:(FinishSelectingCategoryHandle)handle;

@end

NS_ASSUME_NONNULL_END
