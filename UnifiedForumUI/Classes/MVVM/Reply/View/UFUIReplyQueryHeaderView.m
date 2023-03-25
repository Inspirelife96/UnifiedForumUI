//
//  UFUIReplyQueryHeaderView.m
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2023/2/18.
//

#import "UFUIReplyQueryHeaderView.h"

#import "UFUIImageFileCell.h"
#import "UFUISplitLineView.h"

#import "UFUIReplyQueryHeaderViewModel.h"
#import "UFUIImageFileCellViewModel.h"

#import "UIImage+UFUIDefaultAvatar.h"

@interface UFUIReplyQueryHeaderView () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@end

@implementation UFUIReplyQueryHeaderView

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
    // 整个ReplyQueryHeaderView是为了显示Post的内容
    // 基本和PostCell一致，但不显示回复预览部分
    
    // 1. 顶部的个人信息和交互
    [self addSubview:self.avatarButton];
    [self addSubview:self.userNameButton];
    [self addSubview:self.timestampLabel];
    [self addSubview:self.likeButton];
    [self addSubview:self.moreButton];

    // 2. 评论的内容，由UILabel构成，高度自适应
    [self addSubview:self.contentLabel];
    
    // 3. 附带的图片，有UICollectionView构成
    [self addSubview:self.fileCollectionView];
    
    // 4. 底部分割线
    [self addSubview:self.splitLineView];

    // 顶部的个人信息和交互 布局开始
    [self.avatarButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12.0f);
        make.top.equalTo(self).with.offset(14.0f);
        make.width.mas_equalTo(36.0f);
        make.height.mas_equalTo(36.0f);
    }];

    // userNameButton和likeButton相互依赖，他们的宽度由内容决定
    // 那么谁拉伸，谁压缩，需要由HuggingPriority/CompressionResistancePriority来控制
    // HuggingPriority默认是250，越大表示越不想被拉伸
    // CompressionResistancePriority默认是750，越大表示越不想被压缩
    // 在这里我们要保证likeButton是一个符合内容大小的长度，所以我们既不想被拉伸，也不想被压缩
    // 所以userNameButton更容易压缩和拉伸，因此把他的优先级调至低于默认值
    
    // 但同时，我们有希望保证userNameButton至少有200的宽度，不至于完全被压缩
    // 所以设置了width.mas_greaterThanOrEqualTo(200.0f)，因为其默认优先级是1000
    // 所以最终的结果就是，先保证userNameButton的宽度200以上，在对其优先进行拉伸和压缩
    [self.userNameButton setContentHuggingPriority:249 forAxis:UILayoutConstraintAxisHorizontal];
    [self.userNameButton setContentCompressionResistancePriority:749 forAxis:UILayoutConstraintAxisHorizontal];
    [self.userNameButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarButton.mas_right).with.offset(8.0f);
        make.top.equalTo(self).with.offset(12.0f);
        make.width.mas_greaterThanOrEqualTo(200.0f);
        make.height.mas_equalTo(20.0f);
    }];

    [self.timestampLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.userNameButton);
        make.top.equalTo(self.userNameButton.mas_bottom).with.offset(2.0f);
        make.height.mas_equalTo(18.0f);
    }];
    
    [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-14.0f);
        make.top.equalTo(self).with.offset(14.0f);
        make.width.mas_equalTo(36.0f);
        make.height.mas_equalTo(36.0f);
    }];

    // 注意userNameButton的压缩拉升设置
    [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.moreButton.mas_left);
        make.top.equalTo(self.moreButton);
        make.left.equalTo(self.userNameButton.mas_right).with.offset(10.0f);
        make.height.mas_equalTo(36.0f);
    }];

    // 顶部的个人信息和交互 布局结束

    // 评论内容 布局开始
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(56.0f);
        make.right.equalTo(self).with.offset(-14.0f);
        make.top.equalTo(self.timestampLabel.mas_bottom).with.offset(10.0f);
    }];
    // 评论内容 布局结束

    // 附带的图片 布局开始
    [self.fileCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLabel.mas_bottom).with.offset(10.0f);
        make.left.equalTo(self).with.offset(56.0f);
        make.bottom.equalTo(self).with.offset(-10.0f);
    }];
    // 附带的图片 布局结束
    
    // 最后设置下分割线
    [self.splitLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(5.0f);
    }];
}

- (void)configWithReplyQueryHeaderViewModel:(UFUIReplyQueryHeaderViewModel *)replyQueryHeaderVM {
    // 持有视图模型
    self.replyQueryHeaderVM = replyQueryHeaderVM;
    
    // 设置头像
    if (self.replyQueryHeaderVM.fromUserAvatarUrlString && [self.replyQueryHeaderVM.fromUserAvatarUrlString jk_isValidUrl]) {
        [self.avatarButton sd_setImageWithURL:[NSURL URLWithString:self.replyQueryHeaderVM.fromUserAvatarUrlString] forState:UIControlStateNormal placeholderImage:[UIImage ufui_defaultAvatar]];
    } else {
        [self.avatarButton setImage:[UIImage ufui_defaultAvatar] forState:UIControlStateNormal];
    }
    
    // 发布者姓名
    [self.userNameButton setTitle:self.replyQueryHeaderVM.fromUserName forState:UIControlStateNormal];
    
    // 发布时间
    self.timestampLabel.text = self.replyQueryHeaderVM.postTimeInfo;
    
    // 赞的信息
    [self.likeButton setTitle:self.replyQueryHeaderVM.likeButtonTitle forState:UIControlStateNormal];
    
    // More Button不需要设置
    
    // 设置内容
    self.contentLabel.text = self.replyQueryHeaderVM.content;
    
    // 重新加载fileCollectionView并更新布局
    [self.fileCollectionView reloadData];
    [self.fileCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.replyQueryHeaderVM.fileCollectionViewSize.height);
        make.width.mas_equalTo(self.replyQueryHeaderVM.fileCollectionViewSize.width);
    }];
}

#pragma mark UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    UFUIImageFileCellViewModel *fileCellVM = self.replyQueryHeaderVM.fileCellVMArray[indexPath.row];
    return fileCellVM.size;
}

#pragma mark UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // 点击Cell由代理处理
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickFileCollectionViewAtIndexPath:inHeaderView:)]) {
        [self.delegate clickFileCollectionViewAtIndexPath:indexPath inHeaderView:self];
    }
}

#pragma mark UICollectionViewDataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UFUIImageFileCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UFUIImageFileCell class]) forIndexPath:indexPath];
    
    UFUIImageFileCellViewModel *fileCellVM = self.replyQueryHeaderVM.fileCellVMArray[indexPath.row];
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:fileCellVM.fileModel.url] placeholderImage:[UIImage systemImageNamed:@"person.crop.circle"]];

    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.replyQueryHeaderVM.fileCellVMArray.count;
}

#pragma mark UI Actions

// 所有的互动都交由代理处理

- (void)clickAvatarButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickAvatarButtonInHeaderView:)]) {
        [self.delegate clickAvatarButtonInHeaderView:self];
    }
}

- (void)clickUserNameButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickUserNameButtonInHeaderView:)]) {
        [self.delegate clickUserNameButtonInHeaderView:self];
    }
}

- (void)clickLikeButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickLikeButtonInHeaderView:)]) {
        [self.delegate clickLikeButtonInHeaderView:self];
    }
}

- (void)clickMoreButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickMoreButtonInHeaderView:)]) {
        [self.delegate clickMoreButtonInHeaderView:self];
    }
}


- (void)updateLikeButton {
    [self.likeButton setTitle:self.replyQueryHeaderVM.likeButtonTitle forState:UIControlStateNormal];
    [self.likeButton setTintColor:self.replyQueryHeaderVM.likeButtonTintColor];
    [self.likeButton setTitleColor:self.replyQueryHeaderVM.likeButtonTitleColor forState:UIControlStateNormal];
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

- (UICollectionView *)fileCollectionView {
    if (!_fileCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumInteritemSpacing = 5.0;
        flowLayout.minimumLineSpacing = 10.0f;
        flowLayout.estimatedItemSize = CGSizeZero;
        
        _fileCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        
        // 注册UFUIImageFileCell
        [_fileCollectionView registerClass:[UFUIImageFileCell class] forCellWithReuseIdentifier:NSStringFromClass([UFUIImageFileCell class])];
        _fileCollectionView.delegate = self;
        _fileCollectionView.dataSource = self;
        
        _fileCollectionView.scrollEnabled = NO;
    }
    
    return _fileCollectionView;
}

- (UFUISplitLineView *)splitLineView {
    if (!_splitLineView) {
        _splitLineView = [[UFUISplitLineView alloc] init];
        _splitLineView.backgroundColor = [UIColor secondarySystemBackgroundColor];
    }
    
    return _splitLineView;
}

@end
