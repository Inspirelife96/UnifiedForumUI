//
//  UFUITimeLineAddTopicCell.m
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2023/2/20.
//

#import "UFUITimeLineAddTopicCell.h"

#import "UFUITimeLineHeaderView.h"

#import "UFUITimeLineAddTopicCellViewModel.h"

#import "UIImage+UFUIDefaultAvatar.h"

@interface UFUITimeLineAddTopicCell ()

@property (nonatomic, strong) UFUITimeLineAddTopicCellViewModel *timeLineAddTopicCellVM;

@end

@implementation UFUITimeLineAddTopicCell

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
    [self addSubview:self.timeLineHeaderView];

    // 2. 文章的预览
    [self addSubview:self.topicButton];
    [self addSubview:self.topicTitleLabel];
    [self addSubview:self.topicMediaImageView];
    [self addSubview:self.topicContentLabel];
    [self addSubview:self.topicPostInfoButton];
    [self addSubview:self.topicLikeInfoButton];
    [self addSubview:self.topicShareInfoButton];

    // 顶部的个人信息和交互 布局开始
    [self.timeLineHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(64.0f);
    }];
    
    [self.topicTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLineHeaderView.mas_bottom);
        make.left.equalTo(self).with.offset(12.0f);
        make.right.equalTo(self).with.offset(-12.0f);
        make.height.mas_equalTo(36.0f);
    }];
    
    [self.topicMediaImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topicTitleLabel.mas_bottom).with.offset(20.0f);
        make.left.equalTo(self).with.offset(12.0f);
        make.height.mas_equalTo(60.0f);
        make.width.mas_equalTo(60.0f);
    }];
    
    [self.topicContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topicTitleLabel.mas_bottom).with.offset(20.0f);
        make.left.equalTo(self.topicMediaImageView.mas_right).with.offset(12.0f);
        make.right.equalTo(self).with.offset(-12.0f);
        make.height.mas_lessThanOrEqualTo(60.0f);
    }];
    
    [self.topicShareInfoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topicContentLabel.mas_bottom).with.offset(20.0f);
        make.bottom.equalTo(self).with.offset(-20.0f);
        make.right.equalTo(self).with.offset(-12.0f);
        make.height.mas_equalTo(20.0f);
        make.width.mas_greaterThanOrEqualTo(1.0f);
    }];
    
    [self.topicLikeInfoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.topicShareInfoButton);
        make.height.mas_equalTo(20.0f);
        make.right.equalTo(self.topicShareInfoButton.mas_left).with.offset(-12.0f);
        make.width.mas_greaterThanOrEqualTo(1.0f);
    }];
    
    [self.topicPostInfoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.topicShareInfoButton);
        make.height.mas_equalTo(20.0f);
        make.right.equalTo(self.topicLikeInfoButton.mas_left).with.offset(-12.0f);
        make.width.mas_greaterThanOrEqualTo(1.0f);
    }];
}

- (void)configWithObjectCellViewModel:(UFUIObjectCellViewModel *)objectCellVM {
    [super configWithObjectCellViewModel:objectCellVM];
    
//    NSAssert([objectCellVM isKindOfClass:[UFUITimeLineLikeTopicCellViewModel class]], @"Incorrect ObjectCellViewModel");
//
//    self.timeLikeTopicCellVM = (UFUITimeLineLikeTopicCellViewModel *)objectCellVM;
//
//    if (self.timeLikeTopicCellVM.fromUserAvatarUrlString && [self.timeLikeTopicCellVM.fromUserAvatarUrlString jk_isValidUrl]) {
//        [self.avatarButton sd_setImageWithURL:[NSURL URLWithString:self.timeLikeTopicCellVM.fromUserAvatarUrlString] forState:UIControlStateNormal placeholderImage:[UIImage ufui_defaultAvatar]];
//    } else {
//        [self.avatarButton setImage:[UIImage ufui_defaultAvatar] forState:UIControlStateNormal];
//    }
//
//    // 发布者姓名
//    self.titleLabel.text = self.timeLikeTopicCellVM.title;
//
//    // 发布时间
//    self.timestampLabel.text = self.timeLikeTopicCellVM.timeInfo;
//
//    self.topicTitleLabel.text = self.timeLikeTopicCellVM.topicTitle;
//
//    self.topicContentLabel.text = self.timeLikeTopicCellVM.topicContent;
//
//    [self.topicFromUserButton setTitle:self.timeLikeTopicCellVM.topicFromUserName forState:UIControlStateNormal];
//
//
//    [self.topicPostInfoButton setTitle:self.timeLikeTopicCellVM.topicPostInfo forState:UIControlStateNormal];
//    [self.topicLikeInfoButton setTitle:self.timeLikeTopicCellVM.topicLikeInfo forState:UIControlStateNormal];
}

#pragma mark UI Actions

//- (void)clickAvatarButton:(id)sender {
//    if (self.delegate && [self.delegate respondsToSelector:@selector(clickAvatarButtonInCell:)]) {
//        [self.delegate clickAvatarButtonInCell:self];
//    }
//}
//
//- (void)clickTopicButton:(id)sender {
//    if (self.delegate && [self.delegate respondsToSelector:@selector(clickTopicButtonInCell:)]) {
//        [self.delegate clickTopicButtonInCell:self];
//    }
//}
//
//- (void)clickTopicFromUserButton:(id)sender {
//    if (self.delegate && [self.delegate respondsToSelector:@selector(clickTopicFromUserButtonInCell:)]) {
//        [self.delegate clickTopicFromUserButtonInCell:self];
//    }
//}

#pragma mark Getter/Setter

- (UFUITimeLineHeaderView *)timeLineHeaderView {
    if (!_timeLineHeaderView) {
        _timeLineHeaderView = [[UFUITimeLineHeaderView alloc] init];
    }
    
    return _timeLineHeaderView;
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

- (UIImageView *)topicMediaImageView {
    if (_topicMediaImageView) {
        _topicMediaImageView = [[UIImageView alloc] init];
    }
    
    return _topicMediaImageView;
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

- (UIButton *)topicShareInfoButton {
    if (!_topicShareInfoButton) {
        _topicPostInfoButton = [[UIButton alloc] init];
        
        // 设置默认的字体，背景颜色和字体颜色根据关注的状态进行修正
        _topicPostInfoButton.tintColor = [UIColor secondaryLabelColor];
        _topicPostInfoButton.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
        [_topicPostInfoButton setTitleColor:[UIColor secondaryLabelColor] forState:UIControlStateNormal];
        
        [_topicPostInfoButton jk_setImagePosition:LXMImagePositionLeft spacing:8.0f];
        [_topicPostInfoButton setImage:[UIImage systemImageNamed:@"ellipsis"] forState:UIControlStateNormal];
    }
    
    return _topicShareInfoButton;
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
