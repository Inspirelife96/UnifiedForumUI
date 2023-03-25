//
//  UFUIDropdownMenuCell.h
//  INSParseUI
//
//  Created by XueFeng Chen on 2021/7/2.
//

#import <UIKit/UIKit.h>

#import <MKDropdownMenu/MKDropdownMenu-umbrella.h>

NS_ASSUME_NONNULL_BEGIN

@interface UFUIDropdownMenuCell : UITableViewCell

@property (nonatomic, strong) MKDropdownMenu *dropdownMenu;
@property (nonatomic, strong) UILabel *categoryLabel;

@end

NS_ASSUME_NONNULL_END
