//
//  UFUIAutoHeightTextView.m
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2021/7/1.
//

#import "UFUIAutoHeightTextView.h"

@interface UFUIAutoHeightTextView ()

@property (nonatomic, strong) UITextView* placeholderTextView;

@property (nonatomic, assign) CGFloat textViewHeight;

@property (nonatomic, assign) CGFloat maxTextViewHeight;
@property (nonatomic, assign) CGFloat minTextViewHeight;

@end

@implementation UFUIAutoHeightTextView

#pragma mark init

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {

        [self buildUI];

        _textViewHeight = CGFLOAT_MAX;
        _minNumberOfLines = 3;
        _maxNumberOfLines = NSIntegerMax;
    }

    return self;
}

- (void)buildUI {
    self.showsHorizontalScrollIndicator = NO;
    self.scrollEnabled = NO;
    self.scrollsToTop = NO;
    self.enablesReturnKeyAutomatically = YES;
    
    self.backgroundColor = [UIColor clearColor];
    self.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.textColor = [UIColor labelColor];
    
    [self addSubview:self.placeholderTextView];
    [self sendSubviewToBack:self.placeholderTextView];
    [self.placeholderTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textValueChanged) name:UITextViewTextDidChangeNotification object:self];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark KVO

- (void)textValueChanged {
    self.placeholderTextView.hidden = (self.text.length != 0);
    
    CGFloat height = ceilf([self sizeThatFits:CGSizeMake(self.bounds.size.width, MAXFLOAT)].height);
    
    // 高度不一样，就改变了高度
    if (self.textViewHeight != height) {
        if (height > self.maxTextViewHeight && self.textViewHeight == self.maxTextViewHeight && self.scrollEnabled == YES) {

        } else if (height < self.minTextViewHeight && self.textViewHeight == self.minTextViewHeight && self.scrollEnabled == NO) {

        } else {
            self.scrollEnabled = height > self.maxTextViewHeight;
            
            if (height > self.maxTextViewHeight) {
                height = self.maxTextViewHeight;
            }
            
            if (height < self.minTextViewHeight) {
                height = self.minTextViewHeight;
            }
            
            self.textViewHeight = height;
            
            if (self.textViewHeightChangeBlock) {
                self.textViewHeightChangeBlock(self.textViewHeight);
            }
        }
    }
}

- (UITextView *)placeholderTextView {
    if (!_placeholderTextView) {
        _placeholderTextView = [[UITextView alloc] init];

        _placeholderTextView.contentInset = self.contentInset;

        _placeholderTextView.textColor = [UIColor secondaryLabelColor];
        _placeholderTextView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];

        _placeholderTextView.scrollEnabled = NO;

        [_placeholderTextView setUserInteractionEnabled:NO];
    }
    
    return _placeholderTextView;
}

#pragma mark Getter/Setter

- (void)setText:(NSString *)text {
    [super setText:text];
    self.placeholderTextView.hidden = (self.text.length != 0);
}

- (void)setMaxNumberOfLines:(NSInteger)maxNumberOfLines {
    _maxNumberOfLines = maxNumberOfLines;
    self.maxTextViewHeight = ceil(self.font.lineHeight * maxNumberOfLines + self.textContainerInset.top + self.textContainerInset.bottom);
}

- (void)setMinNumberOfLines:(NSInteger)minNumberOfLines {
    _minNumberOfLines = minNumberOfLines;
    self.minTextViewHeight = ceil(self.font.lineHeight * minNumberOfLines + self.textContainerInset.top + self.textContainerInset.bottom);
}

- (void)setTextViewHeightChangeBlock:(void (^)(CGFloat))textViewHeightChangeBlock{
    _textViewHeightChangeBlock = textViewHeightChangeBlock;
    [self textValueChanged];
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    self.placeholderTextView.text = placeholder;
}

@end
