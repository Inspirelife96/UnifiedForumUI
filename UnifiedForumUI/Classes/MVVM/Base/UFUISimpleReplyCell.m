//
//  UFUISimpleReplyCell.m
//  INSParseUI
//
//  Created by XueFeng Chen on 2022/2/24.
//

#import "UFUISimpleReplyCell.h"

#import "UFUISimpleReplyCellViewModel.h"

@implementation UFUISimpleReplyCell

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
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    [self.contentView addSubview:self.replyLabel];
    
    [self.replyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(5.0f);
        make.left.equalTo(self.contentView).with.offset(12.0f);
        make.bottom.equalTo(self.contentView).with.offset(-5.0f);
        make.right.equalTo(self.contentView).with.offset(-12.0f);
    }];
}

- (void)configWithSimpleReplyCellViewModel:(UFUISimpleReplyCellViewModel *)simpleReplyCellVM {
    self.simpleReplyCellVM = simpleReplyCellVM;
    
//    replyVM.fromUser.userName;
//    replyVM.toReplyFromUser.username;
//    NSString *combinedString = [NSString stringWithFormat:@"%@:回复 %@:%@", replyVM.fromUser.username, replyVM.toUser.username, replyVM.content];
//
//    if ([replyVM.fromUser.username isEqualToString:replyVM.toUser.username]) {
//        combinedString = [NSString stringWithFormat:@"%@:%@", replyVM.fromUser.username, replyVM.content];
//    }
    
    self.replyLabel.attributedText = simpleReplyCellVM.attributedText;
}

- (UILabel *)replyLabel {
    if (!_replyLabel) {
        _replyLabel = [[UILabel alloc] init];
        _replyLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
        _replyLabel.textColor = [UIColor secondaryLabelColor];
        
        _replyLabel.numberOfLines = 0;
    }
    
    return _replyLabel;
}

@end
