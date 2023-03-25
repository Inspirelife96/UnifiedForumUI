//
//  UFUIUserProfileEditDetailUserNameCell.m
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2021/10/25.
//

#import "UFUIUserProfileEditDetailUserNameCell.h"

#import "UFUIUserProfileEditViewModel.h"

#import "UFUIConstants.h"

#import "UFUIBundle.h"

@interface UFUIUserProfileEditDetailUserNameCell ()

@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UILabel *userNameLabel;

@end

@implementation UFUIUserProfileEditDetailUserNameCell

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
    self.backgroundColor = [UIColor systemBackgroundColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.contentView addSubview:self.descriptionLabel];
    [self.contentView addSubview:self.userNameLabel];
    
    [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(12.0f);
        make.left.equalTo(self.contentView).with.offset(20.0f);
        make.bottom.equalTo(self.contentView).with.offset(-12.0f);
        make.height.mas_equalTo(21.0f);
        make.width.mas_equalTo(80.0f);
    }];
    
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(12.0f);
        make.left.equalTo(self.self.descriptionLabel.mas_right).with.offset(6.0f);
        make.bottom.equalTo(self.contentView).with.offset(-12.0f);
        make.right.equalTo(self.contentView).with.offset(-20.0f);
        make.height.mas_equalTo(21.0f);
    }];
}

- (void)configWithUserProfileEditViewModel:(UFUIUserProfileEditViewModel *)userProfileEditVM {
    self.userNameLabel.text = userProfileEditVM.userName;
    
    if (userProfileEditVM.isAnonymousUser) {
        self.accessoryView = [[UIImageView alloc] initWithImage:[UFUIBundle imageNamed:@"upgrade_indicator"]];
    } else {
        self.accessoryView = nil;
    }
}

- (UILabel *)descriptionLabel {
    if (!_descriptionLabel) {
        _descriptionLabel = [[UILabel alloc] init];
        _descriptionLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
        _descriptionLabel.textColor = [UIColor secondaryLabelColor];
        _descriptionLabel.text = KUFUILocalization(@"userProfileEditDetailUserNameCell.descriptionLabel.title");
    }
    
    return _descriptionLabel;
}

- (UILabel *)userNameLabel {
    if (!_userNameLabel) {
        _userNameLabel = [[UILabel alloc] init];
        _userNameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        _userNameLabel.textColor = [UIColor secondaryLabelColor];
    }
    
    return _userNameLabel;
}

@end
