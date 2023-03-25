//
//  UFUIUserProfileEditHeaderView.m
//  UnifiedForumUI-INSParseUI
//
//  Created by XueFeng Chen on 2021/10/24.
//

#import "UFUIUserProfileEditHeaderView.h"

#import "UFUIBundle.h"

#import "UFUIConstants.h"

#import "UFUIUserProfileEditViewModel.h"

@interface UFUIUserProfileEditHeaderView ()

@property (nonatomic, strong) UIImageView *backgroundImageView; // 背景图片
@property (nonatomic, strong) UIView *userInfoContainerView; // 容器，为了布局方便
@property (nonatomic, strong) UIButton *changeBackgroundButton; // 背景选择按钮
@property (nonatomic, strong) UIImageView *iconContainerView; // 用户icon的容器
@property (nonatomic, strong) UIImageView *avatarImageView; // 用户的icon
@property (nonatomic, strong) UIButton *changeAvatarButton; // icon选择按钮

@property (nonatomic, strong) UFUIUserProfileEditViewModel *userProfileEditVM;

@end

@implementation UFUIUserProfileEditHeaderView

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
    [self addSubview:self.changeBackgroundButton];
    [self addSubview:self.iconContainerView];
    
    [self.userInfoContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.height.mas_equalTo(60.0f);
    }];
    
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.bottom.equalTo(self.userInfoContainerView.mas_top).with.offset(20.0f);
    }];
    
    [self.changeBackgroundButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.userInfoContainerView.mas_top).with.offset(-12.0f);
        make.right.equalTo(self.backgroundImageView).with.offset(-12.0f);
        make.width.mas_equalTo(80.0f);
        make.height.mas_equalTo(20.0f);
    }];
    
    [self.iconContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self);
        make.width.mas_equalTo(90.0f);
        make.height.mas_equalTo(90.0f);
    }];
    
    [self.iconContainerView addSubview:self.avatarImageView];
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.iconContainerView);
        make.height.width.mas_equalTo(80.0f);
    }];
    
    [self addSubview:self.changeAvatarButton];
    [self.changeAvatarButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(self.iconContainerView);
        make.height.width.mas_equalTo(30.0f);
    }];
}

#pragma mark - UI Actions

- (void)clickChangeProfileButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeAvatarImage)]) {
        [self.delegate changeAvatarImage];
    }
}

- (void)clickChangeBackgroundButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeBackgroundImage)]) {
        [self.delegate changeBackgroundImage];
    }
}

#pragma mark - Publick Methods

- (void)configWithUserProfileEditViewModel:(UFUIUserProfileEditViewModel *)userProfileEditVM {
    _userProfileEditVM = userProfileEditVM;
    
    if (userProfileEditVM.selectedAvatarImage) {
        self.avatarImageView.image = userProfileEditVM.selectedAvatarImage;
    } else {
        if (userProfileEditVM.avatarImageUrlString && [userProfileEditVM.avatarImageUrlString jk_isValidUrl]) {
            [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:userProfileEditVM.avatarImageUrlString]];
        } else {
            self.avatarImageView.image = [UFUIBundle imageNamed:@"user_profile_icon_default"];
        }
    }
    
    if (userProfileEditVM.selectedBackgroundImage) {
        self.backgroundImageView.image = userProfileEditVM.selectedBackgroundImage;
    } else {
        if (userProfileEditVM.backgroundImageUrlString && [userProfileEditVM.backgroundImageUrlString jk_isValidUrl]) {
            [self.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:userProfileEditVM.backgroundImageUrlString]];
        } else {
            self.backgroundImageView.image = [UFUIBundle imageNamed:@"user_profile_background_default"];
        }
    }
}

#pragma mark - Getter/Setter

- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        _backgroundImageView.clipsToBounds = YES;
    }
    
    return _backgroundImageView;
}

- (UIImageView *)iconContainerView {
    if (!_iconContainerView) {
        _iconContainerView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _iconContainerView.layer.cornerRadius = 45.0f;
        _iconContainerView.layer.masksToBounds = YES;
        _iconContainerView.backgroundColor = [UIColor systemBackgroundColor];
    }
    
    return _iconContainerView;
}

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
//        _avatarImageView.contentMode = UIViewContentModeScaleToFill;
//        _avatarImageView.clipsToBounds = YES;
        _avatarImageView.layer.cornerRadius = 40.0f;
        _avatarImageView.layer.masksToBounds = YES;
    }
    
    return _avatarImageView;
}

- (UIButton *)changeBackgroundButton {
    if (!_changeBackgroundButton) {
        _changeBackgroundButton = [[UIButton alloc] init];
        _changeBackgroundButton.layer.cornerRadius = 10.0f;
        _changeBackgroundButton.layer.masksToBounds = YES;
        
        _changeBackgroundButton.backgroundColor = [UIColor linkColor];
        _changeBackgroundButton.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
        [_changeBackgroundButton setTitleColor:[UIColor labelColor] forState:UIControlStateNormal];
        
        
        [_changeBackgroundButton setTitle:KUFUILocalization(@"userProfileEditHeaderView.changeBackgroundButton.title") forState:UIControlStateNormal];
        
        [_changeBackgroundButton addTarget:self action:@selector(clickChangeBackgroundButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _changeBackgroundButton;
}

- (UIButton *)changeAvatarButton {
    if (!_changeAvatarButton) {
        _changeAvatarButton = [[UIButton alloc] init];
        _changeAvatarButton.layer.cornerRadius = 15.0f;
        _changeAvatarButton.layer.masksToBounds = YES;
        
        _changeAvatarButton.backgroundColor = [UIColor systemBackgroundColor];
        
        UIImageSymbolConfiguration *symbolConfig = [UIImageSymbolConfiguration configurationWithPointSize:30.0f];
        UIImage *cameraImage = [UIImage systemImageNamed:@"camera.circle.fill" withConfiguration:symbolConfig];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:cameraImage];
        imageView.tintColor = [UIColor systemRedColor];
        [_changeAvatarButton setImage:cameraImage forState:UIControlStateNormal];
        [_changeAvatarButton addTarget:self action:@selector(clickChangeProfileButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _changeAvatarButton;
}

- (UIView *)userInfoContainerView {
    if (!_userInfoContainerView) {
        _userInfoContainerView = [[UIView alloc] init];
        _userInfoContainerView.backgroundColor = [UIColor systemBackgroundColor];
        _userInfoContainerView.layer.cornerRadius = 20.0f;
    }

    return _userInfoContainerView;
}

@end
