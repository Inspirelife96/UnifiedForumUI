//
//  UFUIAutoHeightTextView.h
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2021/7/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UFUIAutoHeightTextView : UITextView

@property (nonatomic, copy) NSString* placeholder;
@property (nonatomic, assign) NSInteger minNumberOfLines;
@property (nonatomic, assign) NSInteger maxNumberOfLines;

@property (nonatomic, copy) void(^textViewHeightChangeBlock)(CGFloat textViewHeight);

@end

NS_ASSUME_NONNULL_END
