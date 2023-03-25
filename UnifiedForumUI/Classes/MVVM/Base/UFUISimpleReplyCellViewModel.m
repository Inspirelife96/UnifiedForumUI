//
//  UFUISimpleReplyCellViewModel.m
//  INSParseUI
//
//  Created by XueFeng Chen on 2022/2/25.
//

#import "UFUISimpleReplyCellViewModel.h"

@interface UFUISimpleReplyCellViewModel ()

@property (nonatomic, strong) UILabel *replyLabel;

@end

@implementation UFUISimpleReplyCellViewModel

- (instancetype)initWithReplyModel:(UFMReplyModel *)replyModel {
    if (self = [super init]) {
        self.replyModel = replyModel;
    }
    
    return self;
}


- (NSAttributedString *)buildHighlightText:(NSString *)highlightText normalText:(NSString *)normalText {
    NSString *fullText = [NSString stringWithFormat:@"%@: %@", highlightText, normalText];
    NSRange highlightRange = [fullText rangeOfString:highlightText];
    NSRange normalRange = [fullText rangeOfString:normalText];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:fullText];
    
    [attributedString yy_setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleFootnote] range:highlightRange];
    [attributedString yy_setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleFootnote] range:normalRange];
    
    [attributedString yy_setColor:[UIColor secondaryLabelColor] range:highlightRange];
    [attributedString yy_setColor:[UIColor tertiaryLabelColor] range:normalRange];
    
    return [attributedString copy];
}

- (void)setReplyModel:(UFMReplyModel *)replyModel {
    _replyModel = replyModel;
    
    _attributedText = [self buildHighlightText:self.replyModel.fromUserModel.username normalText:self.replyModel.content];
    
    self.replyLabel.attributedText = self.attributedText;
    self.height = [self.replyLabel sizeThatFits:CGSizeMake([UIScreen jk_width] - 56.0f - 14.0f - 12.0f * 2, CGFLOAT_MAX)].height + 5.0f * 2;
    
//    WEAKSELF
//    dispatch_sync(dispatch_get_main_queue(), ^{
//        STRONGSELF
//        strongSelf.replyLabel.attributedText = self.attributedText;
//        strongSelf.height = [strongSelf.replyLabel sizeThatFits:CGSizeMake([UIScreen jk_width] - 56.0f - 14.0f - 12.0f * 2, CGFLOAT_MAX)].height + 5.0f * 2;
//    });
}

- (UILabel *)replyLabel {
    if (!_replyLabel) {
        _replyLabel = [[UILabel alloc] init];
        _replyLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
        _replyLabel.textColor = [UIColor secondaryLabelColor];
        
        _replyLabel.numberOfLines = 2;
    }
    
    return _replyLabel;
}

@end
