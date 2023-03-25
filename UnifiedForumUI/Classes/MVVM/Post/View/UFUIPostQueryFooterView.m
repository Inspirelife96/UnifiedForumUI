//
//  UFUIPostQueryFooterView.m
//  Bolts
//
//  Created by XueFeng Chen on 2022/1/18.
//

#import "UFUIPostQueryFooterView.h"

#import "UFUIPostQueryAddPostToTopicView.h"

#import "UFUISplitLineView.h"

#import "UFUIPostQueryFooterViewModel.h"

@interface UFUIPostQueryFooterView () <UITextFieldDelegate>

@end

@implementation UFUIPostQueryFooterView

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
        [self removeObserver:self forKeyPath:@"postQueryFooterVM.likeButtonTintColor"];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}

- (void)buildUI {
    [self addSubview:self.splitLineView];
    [self addSubview:self.editContainerView];
    [self.editContainerView addSubview:self.avatarImageView];
    [self.editContainerView addSubview:self.postTextField];
    
    [self addSubview:self.scrollToTopButton];
    [self addSubview:self.likeButton];
    [self addSubview:self.shareButton];
    
    [self.splitLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(0.5f);
    }];
    
    [self.scrollToTopButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).with.offset(-12.0f);
        make.height.mas_equalTo(30.0f);
        make.width.mas_equalTo(30.0f);
    }];
    
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.scrollToTopButton.mas_left).with.offset(-20.0f);
        make.height.mas_equalTo(30.0f);
        make.width.mas_equalTo(30.0f);
    }];
    
    [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.shareButton.mas_left).with.offset(-20.0f);
        make.height.mas_equalTo(30.0f);
        make.width.mas_equalTo(30.0f);
    }];
    
    [self.editContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).with.offset(12.0f);
        make.right.equalTo(self.likeButton.mas_left).with.offset(-20.0f);
        make.height.mas_equalTo(30.0f);
    }];
    
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.editContainerView).with.offset(3.0f);
        make.height.mas_equalTo(24.0f);
        make.width.mas_equalTo(24.0f);
    }];
    
    [self.postTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.avatarImageView.mas_right).with.offset(20.0f);
        make.right.equalTo(self.editContainerView).with.offset(-12.0f);
        make.height.mas_equalTo(24.0f);
    }];    
}

- (void)configWithPostQueryFooterViewModel:(UFUIPostQueryFooterViewModel *)postQueryFooterVM {
    self.postQueryFooterVM = postQueryFooterVM;
    [self.likeButton setTintColor:postQueryFooterVM.likeButtonTintColor];

    [self addObserver:self forKeyPath:@"postQueryFooterVM.likeButtonTintColor" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"postQueryFooterVM.likeButtonTintColor"] ) {
        // 安全起见，我们可能会在子线程更新KVO监控的值，因此如果需要UI更新的话，务必在主线程中执行。
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.likeButton setTintColor:self.postQueryFooterVM.likeButtonTintColor];
        });
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickPostTextFieldInPostQueryFooterView:)]) {
        [self.delegate clickPostTextFieldInPostQueryFooterView:self];
    }

    return NO;
}

//- (BOOL)textFieldShouldClear:(UITextField *)textField {
//    if (self.delegate && [self.delegate respondsToSelector:@selector(clearEdit:)]) {
//        [self.delegate clearEdit:self.postTextField];
//    }
//
//    return NO;
//}

#pragma mark - Actions

- (void)clickScrollToTopButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickScrollToTopButtonInPostQueryFooterView:)]) {
        [self.delegate clickScrollToTopButtonInPostQueryFooterView:self];
    }
}

- (void)clickLikeButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickLikeButtonInPostQueryFooterView:)]) {
        [self.delegate clickLikeButtonInPostQueryFooterView:self];
    }
}

- (void)clickShareButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickShareButtonInPostQueryFooterView:)]) {
        [self.delegate clickShareButtonInPostQueryFooterView:self];
    }
}

#pragma mark - Getter/Setter

- (UIView *)editContainerView {
    if (!_editContainerView) {
        _editContainerView = [[UIView alloc] init];
        _editContainerView.backgroundColor = [UIColor secondarySystemBackgroundColor];
        _editContainerView.layer.cornerRadius = 15.0f;
        _editContainerView.layer.masksToBounds = YES;
    }
    
    return _editContainerView;
}

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.layer.cornerRadius = 12.0f;
        _avatarImageView.layer.masksToBounds = YES;
        if ([UFMService currentUserModel]) {
            UFMUserModel *userModel = [UFMService currentUserModel];
            NSURL *url = [NSURL URLWithString:userModel.avatarImageModel.url];
            [_avatarImageView sd_setImageWithURL:url placeholderImage:[UIImage systemImageNamed:@"person.crop.circle"]];
        }
    }
    
    return _avatarImageView;
}

- (UITextField *)postTextField {
    if (!_postTextField) {
        _postTextField = [[UITextField alloc] initWithFrame:CGRectZero];
        _postTextField.delegate = self;
    }
    
    return _postTextField;
}

- (UIButton *)scrollToTopButton {
    if (!_scrollToTopButton) {
        _scrollToTopButton = [[UIButton alloc] init];
        UIImageSymbolConfiguration *symbolConfig = [UIImageSymbolConfiguration configurationWithPointSize:18.0f];
        [_scrollToTopButton setImage:[UIImage systemImageNamed:@"platter.filled.top.applewatch.case" withConfiguration:symbolConfig] forState:UIControlStateNormal];
        [_scrollToTopButton addTarget:self action:@selector(clickScrollToTopButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _scrollToTopButton;
}

- (UIButton *)likeButton {
    if (!_likeButton) {
        _likeButton = [[UIButton alloc] init];
        UIImageSymbolConfiguration *symbolConfig = [UIImageSymbolConfiguration configurationWithPointSize:18.0f];
        [_likeButton setImage:[UIImage systemImageNamed:@"hand.thumbsup" withConfiguration:symbolConfig] forState:UIControlStateNormal];
        [_likeButton addTarget:self action:@selector(clickLikeButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _likeButton;
}

- (UIButton *)shareButton {
    if (!_shareButton) {
        _shareButton = [[UIButton alloc] init];
        UIImageSymbolConfiguration *symbolConfig = [UIImageSymbolConfiguration configurationWithPointSize:18.0f];
        [_shareButton setImage:[UIImage systemImageNamed:@"square.and.arrow.up" withConfiguration:symbolConfig] forState:UIControlStateNormal];
        [_shareButton addTarget:self action:@selector(clickShareButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _shareButton;
}

- (UFUISplitLineView *)splitLineView {
    if (!_splitLineView) {
        _splitLineView = [[UFUISplitLineView alloc] init];
    }
    
    return _splitLineView;
}

@end
