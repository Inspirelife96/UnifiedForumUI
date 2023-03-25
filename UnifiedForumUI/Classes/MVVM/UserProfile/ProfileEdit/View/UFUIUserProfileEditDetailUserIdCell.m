//
//  UFUIUserProfileEditDetailUserIdCell.m
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2021/10/25.
//

#import "UFUIUserProfileEditDetailUserIdCell.h"

#import "UFUIUserProfileEditViewModel.h"

#import "UFUIConstants.h"

@interface UFUIUserProfileEditDetailUserIdCell ()

@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UILabel *userIdLabel;

@end

@implementation UFUIUserProfileEditDetailUserIdCell

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
    self.backgroundColor = [UIColor systemBackgroundColor];
    
    [self.contentView addSubview:self.descriptionLabel];
    [self.contentView addSubview:self.userIdLabel];
    
    [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(12.0f);
        make.left.equalTo(self.contentView).with.offset(20.0f);
        make.bottom.equalTo(self.contentView).with.offset(-12.0f);
        make.height.mas_equalTo(21.0f);
        make.width.mas_equalTo(80.0f);
    }];
    
    [self.userIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(12.0f);
        make.left.equalTo(self.self.descriptionLabel.mas_right).with.offset(6.0f);;
        make.bottom.equalTo(self.contentView).with.offset(-12.0f);
        make.right.equalTo(self.contentView).with.offset(-20.0f);
        make.height.mas_equalTo(21.0f);
    }];
}

- (void)configWithUserProfileEditViewModel:(UFUIUserProfileEditViewModel *)userProfileEditVM {
    self.userIdLabel.text = userProfileEditVM.userId;
}

- (UILabel *)descriptionLabel {
    if (!_descriptionLabel) {
        _descriptionLabel = [[UILabel alloc] init];
        _descriptionLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
        _descriptionLabel.textColor = [UIColor secondaryLabelColor];
        _descriptionLabel.text = KUFUILocalization(@"userProfileEditDetailUserIdCell.descriptionLabel.title");
    }
    
    return _descriptionLabel;
}

- (UILabel *)userIdLabel {
    if (!_userIdLabel) {
        _userIdLabel = [[UILabel alloc] init];
        _userIdLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        _userIdLabel.textColor = [UIColor secondaryLabelColor];
    }
    
    return _userIdLabel;
}

@end
