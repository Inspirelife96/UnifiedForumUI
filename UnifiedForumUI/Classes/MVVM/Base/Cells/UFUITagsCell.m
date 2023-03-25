//
//  UFUITagsCell.m
//  INSParseUI
//
//  Created by XueFeng Chen on 2021/7/2.
//

#import "UFUITagsCell.h"

#import "JCTagListView.h"

#import "UFUIConstants.h"

@interface UFUITagsCell ()


@property (nonatomic, strong) UILabel *placeholderLabel;

@end

@implementation UFUITagsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self buildUI];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self buildUI];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self buildUI];
    }
    
    return self;
}

- (void)buildUI {
    self.contentView.backgroundColor = [UIColor secondarySystemBackgroundColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.tagView];
    [self.contentView addSubview:self.placeholderLabel];

    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(8.0f);
        make.left.equalTo(self.contentView).with.offset(12.0f);
        make.right.equalTo(self.contentView).with.offset(-12.0f);
        make.bottom.equalTo(self.contentView).with.offset(-8.0f);
    }];
        
    [self.placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(8.0f);
        make.left.equalTo(self.contentView).with.offset(20.0f);
        make.right.equalTo(self.contentView).with.offset(-20.0f);
        make.bottom.equalTo(self.contentView).with.offset(-8.0f).priorityLow();
        make.height.mas_greaterThanOrEqualTo(36.0f).priorityMedium();
    }];
}

- (void)configCellWithTags:(NSArray *)tags selectedTags:(NSArray *)selectedTags {
    if (tags && tags.count > 0) {
        [self.placeholderLabel setHidden:YES];
        
        self.tagView.supportSelected = YES;
        self.tagView.supportMultipleSelected = YES;
        
        self.tagView.tags = tags;
        self.tagView.selectedTags = [selectedTags mutableCopy];
        [self.tagView setHidden:NO];
    } else {
        [self.placeholderLabel setHidden:NO];
        [self.tagView setHidden:YES];
    }
}

#pragma mark Getter/Setter

- (UILabel *)placeholderLabel {
    if (!_placeholderLabel) {
        _placeholderLabel = [[UILabel alloc] init];
        _placeholderLabel.textColor = [UIColor secondaryLabelColor];
        _placeholderLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        _placeholderLabel.text = KUFUILocalization(@"tagsCell.placeholderLable.text");
    }
    
    return _placeholderLabel;
}

- (JCTagListView *)tagView {
    if (!_tagView) {
        _tagView = [[JCTagListView alloc] initWithFrame:CGRectZero];
        
        _tagView.tagTextColor = [UIColor secondaryLabelColor];
        _tagView.tagSelectedTextColor = [UIColor labelColor];
        
        _tagView.tagBackgroundColor = [UIColor tertiarySystemBackgroundColor];
        _tagView.tagSelectedBackgroundColor = [UIColor systemBackgroundColor];
    }
    
    return _tagView;
}

@end
