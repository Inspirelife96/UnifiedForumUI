//
//  UFUISwitchCell.m
//  INSParseUI
//
//  Created by XueFeng Chen on 2021/7/2.
//

#import "UFUISwitchCell.h"

@interface  UFUISwitchCell()

@property (nonatomic, strong) UISwitch *switchButton;

@end

@implementation UFUISwitchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self buildUI];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        [self buildUI];
    }
    return self;
}

- (void)buildUI {
    self.backgroundColor = [UIColor secondarySystemBackgroundColor];
    self.contentView.backgroundColor = [UIColor secondarySystemBackgroundColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryView = self.switchButton;
    
    self.textLabel.textColor = [UIColor labelColor];
    self.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    
    self.detailTextLabel.textColor = [UIColor secondaryLabelColor];
    self.detailTextLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
}

- (void)updateCellWithSwitchStatus:(BOOL)switchStatus {
    [self.switchButton setOn:switchStatus];
}

- (void)switchButtonValueChanged:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(switchCell:valueChanged:)]){
        [self.delegate switchCell:self valueChanged:sender];
    }
}

#pragma mark Getter/Setter

- (UISwitch *)switchButton {
    if (!_switchButton) {
        _switchButton = [[UISwitch alloc] init];
        _switchButton.tintColor = [UIColor systemGreenColor];
        [_switchButton addTarget:self action:@selector(switchButtonValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    
    return _switchButton;
}

@end
