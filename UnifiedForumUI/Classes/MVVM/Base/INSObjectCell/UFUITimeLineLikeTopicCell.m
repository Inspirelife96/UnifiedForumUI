//
//  UFUITimeLineLikeTopicCell.m
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2023/2/20.
//

#import "UFUITimeLineLikeTopicCell.h"

#import "UFUITimeLineLikeTopicCellViewModel.h"

#import "UIImage+UFUIDefaultAvatar.h"

@interface UFUITimeLineLikeTopicCell ()

@property (nonatomic, strong) UIView *topicPreviewContainerView;

@property (nonatomic, strong) UFUITimeLineLikeTopicCellViewModel *timeLikeTopicCellVM;

@end

@implementation UFUITimeLineLikeTopicCell

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
    // 1. 顶部的个人信息
    [self addSubview:self.avatarButton];
    [self addSubview:self.titleLabel];
    [self addSubview:self.timestampLabel];

    // 2. 文章的预览
    [self addSubview:self.topicPreviewContainerView];
    
    // 2.1. 预览的具体内容
    [self.topicPreviewContainerView addSubview:self.topicButton];
    [self.topicPreviewContainerView addSubview:self.topicTitleLabel];
    [self.topicPreviewContainerView addSubview:self.topicContentLabel];
    [self.topicPreviewContainerView addSubview:self.topicFromUserButton];
    [self.topicPreviewContainerView addSubview:self.topicPostInfoButton];
    [self.topicPreviewContainerView addSubview:self.topicLikeInfoButton];

    // 顶部的个人信息和交互 布局开始
    [self.avatarButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12.0f);
        make.top.equalTo(self).with.offset(14.0f);
        make.width.mas_equalTo(36.0f);
        make.height.mas_equalTo(36.0f);
    }];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarButton.mas_right).with.offset(8.0f);
        make.top.equalTo(self).with.offset(12.0f);
        make.width.mas_greaterThanOrEqualTo(10.0f);
        make.height.mas_equalTo(20.0f);
    }];

    [self.timestampLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(2.0f);
        make.width.mas_greaterThanOrEqualTo(10.0f);
        make.height.mas_equalTo(18.0f);
    }];
    
    [self.topicPreviewContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timestampLabel.mas_bottom).with.offset(14.0f);
        make.left.equalTo(self).with.offset(12.0f);
        make.right.equalTo(self).with.offset(-12.0f);
        make.bottom.equalTo(self).with.offset(-12.0f);
    }];
    
    [self.topicButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.topicPreviewContainerView);
    }];
    
    [self.topicTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topicPreviewContainerView).with.offset(20.0f);
        make.left.equalTo(self.topicPreviewContainerView).with.offset(12.0f);
        make.right.equalTo(self.topicPreviewContainerView).with.offset(-12.0f);
        make.height.mas_equalTo(36.0f);
    }];
    
    [self.topicContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topicTitleLabel).with.offset(20.0f);
        make.left.equalTo(self.topicPreviewContainerView).with.offset(12.0f);
        make.right.equalTo(self.topicPreviewContainerView).with.offset(-12.0f);
        make.height.mas_lessThanOrEqualTo(60.0f);
    }];
    
    [self.topicFromUserButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topicContentLabel.mas_bottom).with.offset(20.0f);
        make.left.equalTo(self.topicPreviewContainerView).with.offset(12.0f);
        make.height.mas_equalTo(20.0f);
        make.width.mas_greaterThanOrEqualTo(1.0f);
        make.bottom.equalTo(self.topicPreviewContainerView).with.offset(-20.0f);
    }];
    
    [self.topicPostInfoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.topicFromUserButton);
        make.height.mas_equalTo(20.0f);
        make.left.equalTo(self.topicFromUserButton.mas_right).with.offset(12.0f);
        make.width.mas_greaterThanOrEqualTo(1.0f);
    }];
    
    [self.topicLikeInfoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.topicFromUserButton);
        make.height.mas_equalTo(20.0f);
        make.left.equalTo(self.topicPostInfoButton.mas_right).with.offset(12.0f);
        make.width.mas_greaterThanOrEqualTo(1.0f);
    }];
}

- (void)configWithObjectCellViewModel:(UFUIObjectCellViewModel *)objectCellVM {
    [super configWithObjectCellViewModel:objectCellVM];
    
    NSAssert([objectCellVM isKindOfClass:[UFUITimeLineLikeTopicCellViewModel class]], @"Incorrect ObjectCellViewModel");
    
    self.timeLikeTopicCellVM = (UFUITimeLineLikeTopicCellViewModel *)objectCellVM;

    if (self.timeLikeTopicCellVM.fromUserAvatarUrlString && [self.timeLikeTopicCellVM.fromUserAvatarUrlString jk_isValidUrl]) {
        [self.avatarButton sd_setImageWithURL:[NSURL URLWithString:self.timeLikeTopicCellVM.fromUserAvatarUrlString] forState:UIControlStateNormal placeholderImage:[UIImage ufui_defaultAvatar]];
    } else {
        [self.avatarButton setImage:[UIImage ufui_defaultAvatar] forState:UIControlStateNormal];
    }

    // 发布者姓名
    self.titleLabel.text = self.timeLikeTopicCellVM.title;

    // 发布时间
    self.timestampLabel.text = self.timeLikeTopicCellVM.timeInfo;
    
    self.topicTitleLabel.text = self.timeLikeTopicCellVM.topicTitle;
    
    self.topicContentLabel.text = self.timeLikeTopicCellVM.topicContent;
    
    [self.topicFromUserButton setTitle:self.timeLikeTopicCellVM.topicFromUserName forState:UIControlStateNormal];


    [self.topicPostInfoButton setTitle:self.timeLikeTopicCellVM.topicPostInfo forState:UIControlStateNormal];
    [self.topicLikeInfoButton setTitle:self.timeLikeTopicCellVM.topicLikeInfo forState:UIControlStateNormal];
}

#pragma mark UI Actions

- (void)clickAvatarButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickAvatarButtonInCell:)]) {
        [self.delegate clickAvatarButtonInCell:self];
    }
}

- (void)clickTopicButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickTopicButtonInCell:)]) {
        [self.delegate clickTopicButtonInCell:self];
    }
}

- (void)clickTopicFromUserButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickTopicFromUserButtonInCell:)]) {
        [self.delegate clickTopicFromUserButtonInCell:self];
    }
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

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        
        // 设置默认的字体和颜色
        _titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle1];
        _titleLabel.textColor = [UIColor labelColor];
    }
    
    return _titleLabel;
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

- (UIView *)topicPreviewContainerView {
    if (!_topicPreviewContainerView) {
        _topicPreviewContainerView = [[UIView alloc] init];
        _topicPreviewContainerView.backgroundColor = [UIColor secondarySystemBackgroundColor];
        _topicPreviewContainerView.layer.borderColor = [UIColor separatorColor].CGColor;
        _topicPreviewContainerView.layer.borderWidth = 0.50f;
        _topicPreviewContainerView.layer.cornerRadius = 10.0f;
    }
    
    return _topicPreviewContainerView;
}

- (UIButton *)topicButton {
    if (!_topicButton) {
        _topicButton = [[UIButton alloc] init];
        [_topicButton addTarget:self action:@selector(clickTopicButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _topicButton;
}

- (UILabel *)topicTitleLabel {
    if (!_topicTitleLabel) {
        _topicTitleLabel = [[UILabel alloc] init];
        
        // 设置默认的字体和颜色
        _topicTitleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle1];
        _topicTitleLabel.textColor = [UIColor labelColor];
    }
    
    return _topicTitleLabel;
}

- (UILabel *)topicContentLabel {
    if (!_topicContentLabel) {
        _topicContentLabel = [[UILabel alloc] init];
        
        // 设置默认的字体和颜色
        _topicContentLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption2];
        _topicContentLabel.textColor = [UIColor secondaryLabelColor];
    }
    
    return _topicContentLabel;
}

- (UIButton *)topicFromUserButton {
    if (!_topicFromUserButton) {
        _topicFromUserButton = [[UIButton alloc] init];
        
        // 设置默认的字体，背景颜色和字体颜色根据关注的状态进行修正
        _topicFromUserButton.tintColor = [UIColor secondaryLabelColor];
        _topicFromUserButton.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
        [_topicFromUserButton setTitleColor:[UIColor secondaryLabelColor] forState:UIControlStateNormal];
        
        [_topicFromUserButton addTarget:self action:@selector(clickTopicFromUserButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _topicFromUserButton;
}

- (UIButton *)topicPostInfoButton {
    if (!_topicPostInfoButton) {
        _topicPostInfoButton = [[UIButton alloc] init];
        
        // 设置默认的字体，背景颜色和字体颜色根据关注的状态进行修正
        _topicPostInfoButton.tintColor = [UIColor secondaryLabelColor];
        _topicPostInfoButton.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
        [_topicPostInfoButton setTitleColor:[UIColor secondaryLabelColor] forState:UIControlStateNormal];
        
        [_topicPostInfoButton jk_setImagePosition:LXMImagePositionLeft spacing:8.0f];
        [_topicPostInfoButton setImage:[UIImage systemImageNamed:@"ellipsis"] forState:UIControlStateNormal];
    }
    
    return _topicPostInfoButton;
}

- (UIButton *)topicLikeInfoButton {
    if (!_topicLikeInfoButton) {
        _topicLikeInfoButton = [[UIButton alloc] init];
        
        // 设置默认的字体，背景颜色和字体颜色根据关注的状态进行修正
        _topicLikeInfoButton.tintColor = [UIColor secondaryLabelColor];
        _topicLikeInfoButton.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
        [_topicLikeInfoButton setTitleColor:[UIColor secondaryLabelColor] forState:UIControlStateNormal];
        
        [_topicLikeInfoButton jk_setImagePosition:LXMImagePositionLeft spacing:8.0f];
        [_topicLikeInfoButton setImage:[UIImage systemImageNamed:@"hand.thumbsup.fill"] forState:UIControlStateNormal];
    }
    
    return _topicLikeInfoButton;
}

@end
