//
//  UFUITopicCell.m
//  INSParseUI
//
//  Created by XueFeng Chen on 2022/2/15.
//

#import "UFUITopicCell.h"

#import "UFUIImageFileCell.h"

#import "UFUITopicCellViewModel.h"

#import "UFUIImageFileCellViewModel.h"

@implementation UFUITopicCell

#pragma mark LifeCyle

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
    
    [self.contentView addSubview:self.topicViewContainer];
    [self.topicViewContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(10.0f);
        make.left.equalTo(self.contentView).with.offset(10.0f);
        make.right.equalTo(self.contentView).with.offset(-10.0f);
        make.bottom.equalTo(self.contentView).with.offset(-10.0f);
    }];
    
    [self.topicViewContainer addSubview:self.avatarButton];
    [self.topicViewContainer addSubview:self.userNameButton];
    [self.topicViewContainer addSubview:self.timestampLabel];
    
    // 标题
    [self.topicViewContainer addSubview:self.titleLabel];

    // 内容
    [self.topicViewContainer addSubview:self.contentLabel];
    
    // 图片
    [self.topicViewContainer addSubview:self.fileCollectionView];
    
    // 底部的用户交互按钮
    [self.topicViewContainer addSubview:self.postButton];
    [self.topicViewContainer addSubview:self.likeButton];
    [self.topicViewContainer addSubview:self.shareButton];
    
    [self.avatarButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topicViewContainer).with.offset(10.0f);
        make.top.equalTo(self.topicViewContainer).with.offset(16.0f);
        make.width.mas_equalTo(36.0f);
        make.height.mas_equalTo(36.0f);
    }];

    [self.userNameButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarButton.mas_right).with.offset(10.0f);
        make.top.equalTo(self.topicViewContainer).with.offset(16.0f);
        make.right.equalTo(self.topicViewContainer).with.offset(-10.0f);
        make.height.mas_equalTo(20.0f);
    }];

    [self.timestampLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarButton.mas_right).with.offset(10.0f);
        make.top.equalTo(self.userNameButton.mas_bottom);
        make.right.equalTo(self.topicViewContainer).with.offset(-10.0f);
        make.height.mas_equalTo(18.0f);
    }];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timestampLabel.mas_bottom).with.offset(10.0f);
        make.left.equalTo(self.topicViewContainer).with.offset(10.0f);
        make.right.equalTo(self.topicViewContainer).with.offset(-10.0f);
    }];

    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.left.equalTo(self.topicViewContainer).with.offset(10.0f);
        make.right.equalTo(self.topicViewContainer).with.offset(-10.0f);
        make.height.mas_lessThanOrEqualTo(100.0f).priorityHigh();
    }];
    
    [self.fileCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLabel.mas_bottom).with.offset(10.0f);
        make.left.equalTo(self.topicViewContainer).with.offset(10.0f);
        make.bottom.equalTo(self.shareButton.mas_top).with.offset(-10.0f);
    }];
    
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topicViewContainer);
        make.height.mas_equalTo(30.0f);
        make.width.mas_equalTo(self).multipliedBy(1.0f/3.0f);
        make.bottom.equalTo(self.topicViewContainer).with.offset(-16.0f);
    }];

    [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.topicViewContainer);
        make.height.mas_equalTo(30.0f);
        make.width.mas_equalTo(self.topicViewContainer).multipliedBy(1.0f/3.0f);
        make.bottom.equalTo(self.topicViewContainer).with.offset(-16.0f);
    }];

    [self.postButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.shareButton.mas_right);
        make.right.equalTo(self.likeButton.mas_left);
        make.height.mas_equalTo(30.0f);
        make.bottom.equalTo(self.topicViewContainer).with.offset(-16.0f);
    }];
}

#pragma mark Public Methods

- (void)configWithObjectCellViewModel:(UFUIObjectCellViewModel *)objectCellVM {
    if ([objectCellVM isKindOfClass:[UFUITopicCellViewModel class]]) {
        self.topicCellVM = (UFUITopicCellViewModel *)objectCellVM;
        // 发布者头像
        UIImageSymbolConfiguration *symbolConfig = [UIImageSymbolConfiguration configurationWithPointSize:36];
        UIImage *placholderImage = [UIImage systemImageNamed:@"person.crop.circle" withConfiguration:symbolConfig];
        if (self.topicCellVM.fromUserAvatarUrlString) {
            [self.avatarButton sd_setImageWithURL:[NSURL URLWithString:self.topicCellVM.fromUserAvatarUrlString] forState:UIControlStateNormal placeholderImage:placholderImage];
        } else {
            [self.avatarButton setImage:placholderImage forState:UIControlStateNormal];
        }
        
        // 发布者姓名
        [self.userNameButton setTitle:self.topicCellVM.fromUserName forState:UIControlStateNormal];
        
        // 发布时间
        self.timestampLabel.text = self.topicCellVM.postTimeInfo;
        
        // 设置标题和内容
        self.titleLabel.text = self.topicCellVM.title;
        self.contentLabel.text = self.topicCellVM.content;
        
        // 分享，评论，赞的状态
        [self.postButton setTitle:self.topicCellVM.postButtonTitle forState:UIControlStateNormal];
        [self updateShareButton];
        [self updateLikeButton];
        
        // 重新加载图片并更新布局
        [self.fileCollectionView reloadData];
        [self.fileCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.topicCellVM.fileCollectionViewSize.width);
            make.height.mas_equalTo(self.topicCellVM.fileCollectionViewSize.height);
        }];
    }
}

- (void)updateLikeButton {
    [self.likeButton setTitle:self.topicCellVM.likeButtonTitle forState:UIControlStateNormal];
    [self.likeButton setTintColor:self.topicCellVM.likeButtonTintColor];
    [self.likeButton setTitleColor:self.topicCellVM.likeButtonTitleColor forState:UIControlStateNormal];
}

- (void)updateShareButton {
    [self.shareButton setTitle:self.topicCellVM.shareButtonTitle forState:UIControlStateNormal];
}

#pragma mark UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    UFUIImageFileCellViewModel *fileCellVM = self.topicCellVM.fileCellVMArray[indexPath.row];
    return fileCellVM.size;
}

#pragma mark UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickFileCollectionViewIndexPath:inCell:)]) {
        [self.delegate clickFileCollectionViewIndexPath:indexPath inCell:self];
    }
}

#pragma mark UICollectionViewDataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UFUIImageFileCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UFUIImageFileCell class]) forIndexPath:indexPath];
    UFUIImageFileCellViewModel *fileCellVM = self.topicCellVM.fileCellVMArray[indexPath.row];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:fileCellVM.urlString] placeholderImage:[UIImage systemImageNamed:@"person.crop.circle"]];

    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.topicCellVM.fileCellVMArray.count > 3) {
        return 3;
    } else {
        return self.topicCellVM.fileCellVMArray.count;
    }
}

#pragma mark Actions

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

- (void)clickPostButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickPostButtonInCell:)]) {
        [self.delegate clickPostButtonInCell:self];
    }
}

- (void)clickLikeButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickLikeButtonInCell:)]) {
        [self.delegate clickLikeButtonInCell:self];
    }
}

- (void)clickShareButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickShareButtonInCell:)]) {
        [self.delegate clickShareButtonInCell:self];
    }
}

#pragma mark Private Methods

- (UIButton *)_createButtonWithSystemImageName:(NSString *)systemImageName {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectZero];
    
    // tintColor可以对SystemImage的颜色进行配置
    button.tintColor = [UIColor labelColor];
    
    // 配置image
    [button setImage:[UIImage systemImageNamed:systemImageName] forState:UIControlStateNormal];
    
    // 默认推荐Caption1字体（12）secondaryLabelColor颜色
    button.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    [button setTitleColor:[UIColor secondaryLabelColor] forState:UIControlStateNormal];
    
    // 配置间距，有点间距比较好看
    [button jk_setImagePosition:LXMImagePositionLeft spacing:8.0f];
    
    return button;
}

#pragma mark Getter/Setter

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        
        // 配置下默认的字体和颜色，可以在子类配置中修改
        _titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        _titleLabel.textColor = [UIColor labelColor];
        
        // 允许多行
        _titleLabel.numberOfLines = 0;
    }
    
    return _titleLabel;
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

- (UICollectionView *)fileCollectionView {
    if (!_fileCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumInteritemSpacing = 5.0;
        flowLayout.minimumLineSpacing = 5.0f;
        
        flowLayout.estimatedItemSize = CGSizeZero;
        
        _fileCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        
        [_fileCollectionView registerClass:[UFUIImageFileCell class] forCellWithReuseIdentifier:NSStringFromClass([UFUIImageFileCell class])];
        _fileCollectionView.delegate = self;
        _fileCollectionView.dataSource = self;
        _fileCollectionView.backgroundColor = [UIColor clearColor];
        
        // 不允许滚动
        _fileCollectionView.scrollEnabled = NO;
    }
    
    return _fileCollectionView;
}

- (UIButton *)postButton {
    if (!_postButton) {
        _postButton = [self _createButtonWithSystemImageName:@"text.bubble"];
        [_postButton addTarget:self action:@selector(clickPostButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _postButton;
}

- (UIButton *)likeButton {
    if (!_likeButton) {
        _likeButton = [self _createButtonWithSystemImageName:@"hand.thumbsup"];
        [_likeButton addTarget:self action:@selector(clickLikeButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _likeButton;
}

- (UIButton *)shareButton {
    if (!_shareButton) {
        _shareButton = [self _createButtonWithSystemImageName:@"square.and.arrow.up"];
        [_shareButton addTarget:self action:@selector(clickShareButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _shareButton;
}

- (UIButton *)avatarButton {
    if (!_avatarButton) {
        // 默认是36/36的圆形图标
        _avatarButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 36.0f, 36.0f)];
        _avatarButton.layer.cornerRadius = 18.0f;
        _avatarButton.layer.masksToBounds = YES;
        
//        UIImageSymbolConfiguration *symbolConfig = [UIImageSymbolConfiguration configurationWithPointSize:36];
//        [_avatarButton setImage:[UIImage systemImageNamed:@"person.crop.circle" withConfiguration:symbolConfig] forState:UIControlStateNormal];
        
        [_avatarButton addTarget:self action:@selector(clickAvatarButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _avatarButton;
}

- (UIButton *)userNameButton {
    if (!_userNameButton) {
        _userNameButton = [[UIButton alloc] init];
        
        // 设置默认的字体和颜色
        _userNameButton.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
        _userNameButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
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

- (UIView *)topicViewContainer {
    if (!_topicViewContainer) {
        _topicViewContainer = [[UIView alloc] init];
        _topicViewContainer.backgroundColor = [UIColor systemBackgroundColor];
        _topicViewContainer.layer.cornerRadius = 20.0f;
    }
    
    return _topicViewContainer;
}

@end
