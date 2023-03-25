//
//  UFUIPostQueryAddPostToTopicView.m
//  Bolts
//
//  Created by XueFeng Chen on 2022/1/18.
//

#import "UFUIPostQueryAddPostToTopicView.h"

#import "UFUISplitLineView.h"

#import "UFUIPostQueryAddPostToTopicViewModel.h"

#import "UFUIConstants.h"

@interface UFUIPostQueryAddPostToTopicView () <UITextViewDelegate>

@end

@implementation UFUIPostQueryAddPostToTopicView

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

    [self addSubview:self.splitLineView];
    [self addSubview:self.toLabel];
    [self addSubview:self.postTextView];
    [self addSubview:self.postButton];
    [self addSubview:self.addImageButton];
        
    [self.splitLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(0.5f);
    }];
    
    [self.toLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12.0f);
        make.top.equalTo(self).with.offset(12.0f);
        make.right.equalTo(self).with.offset(12.0f);
        make.height.mas_equalTo(30.0f);
    }];
    
    [self.addImageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12.0f);
        make.bottom.equalTo(self).with.offset(-20.0f);
        make.height.mas_equalTo(30.0f);
        make.width.mas_equalTo(30.0f);
    }];
    
    [self.postTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.toLabel.mas_bottom).with.offset(12.0f);
        make.left.equalTo(self).with.offset(12.0f);
        make.right.equalTo(self).with.offset(-80.0f);
        make.bottom.equalTo(self.addImageButton.mas_top).with.offset(-12.0f);
    }];
    
    [self.postButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.postTextView.mas_right).with.offset(8.0f);
        make.bottom.equalTo(self.postTextView);
        make.height.mas_equalTo(24.0f);
        make.width.mas_equalTo(60.0f);
    }];
}

- (void)configWithAddPostViewModel:(UFUIPostQueryAddPostToTopicViewModel *)addPostVM {
    self.addPostVM = addPostVM;
    
    self.toLabel.text = addPostVM.toLabelText;
    self.postTextView.text = addPostVM.content;
    
    [self.postTextView becomeFirstResponder];
}

// 显示
- (void)show {
    [self.postTextView becomeFirstResponder];
}

// 取消
- (void)dismiss {
    [self.postTextView resignFirstResponder];
}

#pragma mark - Event Response

- (void)clickPostButton:(id)sender {
    if ([self.delegate respondsToSelector:@selector(clickPostButtonInAddPostView:)]) {
        [self.delegate clickPostButtonInAddPostView:self];
    }
}

- (void)clickAddImageButton:(id)sender {
    if ([self.delegate respondsToSelector:@selector(clickAddImageButtonInAddPostView:)]) {
        [self.delegate clickAddImageButtonInAddPostView:self];
    }
}

#pragma mark TextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    NSString *text = [textView.text jk_trimmingWhitespace];
    
    if (text.length > 0) {
        [self.postButton setEnabled:YES];
    } else {
        [self.postButton setEnabled:NO];
    }
    
    self.addPostVM.content = text;
}

#pragma mark - Getter/Setter

- (UILabel *)toLabel {
    if (!_toLabel) {
        _toLabel = [[UILabel alloc] init];
        _toLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
        _toLabel.textColor = [UIColor secondaryLabelColor];
    }
    
    return _toLabel;
}


- (UITextView *)postTextView {
    if (!_postTextView) {
        _postTextView = [[UITextView alloc] init];
        _postTextView.backgroundColor = [UIColor secondarySystemBackgroundColor];
        _postTextView.textColor = [UIColor labelColor];
        _postTextView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        
        _postTextView.layer.borderColor = [UIColor separatorColor].CGColor;
        _postTextView.layer.borderWidth = 0.5;
        _postTextView.layer.cornerRadius = 10.0f;
        _postTextView.layer.masksToBounds = YES;
        
        _postTextView.delegate = self;
    }
    
    return _postTextView;
}

- (UIButton *)postButton {
    if (!_postButton) {
        _postButton = [[UIButton alloc] init];
        _postButton.backgroundColor = [UIColor linkColor];
        
        [_postButton setTitleColor:[UIColor systemBackgroundColor] forState:UIControlStateNormal];
        [_postButton setTitleColor:[UIColor secondarySystemBackgroundColor] forState:UIControlStateDisabled];
        [_postButton setEnabled:NO];
        
        [_postButton addTarget:self action:@selector(clickPostButton:) forControlEvents:UIControlEventTouchUpInside];
        
        _postButton.layer.cornerRadius = 12.0f;
        _postButton.layer.masksToBounds = YES;
        [_postButton setTitle:@"发送" forState:UIControlStateNormal];
        _postButton.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    }
    
    return _postButton;
}

- (UIButton *)addImageButton {
    if (!_addImageButton) {
        _addImageButton = [[UIButton alloc] init];
        UIImageSymbolConfiguration *imageSymbolConfig = [UIImageSymbolConfiguration configurationWithPointSize:24.0f];
        [_addImageButton setImage:[UIImage systemImageNamed:@"photo.circle" withConfiguration:imageSymbolConfig] forState:UIControlStateNormal];
        [_addImageButton addTarget:self action:@selector(clickAddImageButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _addImageButton;
}

- (UFUISplitLineView *)splitLineView {
    if (!_splitLineView) {
        _splitLineView = [[UFUISplitLineView alloc] init];
    }
    
    return _splitLineView;
}

@end
