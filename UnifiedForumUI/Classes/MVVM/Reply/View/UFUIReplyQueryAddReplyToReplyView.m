//
//  UFUIReplyQueryAddReplyToReplyView.m
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2023/2/22.
//

#import "UFUIReplyQueryAddReplyToReplyView.h"

#import "UFUIReplyQueryAddReplyToReplyViewModel.h"

#import "UFUISplitLineView.h"

#import "UFUIConstants.h"

@interface UFUIReplyQueryAddReplyToReplyView () <UITextViewDelegate>

@end

@implementation UFUIReplyQueryAddReplyToReplyView

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
    [self addSubview:self.replyTextView];
    [self addSubview:self.replyButton];
        
    [self.splitLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(0.5f);
    }];
    
    [self.toLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12.0f);
        make.top.equalTo(self).with.offset(12.0f);
        make.right.equalTo(self).with.offset(-12.0f);
        make.height.mas_equalTo(30.0f);
    }];
    
    [self.replyTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.toLabel.mas_bottom).with.offset(12.0f);
        make.left.equalTo(self).with.offset(12.0f);
        make.right.equalTo(self).with.offset(-80.0f);
        make.bottom.equalTo(self).with.offset(-12.0f);
    }];
    
    [self.replyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.replyTextView.mas_right).with.offset(8.0f);
        make.bottom.equalTo(self.replyTextView);
        make.height.mas_equalTo(24.0f);
        make.width.mas_equalTo(60.0f);
    }];
}

- (void)configWithAddReplyToReplyVM:(UFUIReplyQueryAddReplyToReplyViewModel *)addReplyToReplyVM {
    self.addReplyToReplyVM = addReplyToReplyVM;
    
    self.toLabel.text = addReplyToReplyVM.toLabelText;
    self.replyTextView.text = addReplyToReplyVM.content;
}

- (void)show {
    [self.replyTextView becomeFirstResponder];
}

- (void)dismiss {
    [self.replyTextView resignFirstResponder];
}

#pragma mark UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    NSString *text = [textView.text jk_trimmingWhitespace];
    
    if (text.length > 0) {
        [self.replyButton setEnabled:YES];
    } else {
        [self.replyButton setEnabled:NO];
    }
    
    self.addReplyToReplyVM.content = text;
}

#pragma mark - Event Response

- (void)clickReplyButton:(id)sender {
    if ([self.delegate respondsToSelector:@selector(clickReplyButtonInAddReplyToReplyView:)]) {
        [self.delegate clickReplyButtonInAddReplyToReplyView:self];
    }
}

#pragma mark - Getter/Setter

- (UILabel *)toLabel {
    if (!_toLabel) {
        _toLabel = [[UILabel alloc] init];
        _toLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
        _toLabel.textColor = [UIColor secondaryLabelColor];
        _toLabel.numberOfLines = 1;
    }
    
    return _toLabel;
}


- (UITextView *)replyTextView {
    if (!_replyTextView) {
        _replyTextView = [[UITextView alloc] init];
        _replyTextView.backgroundColor = [UIColor secondarySystemBackgroundColor];
        _replyTextView.textColor = [UIColor labelColor];
        _replyTextView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        
        _replyTextView.layer.borderColor = [UIColor separatorColor].CGColor;
        _replyTextView.layer.borderWidth = 0.5;
        _replyTextView.layer.cornerRadius = 10.0f;
        _replyTextView.layer.masksToBounds = YES;
        
        _replyTextView.delegate = self;
    }
    
    return _replyTextView;
}

- (UIButton *)replyButton {
    if (!_replyButton) {
        _replyButton = [[UIButton alloc] init];
        _replyButton.layer.cornerRadius = 12.0f;
        _replyButton.layer.masksToBounds = YES;
        _replyButton.backgroundColor = [UIColor linkColor];
        _replyButton.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];

        [_replyButton setTitle:KUFUILocalization(@"UFUIReplyQueryViewController.replyQueryAddReplyToReplyView.sendButton.title") forState:UIControlStateNormal];
        [_replyButton setTitleColor:[UIColor systemBackgroundColor] forState:UIControlStateNormal];
        [_replyButton setTitleColor:[UIColor secondarySystemBackgroundColor] forState:UIControlStateDisabled];
        [_replyButton setEnabled:NO];

        [_replyButton addTarget:self action:@selector(clickReplyButton:) forControlEvents:UIControlEventTouchUpInside];

    }
    
    return _replyButton;
}

- (UFUISplitLineView *)splitLineView {
    if (!_splitLineView) {
        _splitLineView = [[UFUISplitLineView alloc] init];
    }
    
    return _splitLineView;
}

@end
