//
//  UFUIReplyCell.m
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2023/2/19.
//

#import "UFUIReplyCell.h"

#import "UFUIReplyCellViewModel.h"
#import "UFUISplitLineView.h"

#import "UIImage+UFUIDefaultAvatar.h"

@interface UFUIReplyCell ()

// 同objectCellVM，为了使用方便
@property (nonatomic, strong) UFUIReplyCellViewModel *replyCellVM;

@end

@implementation UFUIReplyCell

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
    // 整个PostView大致分为四块内容
    
    // 1. 顶部的个人信息和交互
    [self addSubview:self.avatarButton];
    [self addSubview:self.userNameButton];
    [self addSubview:self.timestampLabel];

    // 2. 回复的内容，由UILabel构成，高度自适应
    [self addSubview:self.contentLabel];
    
    // 3. 回复下方的赞和更多按钮
    [self addSubview:self.likeButton];
    [self addSubview:self.moreButton];

    // 5. 底部的分割线
    [self addSubview:self.splitLineView];

    // 顶部的个人信息和交互 布局开始
    [self.avatarButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12.0f);
        make.top.equalTo(self).with.offset(14.0f);
        make.width.mas_equalTo(36.0f);
        make.height.mas_equalTo(36.0f);
    }];

    [self.userNameButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarButton.mas_right).with.offset(8.0f);
        make.top.equalTo(self).with.offset(12.0f);
        make.width.mas_greaterThanOrEqualTo(10.0f);
        make.height.mas_equalTo(20.0f);
    }];

    [self.timestampLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userNameButton);
        make.top.equalTo(self.userNameButton.mas_bottom).with.offset(2.0f);
        make.width.mas_greaterThanOrEqualTo(10.0f);
        make.height.mas_equalTo(18.0f);
    }];
    
    [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-14.0f);
        make.bottom.equalTo(self).with.offset(-14.0f);
        make.width.mas_equalTo(36.0f);
        make.height.mas_equalTo(36.0f);
    }];

    // 注意userNameButton的压缩拉升设置
    [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.moreButton.mas_left);
        make.bottom.equalTo(self.moreButton);
        make.width.mas_greaterThanOrEqualTo(36.0f);
        make.height.mas_equalTo(36.0f);
    }];

    // 顶部的个人信息和交互 布局结束

    // 回复内容 布局开始
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(56.0f);
        make.right.equalTo(self).with.offset(-14.0f);
        make.top.equalTo(self.timestampLabel.mas_bottom).with.offset(10.0f);
        make.bottom.equalTo(self).with.offset(-50.0f).priorityHigh();
    }];
    // 回复内容 布局结束
    
    [self.splitLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(56.0f);
        make.right.equalTo(self.contentLabel.mas_right);
        make.height.mas_equalTo(0.50f);
        make.bottom.equalTo(self.mas_bottom);
    }];
}

- (void)configWithObjectCellViewModel:(UFUIObjectCellViewModel *)objectCellVM {
    [super configWithObjectCellViewModel:objectCellVM];
    
    NSAssert([objectCellVM isKindOfClass:[UFUIReplyCellViewModel class]], @"Incorrect ObjectCellViewModel");
    
    self.replyCellVM = (UFUIReplyCellViewModel *)objectCellVM;
    
    if (self.replyCellVM.fromUserAvatarUrlString && [self.replyCellVM.fromUserAvatarUrlString jk_isValidUrl]) {
        [self.avatarButton sd_setImageWithURL:[NSURL URLWithString:self.replyCellVM.fromUserAvatarUrlString] forState:UIControlStateNormal placeholderImage:[UIImage ufui_defaultAvatar]];
    } else {
        [self.avatarButton setImage:[UIImage ufui_defaultAvatar] forState:UIControlStateNormal];
    }
    
    // 发布者姓名
    [self.userNameButton setTitle:self.replyCellVM.fromUserName forState:UIControlStateNormal];
    
    // 发布时间
    self.timestampLabel.text = self.replyCellVM.postTimeInfo;
    
    // 赞的信息
    [self.likeButton setTitle:self.replyCellVM.likeButtonTitle forState:UIControlStateNormal];
    
    // More Button不需要设置
    
    // 设置内容
    self.contentLabel.text = self.replyCellVM.content;
}

#pragma mark UI Actions

- (void)clickAvatarButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickAvatarButtonInCell:)]) {
        [self.delegate clickAvatarButtonInCell:self];
    }
}

- (void)clickUserNameButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickUserNameButtonInCell:)]) {
        [self.delegate clickUserNameButtonInCell:self];
    }
}

- (void)clickLikeButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickLikeButtonInCell:)]) {
        [self.delegate clickLikeButtonInCell:self];
    }
}

- (void)clickMoreButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickMoreButtonInCell:)]) {
        [self.delegate clickMoreButtonInCell:self];
    }
}

- (void)updateLikeButton {
    [self.likeButton setTitle:self.replyCellVM.likeButtonTitle forState:UIControlStateNormal];
    [self.likeButton setTintColor:self.replyCellVM.likeButtonTintColor];
    [self.likeButton setTitleColor:self.replyCellVM.likeButtonTitleColor forState:UIControlStateNormal];
}

#pragma mark Getter/Setter

- (UIButton *)avatarButton {
    if (!_avatarButton) {
        // 默认是30/30的圆形图标
        _avatarButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 30.0f, 30.0f)];
        _avatarButton.layer.cornerRadius = 15.0f;
        _avatarButton.layer.masksToBounds = YES;
        
        [_avatarButton setImage:[UIImage systemImageNamed:@"person.crop.circle"] forState:UIControlStateNormal];
        
        [_avatarButton addTarget:self action:@selector(clickAvatarButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _avatarButton;
}

- (UIButton *)userNameButton {
    if (!_userNameButton) {
        _userNameButton = [[UIButton alloc] init];
        _userNameButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        // 设置默认的字体和颜色
        _userNameButton.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
        [_userNameButton setTitleColor:[UIColor labelColor] forState:UIControlStateNormal];
        
        [_userNameButton addTarget:self action:@selector(clickUserNameButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _userNameButton;
}

- (UILabel *)timestampLabel {
    if (!_timestampLabel) {
        _timestampLabel = [[UILabel alloc] init];
        
        // 设置默认的字体和颜色
        _timestampLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption2];
        _timestampLabel.textColor = [UIColor secondaryLabelColor];
    }
    
    return _timestampLabel;
}

- (UIButton *)likeButton {
    if (!_likeButton) {
        _likeButton = [[UIButton alloc] init];
        
        // 设置默认的字体，背景颜色和字体颜色根据关注的状态进行修正
        _likeButton.tintColor = [UIColor secondaryLabelColor];
        _likeButton.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
        [_likeButton setTitleColor:[UIColor secondaryLabelColor] forState:UIControlStateNormal];
        
        [_likeButton jk_setImagePosition:LXMImagePositionLeft spacing:8.0f];
        [_likeButton setImage:[UIImage systemImageNamed:@"hand.thumbsup.fill"] forState:UIControlStateNormal];
        [_likeButton addTarget:self action:@selector(clickLikeButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _likeButton;
}

- (UIButton *)moreButton {
    if (!_moreButton) {
        _moreButton = [[UIButton alloc] init];
        
        // 设置默认的字体，背景颜色和字体颜色根据关注的状态进行修正
        _moreButton.tintColor = [UIColor secondaryLabelColor];
        _moreButton.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
        [_moreButton setImage:[UIImage systemImageNamed:@"ellipsis"] forState:UIControlStateNormal];
        [_moreButton addTarget:self action:@selector(clickMoreButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _moreButton;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        
        // 配置下默认的字体和颜色，可以在子类配置中修改
        _contentLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        _contentLabel.textColor = [UIColor labelColor];
        
        // 允许多行
        _contentLabel.numberOfLines = 0;
    }
    
    return _contentLabel;
}

- (UFUISplitLineView *)splitLineView {
    if (!_splitLineView) {
        _splitLineView = [[UFUISplitLineView alloc] init];
    }
    
    return _splitLineView;
}

@end
