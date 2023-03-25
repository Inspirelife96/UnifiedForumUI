//
//  UFUISwitchCell.h
//  INSParseUI
//
//  Created by XueFeng Chen on 2021/7/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class UFUISwitchCell;

@protocol UFUISwitchCellDelegate <NSObject>

@optional
- (void)switchCell:(UFUISwitchCell *)settingSwitchCell valueChanged:(UISwitch *)switchButton;

@end

@interface UFUISwitchCell : UITableViewCell

@property (nonatomic, weak) id<UFUISwitchCellDelegate> delegate;

- (void)updateCellWithSwitchStatus:(BOOL)switchStatus;

@end

NS_ASSUME_NONNULL_END
