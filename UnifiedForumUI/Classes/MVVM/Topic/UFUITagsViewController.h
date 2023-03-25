//
//  UFUITagsViewController.h
//  INSParseUI
//
//  Created by XueFeng Chen on 2021/7/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UFUITagsViewController : UIViewController

- (instancetype)initWithSelectedTagArray:(NSArray *)selectedTagArray;

@property (nonatomic, copy) void (^didFinishSelectingTagsHandle)(NSArray<NSString *> *selectedTags);

@end

NS_ASSUME_NONNULL_END
