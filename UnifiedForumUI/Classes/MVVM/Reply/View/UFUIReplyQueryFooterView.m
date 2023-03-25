//
//  UFUIReplyQueryFooterView.m
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2023/2/19.
//

#import "UFUIReplyQueryFooterView.h"

#import "UFUISplitLineView.h"

@implementation UFUIReplyQueryFooterView

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
    [self addSubview:self.splitLineView];
    [self addSubview:self.editContainerView];
    [self.editContainerView addSubview:self.avatarImageView];
    [self.editContainerView addSubview:self.replyTextField];
        
    [self.splitLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(0.5f);
    }];
    
    [self.editContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).with.offset(12.0f);
        make.right.equalTo(self).with.offset(-12.0f);
        make.height.mas_equalTo(30.0f);
    }];
    
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.editContainerView).with.offset(3.0f);
        make.height.mas_equalTo(24.0f);
        make.width.mas_equalTo(24.0f);
    }];
    
    [self.replyTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.avatarImageView.mas_right).with.offset(20.0f);
        make.right.equalTo(self.editContainerView).with.offset(-12.0f);
        make.height.mas_equalTo(24.0f);
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    // 点击编辑按钮的话，则由代理进行处理
    // 会弹出UFUIReplyQueryAddReplyToPostView
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickReplyTextFieldInReplyQueryFooterView:)]) {
        [self.delegate clickReplyTextFieldInReplyQueryFooterView:self];
    }

    return NO;
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

- (UITextField *)replyTextField {
    if (!_replyTextField) {
        _replyTextField = [[UITextField alloc] initWithFrame:CGRectZero];
        _replyTextField.delegate = self;
    }
    
    return _replyTextField;
}

- (UFUISplitLineView *)splitLineView {
    if (!_splitLineView) {
        _splitLineView = [[UFUISplitLineView alloc] init];
    }
    
    return _splitLineView;
}

@end
