//
//  UFUIPageHeaderView.h
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2023/3/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol UFUIPageHeaderViewProtocol <NSObject>

- (void(^)(CGFloat offsetY))pageHeaderViewScrollBlock;
- (CGFloat)pageHeaderViewHeight;

@end

@interface UFUIPageHeaderView : UIView <UFUIPageHeaderViewProtocol>

@end

NS_ASSUME_NONNULL_END
