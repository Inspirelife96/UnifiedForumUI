//
//  UFUITimeLineFollowCell.m
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2023/2/20.
//

#import "UFUITimeLineFollowCell.h"

#import "UFUISplitLineView.h"

#import "UFUITimeLineHeaderView.h"

#import "UFUITimeLineFollowCellViewModel.h"

#import "UIImage+UFUIDefaultAvatar.h"

@interface UFUITimeLineFollowCell ()

@property (nonatomic, strong) UIView *followedUserContainerView;
@property (nonatomic, strong) UFUISplitLineView *splitLineView;

@property (nonatomic, strong) UFUITimeLineFollowCellViewModel *timeLineFollowCellVM;

@end

@implementation UFUITimeLineFollowCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self buildUI];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self buildUI];
    }
    
    return self;
}

- (void)buildUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.contentView addSubview:self.timeLineHeaderView];
    [self.timeLineHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.contentView);
        make.height.mas_equalTo(64.0f);
    }];
    
    [self.contentView addSubview:self.followedUserContainerView];
    [self.followedUserContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLineHeaderView.mas_bottom);
        make.left.equalTo(self.contentView).with.offset(12.0f);
        make.right.equalTo(self.contentView).with.offset(-12.0f);
        make.bottom.equalTo(self.contentView).with.offset(-12.0f);
    }];
    
    [self.followedUserContainerView addSubview:self.followedUserButton];
    [self.followedUserButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.followedUserContainerView);
    }];
    
    [self.followedUserContainerView addSubview:self.followedUserAvatarImageView];
    [self.followedUserAvatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.followedUserContainerView).with.offset(12.0f);
        make.top.equalTo(self.followedUserContainerView).with.offset(14.0f);
        make.width.mas_equalTo(36.0f);
        make.height.mas_equalTo(36.0f);
    }];
    
    [self.followedUserContainerView addSubview:self.followedUserButton];
    [self.followedUserButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.followedUserContainerView).with.offset(16.0f);
        make.right.equalTo(self.followedUserContainerView).with.offset(-12.0f);
        make.height.mas_equalTo(32.0f);
        make.width.mas_greaterThanOrEqualTo(80.0f);
    }];
    
    [self.followedUserContainerView addSubview:self.followedUserNameLabel];
    [self.followedUserNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.followedUserAvatarImageView.mas_right).with.offset(8.0f);
        make.top.equalTo(self.followedUserContainerView).with.offset(12.0f);
        make.right.equalTo(self.followedUserButton.mas_left).with.offset(-8.0f);
        make.height.mas_equalTo(20.0f);
    }];
    
    [self.followedUserContainerView addSubview:self.followedUserInfoLabel];
    [self.followedUserInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.followedUserNameLabel);
        make.top.equalTo(self.followedUserNameLabel.mas_bottom).with.offset(2.0f);
        make.height.mas_equalTo(18.0f);
    }];
    
    [self.followedUserContainerView addSubview:self.splitLineView];
    [self.splitLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.followedUserContainerView).with.offset(12.0f);
        make.right.equalTo(self.followedUserContainerView).with.offset(-12.0f);
        make.top.equalTo(self.followedUserInfoLabel.mas_bottom).with.offset(12.0f);
        make.height.mas_equalTo(0.5f);
    }];
    
    [self.followedUserContainerView addSubview:self.followedUserBioLabel];
    [self.followedUserBioLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.followedUserContainerView).with.offset(12.0f);
        make.right.equalTo(self.followedUserContainerView).with.offset(-12.0f);
        make.top.equalTo(self.splitLineView.mas_bottom).with.offset(12.0f);
        make.bottom.equalTo(self.followedUserContainerView).with.offset(-12.0f);
        make.height.mas_equalTo(20.0f);
    }];
}

#pragma mark Public Methods

- (void)configWithObjectCellViewModel:(UFUIObjectCellViewModel *)objectCellVM {
    if ([objectCellVM isKindOfClass:[UFUITimeLineFollowCellViewModel class]]) {
        self.timeLineFollowCellVM = (UFUITimeLineFollowCellViewModel *)objectCellVM;
        
        // 更新顶部的动态
        [self.timeLineHeaderView configWithTimeLineHeaderViewModel:self.timeLineFollowCellVM.timeLineHeaderVM];
        
        // 更新关注者的内容
        [self.followedUserAvatarImageView sd_setImageWithURL:[NSURL URLWithString:self.timeLineFollowCellVM.avatarUrlString] placeholderImage:[UIImage ufui_defaultAvatar]];
        self.followedUserNameLabel.text = self.timeLineFollowCellVM.userName;
        self.followedUserInfoLabel.text = self.timeLineFollowCellVM.userInfo;
        self.followedUserBioLabel.text = self.timeLineFollowCellVM.userBio;
        [self.followStatusButton setTitle:self.timeLineFollowCellVM.followStatusButtonTitle forState:UIControlStateNormal];
    }
}

#pragma mark UI Actions

- (void)clickfollowStatusButton:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickFollowStatusButtonInCell:)]) {
        [self.delegate clickFollowStatusButtonInCell:self];
    }
}

- (void)clickFollowedUserButton:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickUserButtonInCell:)]) {
        [self.delegate clickUserButtonInCell:self];
    }
}

#pragma mark Getter/Setter

- (UIView *)followedUserContainerView {
    if (!_followedUserContainerView) {
        _followedUserContainerView = [[UIView alloc] init];
        _followedUserContainerView.backgroundColor = [UIColor secondarySystemBackgroundColor];
        _followedUserContainerView.layer.borderColor = [UIColor separatorColor].CGColor;
        _followedUserContainerView.layer.borderWidth = 0.5f;
        _followedUserContainerView.layer.cornerRadius = 5.0f;
    }
    
    return _followedUserContainerView;
}

- (UFUISplitLineView *)splitLineView {
    if (!_splitLineView) {
        _splitLineView = [[UFUISplitLineView alloc] init];
    }
    
    return _splitLineView;
}

- (UIImageView *)followedUserAvatarImageView {
    if (!_followedUserAvatarImageView) {
        _followedUserAvatarImageView = [[UIImageView alloc] init];
        _followedUserAvatarImageView.layer.cornerRadius = 18.0f;
        _followedUserAvatarImageView.layer.masksToBounds = YES;
    }
    
    return _followedUserAvatarImageView;
}

- (UILabel *)followedUserNameLabel {
    if (!_followedUserNameLabel) {
        _followedUserNameLabel = [[UILabel alloc] init];
        _followedUserNameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle1];
        _followedUserNameLabel.textColor = [UIColor labelColor];
    }
    
    return _followedUserNameLabel;
}

- (UILabel *)followedUserInfoLabel {
    if (!_followedUserInfoLabel) {
        _followedUserInfoLabel = [[UILabel alloc] init];
        
        // 设置默认的字体和颜色
        _followedUserInfoLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption2];
        _followedUserInfoLabel.textColor = [UIColor secondaryLabelColor];
    }
    
    return _followedUserInfoLabel;
}

- (UILabel *)followedUserBioLabel {
    if (!_followedUserBioLabel) {
        _followedUserBioLabel = [[UILabel alloc] init];
        _followedUserBioLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle1];
        _followedUserBioLabel.textColor = [UIColor labelColor];
    }
    
    return _followedUserBioLabel;
}

- (UIButton *)followStatusButton {
   if (!_followStatusButton) {
       _followStatusButton = [[UIButton alloc] init];
       
       // 设置默认的字体，背景颜色和字体颜色根据关注的状态进行修正
       _followStatusButton.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];

       // 注意圆角
       _followStatusButton.layer.cornerRadius = 10.0f;
       _followStatusButton.layer.masksToBounds = YES;
       
       [_followStatusButton addTarget:self action:@selector(clickfollowStatusButton:) forControlEvents:UIControlEventTouchUpInside];
   }
   
   return _followStatusButton;
}

- (UIButton *)followedUserButton {
    if (!_followedUserButton) {
        _followedUserButton = [[UIButton alloc] init];
        [_followedUserButton addTarget:self action:@selector(clickFollowedUserButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _followedUserButton;
}

@end
