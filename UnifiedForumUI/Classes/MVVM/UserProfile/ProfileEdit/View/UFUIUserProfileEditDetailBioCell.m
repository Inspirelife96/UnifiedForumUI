//
//  UFUIUserProfileEditDetailBioCell.m
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2021/10/25.
//

#import "UFUIUserProfileEditDetailBioCell.h"

#import "UFUIAutoHeightTextView.h"

#import "UFUIUserProfileEditViewModel.h"

#import "UFUIConstants.h"

@interface UFUIUserProfileEditDetailBioCell ()

@property (nonatomic, strong) UILabel *descriptionLabel;

@end

@implementation UFUIUserProfileEditDetailBioCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self buildUI];
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self buildUI];
    }
    
    return self;
}

- (void)buildUI {
    self.maxNumberWords = 128;
    
    [self.contentView addSubview:self.descriptionLabel];
    [self.contentView addSubview:self.bioTextView];
    [self.contentView addSubview:self.textNumberLabel];
    
    [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(12.0f);
        make.left.equalTo(self.contentView).with.offset(20.0f);
        make.height.mas_equalTo(21.0f);
        make.width.mas_equalTo(80.0f);
    }];
    
    [self.textNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.descriptionLabel.mas_right);
        make.right.equalTo(self.contentView).with.offset(-20);
        make.bottom.equalTo(self.contentView).with.offset(-8);
        make.height.mas_equalTo(21.0f);
    }];
    
    //顶部的约束优先级最高，那么会先改变约束优先级高的，这样避免了底部在输入的换行自适应是的上下跳动问题
    [self.bioTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(6).priority(999);
        make.height.mas_greaterThanOrEqualTo(@(14)).priority(888);
        make.bottom.equalTo(self.textNumberLabel.mas_top).offset(-8).priority(777);
        make.left.equalTo(self.descriptionLabel.mas_right);
        make.right.equalTo(self.contentView.mas_right).offset(-20);
    }];
    
    WEAKSELF
    self.bioTextView.textViewHeightChangeBlock = ^(CGFloat textViewHeight) {
        STRONGSELF
        [strongSelf.bioTextView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_greaterThanOrEqualTo(@(textViewHeight)).priority(888);
        }];
        
        if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(textViewCell:textHeightChange:)]) {
            [strongSelf.delegate textViewCell:strongSelf textHeightChange:textViewHeight];
        }
        
        [strongSelf layoutIfNeeded];
    };
    
    self.backgroundColor = [UIColor systemBackgroundColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.maxNumberWords = 128;
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView{
    // 输入的时候字符限制
    // 判断是否存在高亮字符，如果有，则不进行字数统计和字符串截断
    UITextRange *selectedRange = textView.markedTextRange;
    UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
    
    if (position) {
        return;
    }
    
    //当前输入字数
    self.textNumberLabel.text = [NSString stringWithFormat:@"%lu/%ld",(unsigned long)textView.text.length, self.maxNumberWords];
    
    if (textView.text.length > self.maxNumberWords) {
        textView.text = [textView.text substringToIndex:self.maxNumberWords];
        self.textNumberLabel.text = [NSString stringWithFormat:@"%ld/%ld", self.maxNumberWords, self.maxNumberWords];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(textViewCell:textChange:)]) {
        [self.delegate textViewCell:self textChange:self.bioTextView.text];
    }
}

- (void)configWithUserProfileEditViewModel:(UFUIUserProfileEditViewModel *)userProfileEditVM {
    self.bioTextView.text = userProfileEditVM.bio;
    
    [self updateTextNumberLabel];
}

- (void)updateTextNumberLabel {
    self.textNumberLabel.text = [NSString stringWithFormat:@"%lu/%ld",(unsigned long)self.bioTextView.text.length, self.maxNumberWords];
    self.textNumberLabel.textColor = [UIColor tertiaryLabelColor];

    if (self.bioTextView.text.length > self.maxNumberWords) {
        self.bioTextView.text = [self.bioTextView.text substringToIndex:self.maxNumberWords];
        self.textNumberLabel.text = [NSString stringWithFormat:@"%ld/%ld", self.maxNumberWords, self.maxNumberWords];
        self.textNumberLabel.textColor = [UIColor systemRedColor];
    }
}

#pragma mark - Getter/Setter

- (UILabel *)descriptionLabel {
    if (!_descriptionLabel) {
        _descriptionLabel = [[UILabel alloc] init];
        _descriptionLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
        _descriptionLabel.textColor = [UIColor secondaryLabelColor];
        _descriptionLabel.text = KUFUILocalization(@"userProfileEditDetailBioCell.descriptionLabel.title");
    }
    
    return _descriptionLabel;
}

- (UFUIAutoHeightTextView *)bioTextView{
    if (!_bioTextView) {
        _bioTextView = [[UFUIAutoHeightTextView alloc] initWithFrame:CGRectZero];
        _bioTextView.backgroundColor = self.backgroundColor;
        _bioTextView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        _bioTextView.textColor = [UIColor linkColor];
        
        _bioTextView.minNumberOfLines = 2;
        _bioTextView.maxNumberOfLines = 6;
        _bioTextView.delegate = self;
        
        _bioTextView.placeholder = KUFUILocalization(@"userProfileEditDetailBioCell.signatureTextView.placeholder");
    }
    
    return _bioTextView;
}

- (UILabel *)textNumberLabel {
    if (!_textNumberLabel) {
        _textNumberLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _textNumberLabel.textAlignment = NSTextAlignmentRight;
        _textNumberLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
        _textNumberLabel.textColor = [UIColor secondaryLabelColor];
    }
    
    return _textNumberLabel;
}

- (void)setMaxNumberWords:(NSInteger)maxNumberWords {
    _maxNumberWords = maxNumberWords;
    self.textNumberLabel.text = [NSString stringWithFormat:@"0/%ld", self.maxNumberWords];
}

@end
