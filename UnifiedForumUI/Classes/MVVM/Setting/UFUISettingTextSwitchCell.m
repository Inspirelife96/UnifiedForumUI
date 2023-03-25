//
//  UFUISettingTextSwitchCell.m
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2021/10/29.
//

#import "UFUISettingTextSwitchCell.h"

@interface UFUISettingTextSwitchCell ()

@property (nonatomic, strong) UISwitch *switchButton;

@end

@implementation UFUISettingTextSwitchCell

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
    self.accessoryView = self.switchButton;
}

- (void)updateCellWithSwitchStatus:(BOOL)switchStatus {
    [self.switchButton setOn:switchStatus];
}

- (void)switchButtonValueChanged:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(switchButtonValueChanged:inSwitchCell:)]){
        [self.delegate switchButtonValueChanged:sender inSwitchCell:self];
    }
}

#pragma mark Getter/Setter

- (UISwitch *)switchButton {
    if (!_switchButton) {
        _switchButton = [[UISwitch alloc] init];
        [_switchButton addTarget:self action:@selector(switchButtonValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    
    return _switchButton;
}

@end
