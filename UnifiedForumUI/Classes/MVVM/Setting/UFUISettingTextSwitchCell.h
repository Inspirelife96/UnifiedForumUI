//
//  UFUISettingTextSwitchCell.h
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2021/10/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class UFUISettingTextSwitchCell;

@protocol UFUISettingTextSwitchCellDelegate <NSObject>

@optional
- (void)switchButtonValueChanged:(UISwitch *)switchButton inSwitchCell:(UFUISettingTextSwitchCell *)switchCell;

@end

@interface UFUISettingTextSwitchCell : UITableViewCell

@property (nonatomic, weak) id<UFUISettingTextSwitchCellDelegate> delegate;

- (void)updateCellWithSwitchStatus:(BOOL)switchStatus;

@end

NS_ASSUME_NONNULL_END
