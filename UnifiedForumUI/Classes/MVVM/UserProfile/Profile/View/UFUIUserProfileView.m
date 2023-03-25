//
//  UFUIUserProfileView.m
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2022/2/19.
//

#import "UFUIUserProfileView.h"

#import "UFUIUserProfileViewModel.h"

#import "UFMUserModel.h"

#import "UFUIBundle.h"

#import "UFUIConstants.h"

@implementation UFUIUserProfileView

#pragma mark UIView LifeCycle

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self buildUI];
    }

    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
    }

    return self;
}

- (void)buildUI {
    self.backgroundColor = [UIColor systemBackgroundColor];
    
    [self addSubview:self.backgroundImageView];
    [self addSubview:self.userInfoContainerView];

    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.userInfoContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(60.0f + 30.0f); //这部分高度是固定的
    }];

    [self addSubview:self.iconContainerView];
    [self.iconContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userInfoContainerView).with.offset(20.0f);
        make.top.equalTo(self.userInfoContainerView).with.offset(-30.0f);
        make.width.mas_equalTo(90.0f);
        make.height.mas_equalTo(90.0f);
    }];
    
    [self addSubview:self.usernameLabel];
    [self addSubview:self.bioLabel];
    [self addSubview:self.followButton];
    [self addSubview:self.editButton];
    [self addSubview:self.loginButton];

    [self.followButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.userInfoContainerView).with.offset(-20.0f);
        make.top.equalTo(self.userInfoContainerView).with.offset(10.0f);
        make.width.mas_equalTo(80.0f);
        make.height.mas_equalTo(20.0f);
    }];
    
    [self.editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.userInfoContainerView).with.offset(-20.0f);
        make.top.equalTo(self.userInfoContainerView).with.offset(10.0f);
        make.width.mas_equalTo(80.0f);
        make.height.mas_equalTo(20.0f);
    }];
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.userInfoContainerView).with.offset(-20.0f);
        make.top.equalTo(self.userInfoContainerView).with.offset(10.0f);
        make.width.mas_equalTo(80.0f);
        make.height.mas_equalTo(20.0f);
    }];

    [self.usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconContainerView.mas_right).with.offset(8.0f);
        make.right.equalTo(self.followButton.mas_left).with.offset(-8.0f);
        make.top.equalTo(self.userInfoContainerView).with.offset(10);
        make.height.mas_equalTo(20.0f);
    }];
    
    [self.bioLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconContainerView.mas_right).with.offset(8.0f);
        make.right.equalTo(self.followButton).with.offset(-8.0f);
        make.top.equalTo(self.usernameLabel.mas_bottom).with.offset(6.0f);
        make.height.mas_equalTo(20.0f);
    }];
    
    [self.iconContainerView addSubview:self.iconButton];
    [self.iconButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.iconContainerView);
        make.width.mas_equalTo(80.0f);
        make.height.mas_equalTo(80.0f);
    }];
    
    [self addSubview:self.followCountButton];
    [self addSubview:self.followedCountButton];
    [self addSubview:self.topicCountButton];
    [self addSubview:self.likedCountButton];
    
    [self addSubview:self.splitLine1View];
    [self addSubview:self.splitLine2View];
    [self addSubview:self.splitLine3View];

    [self.followCountButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.userInfoContainerView);
        make.width.mas_equalTo(self).multipliedBy(0.25);
        make.height.mas_equalTo(30.0f);
    }];
    
    [self.followedCountButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.userInfoContainerView);
        make.left.equalTo(self.followCountButton.mas_right);
        make.width.mas_equalTo(self).multipliedBy(0.25);
        make.height.mas_equalTo(30.0f);
    }];
    
    [self.topicCountButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.userInfoContainerView);
        make.left.equalTo(self.followedCountButton.mas_right);
        make.width.mas_equalTo(self).multipliedBy(0.25);
        make.height.mas_equalTo(30.0f);
    }];
    
    [self.likedCountButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.userInfoContainerView);
        make.left.equalTo(self.topicCountButton.mas_right);
        make.width.mas_equalTo(self).multipliedBy(0.25);
        make.height.mas_equalTo(30.0f);
    }];

    [self.splitLine1View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.userInfoContainerView).with.offset(-9.0f);
        make.left.equalTo(self.followCountButton.mas_right);
        make.width.mas_equalTo(1.0f);
        make.height.mas_equalTo(12.0f);
    }];

    [self.splitLine2View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.splitLine1View);
        make.left.equalTo(self.followedCountButton.mas_right);
        make.width.mas_equalTo(1.0f);
        make.height.mas_equalTo(12.0f);
    }];
    
    [self.splitLine3View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.splitLine1View);
        make.left.equalTo(self.topicCountButton.mas_right);
        make.width.mas_equalTo(1.0f);
        make.height.mas_equalTo(12.0f);
    }];
}

#pragma mark - Public Methods

- (void)configWithUserProfileViewModel:(UFUIUserProfileViewModel *)userProfileVM {
    _userProfileVM = userProfileVM;

    // 背景图
    if (self.userProfileVM.backgroundImageUrlString) {
        [self.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:userProfileVM.backgroundImageUrlString]];
    } else {
        self.backgroundImageView.image = [UFUIBundle imageNamed:@"user_profile_background_default"];
    }
    
    // 用户头像
    if (self.userProfileVM.profileImageUrlString) {
        [self.iconButton sd_setImageWithURL:[NSURL URLWithString:userProfileVM.profileImageUrlString] forState:UIControlStateNormal];
    } else {
        [self.iconButton setImage:[UFUIBundle imageNamed:@"user_profile_icon_default"] forState:UIControlStateNormal];
    }

    // 姓名
    self.usernameLabel.text = self.userProfileVM.userName;
    
    // 签名
    self.bioLabel.text = self.userProfileVM.bio;
    
    // 编辑按钮
    [self.editButton setHidden:!self.userProfileVM.isEditButtonEnabled];
    [self.editButton setTitle:self.userProfileVM.editButtonTitle forState:UIControlStateNormal];

    // 登录按钮
    [self.loginButton setHidden:!self.userProfileVM.isLoginButtonEnabled];
    [self.loginButton setTitle:self.userProfileVM.loginButtonTitle forState:UIControlStateNormal];

    // 关注按钮
    [self.followButton setHidden:!self.userProfileVM.isFollowButtonEnabled];
    [self.followButton setTitle:self.userProfileVM.followButtonTitle forState:UIControlStateNormal];

    // 统计信息
    [self.followCountButton setAttributedTitle:self.userProfileVM.followCountAttributedString forState:UIControlStateNormal];
    [self.followedCountButton setAttributedTitle:self.userProfileVM.followedCountAttributedString forState:UIControlStateNormal];
    [self.topicCountButton setAttributedTitle:self.userProfileVM.topicCountAttributedString forState:UIControlStateNormal];
    [self.likedCountButton setAttributedTitle:self.userProfileVM.likedCountAttributedString forState:UIControlStateNormal];
}

#pragma mark UI Actions

- (void)clickFollowButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(follow:)]) {
        [self.delegate follow:self.userProfileVM];
    }
}

- (void)clickEditButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(edit:)]) {
        [self.delegate edit:self.userProfileVM];
    }
}

- (void)clickLoginButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(login:)]) {
        [self.delegate login:self.userProfileVM];
    }
}

- (void)clickFollowCountButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(followInfo:)]) {
        [self.delegate followInfo:self.userProfileVM];
    }
}

- (void)clickFollowedCountButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(followedInfo:)]) {
        [self.delegate followedInfo:self.userProfileVM];
    }
}

- (void)clickTopicCountButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(topicInfo:)]) {
        [self.delegate topicInfo:self.userProfileVM];
    }
}

- (void)clickLikedCountButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(likedInfo:)]) {
        [self.delegate likedInfo:self.userProfileVM];
    }
}


#pragma mark UFUIPageHeaderViewProtocol

- (void(^)(CGFloat offsetY))pageHeaderViewScrollBlock {
    WEAKSELF
    return ^(CGFloat offsetY) {
        STRONGSELF
        if(offsetY >= 0){
            strongSelf.backgroundImageView.transform = CGAffineTransformIdentity;
        }else{
            CGFloat multi = ABS(offsetY*2)/CGRectGetHeight(strongSelf.backgroundImageView.frame);
            CGAffineTransform transform = CGAffineTransformMakeTranslation(0, offsetY*0.5);
            transform = CGAffineTransformScale(transform, 1+multi, 1+multi);
            strongSelf.backgroundImageView.transform = transform;
        }
    };
}

- (CGFloat)pageHeaderViewHeight {
    return 350;
}

#pragma makr Getter/Setter

- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        _backgroundImageView.clipsToBounds = YES;
    }

    return _backgroundImageView;
}

- (UIView *)userInfoContainerView {
    if (!_userInfoContainerView) {
        _userInfoContainerView = [[UIView alloc] initWithFrame:CGRectZero];
        _userInfoContainerView.backgroundColor = [UIColor secondarySystemBackgroundColor];
        _userInfoContainerView.layer.cornerRadius = 20.0f;
    }

    return _userInfoContainerView;
}

- (UIButton *)iconButton {
    if (!_iconButton) {
        _iconButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80.0f, 80.0f)];
        _iconButton.layer.cornerRadius = 40.0f;
        _iconButton.layer.masksToBounds = YES;
    }

    return _iconButton;
}

- (UIView *)iconContainerView {
    if (!_iconContainerView) {
        _iconContainerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 90.0f, 90.0f)];
        _iconContainerView.backgroundColor = [UIColor systemBackgroundColor];
        _iconContainerView.layer.cornerRadius = 45.0f;
        _iconContainerView.layer.masksToBounds = YES;
    }
    
    return _iconContainerView;
}

- (UILabel *)usernameLabel {
    if (!_usernameLabel) {
        _usernameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _usernameLabel.textAlignment = NSTextAlignmentLeft;
        _usernameLabel.textColor = [UIColor labelColor];
        _usernameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    }

    return _usernameLabel;
}

- (UILabel *)bioLabel {
    if (!_bioLabel) {
        _bioLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _bioLabel.textAlignment = NSTextAlignmentLeft;
        _bioLabel.textColor = [UIColor secondaryLabelColor];
        _bioLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    }

    return _bioLabel;
}

- (UIButton *)followButton {
    if (!_followButton) {
        _followButton = [[UIButton alloc] initWithFrame:CGRectZero];
        
        _followButton.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
        [_followButton setTitleColor:[UIColor linkColor] forState:UIControlStateNormal];
        
        _followButton.layer.cornerRadius = 10.0f;
        _followButton.layer.masksToBounds = YES;
        
        [_followButton addTarget:self action:@selector(clickFollowButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _followButton;
}

- (UIButton *)editButton {
    if (!_editButton) {
        _editButton = [[UIButton alloc] initWithFrame:CGRectZero];

        // 设置字体和颜色
        _editButton.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
        [_editButton setTitleColor:[UIColor linkColor] forState:UIControlStateNormal];
        
        // 设置边框和圆角
        _editButton.layer.cornerRadius = 10.0f;
        _editButton.layer.masksToBounds = YES;
        _editButton.layer.borderWidth = 0.5f;
        _editButton.layer.borderColor = [UIColor linkColor].CGColor;

        // 设置触发事件
        [_editButton addTarget:self action:@selector(clickEditButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _editButton;
}

- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [[UIButton alloc] initWithFrame:CGRectZero];
        _loginButton.layer.cornerRadius = 10.0f;
        _loginButton.layer.masksToBounds = YES;
        _loginButton.layer.borderWidth = 0.5f;
        
        [_loginButton addTarget:self action:@selector(clickLoginButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _loginButton;
}

- (UIButton *)followCountButton {
    if (!_followCountButton) {
        _followCountButton = [[UIButton alloc] init];
        _followCountButton.backgroundColor = [UIColor secondarySystemBackgroundColor];
        [_followCountButton addTarget:self action:@selector(clickFollowCountButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _followCountButton;
}

- (UIButton *)followedCountButton {
    if (!_followedCountButton) {
        _followedCountButton = [[UIButton alloc] init];
        _followedCountButton.backgroundColor = [UIColor secondarySystemBackgroundColor];
        [_followedCountButton addTarget:self action:@selector(clickFollowedCountButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _followedCountButton;
}

- (UIButton *)topicCountButton {
    if (!_topicCountButton) {
        _topicCountButton = [[UIButton alloc] init];
        _topicCountButton.backgroundColor = [UIColor secondarySystemBackgroundColor];
        [_topicCountButton addTarget:self action:@selector(clickTopicCountButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _topicCountButton;
}

- (UIButton *)likedCountButton {
    if (!_likedCountButton) {
        _likedCountButton = [[UIButton alloc] init];
        _likedCountButton.backgroundColor = [UIColor secondarySystemBackgroundColor];
        [_likedCountButton addTarget:self action:@selector(clickLikedCountButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _likedCountButton;
}

- (UIView *)splitLine1View {
    if (!_splitLine1View) {
        _splitLine1View = [[UIView alloc] init];
        _splitLine1View.backgroundColor = [UIColor separatorColor];
    }
    
    return _splitLine1View;
}

- (UIView *)splitLine2View {
    if (!_splitLine2View) {
        _splitLine2View = [[UIView alloc] init];
        _splitLine2View.backgroundColor = [UIColor separatorColor];

    }
    
    return _splitLine2View;
}

- (UIView *)splitLine3View {
    if (!_splitLine3View) {
        _splitLine3View = [[UIView alloc] init];
        _splitLine3View.backgroundColor = [UIColor separatorColor];
    }
    
    return _splitLine3View;
}

@end
