//
//  UFUISettingLogoutCell.m
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2021/10/29.
//

#import "UFUISettingLogoutCell.h"

@implementation UFUISettingLogoutCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self buildUI];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self buildUI];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self buildUI];
    }
    
    return self;
}

- (void)buildUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryNone;

    self.textLabel.textColor = [UIColor systemRedColor];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
}

@end
