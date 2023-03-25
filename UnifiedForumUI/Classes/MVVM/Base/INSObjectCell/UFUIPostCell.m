//
//  UFUIPostCell.m
//  INSParseUI
//
//  Created by XueFeng Chen on 2022/2/25.
//

#import "UFUIPostCell.h"

#import "UFUIImageFileCell.h"
#import "UFUISimpleReplyCell.h"
#import "UFUISplitLineView.h"
#import "UFUIPostCellViewModel.h"
#import "UFUIImageFileCellViewModel.h"
#import "UFUISimpleReplyCellViewModel.h"

#import "UIImage+UFUIDefaultAvatar.h"

@interface UFUIPostCell () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITableViewDataSource, UITableViewDelegate>

// 同objectCellVM，为了使用方便
@property (nonatomic, strong) UFUIPostCellViewModel *postCellVM;

@end

@implementation UFUIPostCell

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
    [self addSubview:self.likeButton];
    [self addSubview:self.moreButton];

    // 2. 评论的内容，由UILabel构成，高度自适应
    [self addSubview:self.contentLabel];
    
    // 3. 附带的图片，有UICollectionView构成
    [self addSubview:self.fileCollectionView];
    
    // 4. 针对评论的回复，由UITableView构成
    [self addSubview:self.replyTableView];
    
    // 5. 底部的分割线
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
        //make.right.equalTo(self.likeButton.mas_left).with.offset(-10.0f);
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
    }];
    // 附带的图片 布局结束

    // 评论的回复 布局开始
    [self.replyTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.fileCollectionView.mas_bottom).with.offset(10.0f);
        make.left.equalTo(self).with.offset(56.0f);
        make.bottom.equalTo(self).with.offset(-10.0f).priorityHigh();
    }];

    // 评论的回复 布局结束
    
    [self.splitLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(56.0f);
        make.right.equalTo(self.contentLabel.mas_right);
        make.height.mas_equalTo(0.50f);
        make.bottom.equalTo(self.mas_bottom);
    }];
}

- (void)configWithObjectCellViewModel:(UFUIObjectCellViewModel *)objectCellVM {
    [super configWithObjectCellViewModel:objectCellVM];
    
    NSAssert([objectCellVM isKindOfClass:[UFUIPostCellViewModel class]], @"Incorrect ObjectCellViewModel");
    
    self.postCellVM = (UFUIPostCellViewModel *)objectCellVM;
    
    if (self.postCellVM.fromUserAvatarUrlString && [self.postCellVM.fromUserAvatarUrlString jk_isValidUrl]) {
        [self.avatarButton sd_setImageWithURL:[NSURL URLWithString:self.postCellVM.fromUserAvatarUrlString] forState:UIControlStateNormal placeholderImage:[UIImage ufui_defaultAvatar]];
    } else {
        [self.avatarButton setImage:[UIImage ufui_defaultAvatar] forState:UIControlStateNormal];
    }
    
    // 发布者姓名
    [self.userNameButton setTitle:self.postCellVM.fromUserName forState:UIControlStateNormal];
    
    // 发布时间
    self.timestampLabel.text = self.postCellVM.postTimeInfo;
    
    // 赞的信息
    [self.likeButton setTitle:self.postCellVM.likeButtonTitle forState:UIControlStateNormal];
    
    // More Button不需要设置
    
    // 设置内容
    self.contentLabel.text = self.postCellVM.content;
    
    // 重新加载fileCollectionView并更新布局
    [self.fileCollectionView reloadData];
    [self.fileCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.postCellVM.fileCollectionViewSize.height);
        make.width.mas_equalTo(self.postCellVM.fileCollectionViewSize.width);
    }];

    // 重新加载replyTableView并更新布局
    [self.replyTableView reloadData];
    [self.replyTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.postCellVM.simpleReplyTableViewSize.height);
        make.width.mas_equalTo(self.postCellVM.simpleReplyTableViewSize.width);
    }];
    
    // 更新更多回复按钮
    if (self.postCellVM.moreReplyButtonTitle) {
        [self.moreReplyButton setTitle:self.postCellVM.moreReplyButtonTitle forState:UIControlStateNormal];
        self.replyTableView.tableFooterView = self.replyTableFooterView;
    } else {
        self.replyTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 5.0f)];
    }
}

#pragma mark UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    UFUIImageFileCellViewModel *fileCellVM = self.postCellVM.fileCellVMArray[indexPath.row];
    return fileCellVM.size;
}

#pragma mark UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickFileCollectionViewAtIndexPath:inCell:)]) {
        [self.delegate clickFileCollectionViewAtIndexPath:indexPath inCell:self];
    }
}

#pragma mark UICollectionViewDataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UFUIImageFileCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UFUIImageFileCell class]) forIndexPath:indexPath];
    
    UFUIImageFileCellViewModel *fileCellVM = self.postCellVM.fileCellVMArray[indexPath.row];
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:fileCellVM.fileModel.url] placeholderImage:[UIImage systemImageNamed:@"person.crop.circle"]];

    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.postCellVM.fileCellVMArray.count;
}

#pragma mark UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UFUISimpleReplyCellViewModel *simpleReplyCellVM = self.postCellVM.simpleReplyCellVMArray[indexPath.row];
    return simpleReplyCellVM.height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.postCellVM.simpleReplyCellVMArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UFUISimpleReplyCell *simpleReplyCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UFUISimpleReplyCell class]) forIndexPath:indexPath];
    
    UFUISimpleReplyCellViewModel *simpleReplyCellVM = self.postCellVM.simpleReplyCellVMArray[indexPath.row];
    
    [simpleReplyCell configWithSimpleReplyCellViewModel:simpleReplyCellVM];
    
    return simpleReplyCell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickReplyTableViewAtIndexPath:inCell:)]) {
        [self.delegate clickReplyTableViewAtIndexPath:indexPath inCell:self];
    }
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

- (void)clickMoreReplyButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickMoreReplyButtonInCell:)]) {
        [self.delegate clickMoreReplyButtonInCell:self];
    }
}

- (void)updateLikeButton {
    [self.likeButton setTitle:self.postCellVM.likeButtonTitle forState:UIControlStateNormal];
    [self.likeButton setTintColor:self.postCellVM.likeButtonTintColor];
    [self.likeButton setTitleColor:self.postCellVM.likeButtonTitleColor forState:UIControlStateNormal];
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

- (UITableView *)replyTableView {
    if (!_replyTableView) {
        _replyTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _replyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _replyTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 5.0f)];
        _replyTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 5.0f)];
        _replyTableView.estimatedRowHeight = 0;
        _replyTableView.dataSource = self;
        _replyTableView.delegate = self;
        _replyTableView.backgroundColor = [UIColor secondarySystemBackgroundColor];

        // 不允许滚动
        _replyTableView.scrollEnabled = NO;
        
        // 注册UFUISimpleReplyCell
        [_replyTableView registerClass:[UFUISimpleReplyCell class] forCellReuseIdentifier:NSStringFromClass([UFUISimpleReplyCell class])];
    }
    
    return _replyTableView;
}

- (UIView *)replyTableFooterView {
    if (!_replyTableFooterView) {
        _replyTableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen jk_width] - 56.0f - 14.0f, 45.0f)];
        [_replyTableFooterView addSubview:self.moreReplyButton];
        [self.moreReplyButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_replyTableFooterView).with.offset(12.0f);
            make.top.equalTo(_replyTableFooterView).with.offset(5.0f);
            make.bottom.equalTo(_replyTableFooterView).with.offset(-10.0f);
        }];
    }
    
    return _replyTableFooterView;
}

- (UIButton *)moreReplyButton {
    if (!_moreReplyButton) {
        _moreReplyButton = [[UIButton alloc] initWithFrame:CGRectZero];
        _moreReplyButton.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
        [_moreReplyButton setTitleColor:[UIColor linkColor] forState:UIControlStateNormal];
        [_moreReplyButton addTarget:self action:@selector(clickMoreReplyButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _moreReplyButton;
}

- (UFUISplitLineView *)splitLineView {
    if (!_splitLineView) {
        _splitLineView = [[UFUISplitLineView alloc] init];
    }
    
    return _splitLineView;
}

@end
