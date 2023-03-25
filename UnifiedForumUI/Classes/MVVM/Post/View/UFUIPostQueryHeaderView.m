//
//  UFUIPostQueryHeaderView.m
//  INSParseUI
//
//  Created by XueFeng Chen on 2022/3/3.
//

#import "UFUIPostQueryHeaderView.h"
#import "UFUIPostQueryHeaderViewModel.h"
#import "UFUIImageFileCell.h"
#import "UFUIImageFileCellViewModel.h"
#import "UFUISplitLineView.h"

#import "UIImage+UFUIDefaultAvatar.h"

@interface UFUIPostQueryHeaderView ()

@end

@implementation UFUIPostQueryHeaderView

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

- (void)dealloc {
    @try {
        [self removeObserver:self.postQueryHeaderVM forKeyPath:@"postQueryHeaderVM.isFollowedByCurrentUser"];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}

- (void)buildUI {
    // 标题
    [self addSubview:self.titleLabel];

    // 发布者信息
    [self addSubview:self.avatarButton];
    [self addSubview:self.userNameButton];
    [self addSubview:self.timestampLabel];
    [self addSubview:self.followStatusButton];

    // 内容
    [self addSubview:self.contentLabel];
    
    // 多媒体文件内容
    [self addSubview:self.fileContentCollectionView];

    // 分割线
    [self addSubview:self.splitLineView];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(10.0f);
        make.right.equalTo(self).with.offset(-10.0f);
        make.top.equalTo(self).with.offset(16.0f);
    }];

    self.avatarButton.layer.cornerRadius = 18.0f;
    [self.avatarButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(10.0f);
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(16.0f);
        make.width.mas_equalTo(36.0f);
        make.height.mas_equalTo(36.0f);
    }];

    [self.followStatusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-10.0f);
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(24.0f);
        make.width.mas_equalTo(70.0f);
        make.height.mas_equalTo(20.0f);
    }];

    [self.userNameButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarButton.mas_right).with.offset(10.0f);
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(16.0f);
        make.right.lessThanOrEqualTo(self.followStatusButton.mas_left).with.offset(-10.0f);
        make.height.mas_equalTo(20.0f);
    }];

    [self.timestampLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarButton.mas_right).with.offset(10.0f);
        make.top.equalTo(self.userNameButton.mas_bottom);
        make.right.lessThanOrEqualTo(self.followStatusButton.mas_left).with.offset(-10.0f);
        make.height.mas_equalTo(18.0f);
    }];

    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(10.0f);
        make.right.equalTo(self).with.offset(-10.0f);
        make.top.equalTo(self.timestampLabel.mas_bottom).with.offset(10.0f);
    }];
    
    [self.fileContentCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLabel.mas_bottom).with.offset(10.0f);
        make.left.equalTo(self).with.offset(10.0f);
        make.bottom.equalTo(self.splitLineView.mas_top).with.offset(-10.0f);
    }];

    [self.splitLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(5);
    }];
}

- (void)configWithPostQueryHeaderViewModel:(UFUIPostQueryHeaderViewModel *)postQueryHeaderVM {
    self.postQueryHeaderVM = postQueryHeaderVM;
    
    self.titleLabel.text = self.postQueryHeaderVM.title;
    
    // 发布者头像
    if (self.postQueryHeaderVM.fromUserAvatarUrlString) {
        [self.avatarButton sd_setImageWithURL:[NSURL URLWithString:self.postQueryHeaderVM.fromUserAvatarUrlString] forState:UIControlStateNormal placeholderImage:[UIImage ufui_defaultAvatar]];
    } else {
        [self.avatarButton setImage:[UIImage ufui_defaultAvatar] forState:UIControlStateNormal];
    }
    
    // 发布者姓名
    [self.userNameButton setTitle:self.postQueryHeaderVM.fromUserName forState:UIControlStateNormal];
    
    // 发布时间
    self.timestampLabel.text = self.postQueryHeaderVM.postTimeInfo;
    
    // 关注状态
    [self.followStatusButton setHidden:self.postQueryHeaderVM.isFollowStatusButtonHidden];
    
    if (!self.postQueryHeaderVM.isFollowStatusButtonHidden) {
        self.followStatusButton.backgroundColor = self.postQueryHeaderVM.follwStatusButtonBackgroundColor;
        [self.followStatusButton setTitleColor:self.postQueryHeaderVM.followStatusButtonTitleColor forState:UIControlStateNormal];
        [self.followStatusButton setTitle:self.postQueryHeaderVM.followStatusButtonTitle forState:UIControlStateNormal];
    }
    
    // 内容
    self.contentLabel.text = self.postQueryHeaderVM.content;
    
    // 多媒体文件内容
    [self.fileContentCollectionView reloadData];
    [self.fileContentCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.postQueryHeaderVM.fileContentCollectionViewSize.width);
        make.height.mas_equalTo(self.postQueryHeaderVM.fileContentCollectionViewSize.height);
    }];
    
    [self addObserver:self forKeyPath:@"postQueryHeaderVM.isFollowedByCurrentUser" options:NSKeyValueObservingOptionNew context:nil];
}

#pragma makr KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"postQueryHeaderVM.isFollowedByCurrentUser"] ) {
        // 安全起见，我们可能会在子线程更新KVO监控的值，因此如果需要UI更新的话，务必在主线程中执行。
        dispatch_async(dispatch_get_main_queue(), ^{
            self.followStatusButton.backgroundColor = self.postQueryHeaderVM.follwStatusButtonBackgroundColor;
            [self.followStatusButton setTitleColor:self.postQueryHeaderVM.followStatusButtonTitleColor forState:UIControlStateNormal];
            [self.followStatusButton setTitle:self.postQueryHeaderVM.followStatusButtonTitle forState:UIControlStateNormal];
        });
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    UFUIImageFileCellViewModel *mediaContentVM = self.postQueryHeaderVM.fileCellVMArray[indexPath.row];
    return mediaContentVM.size;
}

#pragma mark UICollectionViewDelegate


#pragma mark UICollectionViewDataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UFUIImageFileCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UFUIImageFileCell class]) forIndexPath:indexPath];
    
    UFUIImageFileCellViewModel *mediaContentCellVM = self.postQueryHeaderVM.fileCellVMArray[indexPath.row];
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:mediaContentCellVM.urlString] placeholderImage:[UIImage systemImageNamed:@"person.crop.circle"]];

    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.postQueryHeaderVM.fileCellVMArray.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickFileCollectionViewIndexPath:inPostQueryHeaderView:)]) {
        [self.delegate clickFileCollectionViewIndexPath:indexPath inPostQueryHeaderView:self];
    }
}

#pragma mark Actions

- (void)clickAvatarButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickAvatarButtonInPostQueryHeaderView:)]) {
        [self.delegate clickAvatarButtonInPostQueryHeaderView:self];
    }
}

- (void)clickUserNameButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickUserNameButtonInPostQueryHeaderView:)]) {
        [self.delegate clickUserNameButtonInPostQueryHeaderView:self];
    }
}

- (void)clickfollowStatusButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickFollowStatusButtonInPostQueryHeaderView:)]) {
        [self.delegate clickFollowStatusButtonInPostQueryHeaderView:self];
    }
}

#pragma mark Getter/Setter

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        
        // 配置下默认的字体和颜色，可以在子类配置中修改
        _titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
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

- (UICollectionView *)fileContentCollectionView {
    if (!_fileContentCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumInteritemSpacing = 5.0;
        flowLayout.minimumLineSpacing = 5.0f;
        
        flowLayout.estimatedItemSize = CGSizeZero;
        
        _fileContentCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        
        [_fileContentCollectionView registerClass:[UFUIImageFileCell class] forCellWithReuseIdentifier:NSStringFromClass([UFUIImageFileCell class])];
        _fileContentCollectionView.delegate = self;
        _fileContentCollectionView.dataSource = self;
        _fileContentCollectionView.backgroundColor = [UIColor clearColor];
        
        // 不允许滚动
        _fileContentCollectionView.scrollEnabled = NO;
    }
    
    return _fileContentCollectionView;
}

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
        
        // 设置默认的字体和颜色
        _userNameButton.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
        [_userNameButton setTitleColor:[UIColor labelColor] forState:UIControlStateNormal];
        
        [_userNameButton addTarget:self action:@selector(clickUserNameButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _userNameButton;
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

- (UILabel *)timestampLabel {
    if (!_timestampLabel) {
        _timestampLabel = [[UILabel alloc] init];
        
        // 设置默认的字体和颜色
        _timestampLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption2];
        _timestampLabel.textColor = [UIColor secondaryLabelColor];
    }
    
    return _timestampLabel;
}

- (UFUISplitLineView *)splitLineView {
    if (!_splitLineView) {
        _splitLineView = [[UFUISplitLineView alloc] init];
    }
    
    return _splitLineView;
}

@end
