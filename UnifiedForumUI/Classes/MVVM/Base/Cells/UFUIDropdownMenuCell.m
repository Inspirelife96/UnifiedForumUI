//
//  UFUIDropdownMenuCell.m
//  INSParseUI
//
//  Created by XueFeng Chen on 2021/7/2.
//

#import "UFUIDropdownMenuCell.h"

@implementation UFUIDropdownMenuCell

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

- (void)buildUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.contentView.backgroundColor = [UIColor secondarySystemBackgroundColor];
        
    [self.contentView addSubview:self.dropdownMenu];
    [self.contentView addSubview:self.categoryLabel];
    [self.dropdownMenu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.right.equalTo(self.contentView).with.offset(-20);
        make.width.mas_equalTo(44.0f);
        make.height.mas_equalTo(44.0f);
    }];
    
    [self.categoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).with.offset(20);
        make.right.equalTo(self.contentView).with.offset(-20);
        make.height.mas_equalTo(44.0f);
    }];
}

- (MKDropdownMenu *)dropdownMenu {
    if (!_dropdownMenu) {
        _dropdownMenu = [[MKDropdownMenu alloc] init];
        _dropdownMenu.backgroundDimmingOpacity = -0.2;
        _dropdownMenu.dropdownShowsTopRowSeparator = NO;
        _dropdownMenu.dropdownBouncesScroll = NO;
        _dropdownMenu.rowSeparatorColor = [UIColor separatorColor];
        _dropdownMenu.rowTextAlignment = NSTextAlignmentCenter;
        _dropdownMenu.dropdownRoundedCorners = UIRectCornerAllCorners;
        _dropdownMenu.useFullScreenWidth = YES;
        _dropdownMenu.disclosureIndicatorImage = [UIImage systemImageNamed:@"chevron.down"];
        _dropdownMenu.spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 10)];
        _dropdownMenu.fullScreenInsetLeft = 10;
        _dropdownMenu.fullScreenInsetRight = 10;
    }
    
    return _dropdownMenu;
}

- (UILabel *)categoryLabel {
    if (!_categoryLabel) {
        _categoryLabel = [[UILabel alloc] init];
        _categoryLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _categoryLabel;
}

@end
