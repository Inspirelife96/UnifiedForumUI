//
//  UFUIEmptyDataSetView.h
//  INSParseUI
//
//  Created by XueFeng Chen on 2021/12/24.
//

#import <UIKit/UIKit.h>

@class CompatibleAnimationView;

NS_ASSUME_NONNULL_BEGIN

@interface UFUIEmptyDataSetView : UIView

@property (nonatomic, strong) CompatibleAnimationView *animationView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

NS_ASSUME_NONNULL_END
