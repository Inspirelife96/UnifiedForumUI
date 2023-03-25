//
//  UFUIReplyQuerySectionView.m
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2023/2/21.
//

#import "UFUIReplyQuerySectionView.h"

@implementation UFUIReplyQuerySectionView

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
    [self addSubview:self.sectionDescriptionLabel];
        
    [self.sectionDescriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12.0f);
        make.right.equalTo(self).with.offset(-12.0f);
        make.top.bottom.equalTo(self);
    }];
}

- (void)configWithSectionDescription:(NSString *)sectionDescription {
    self.sectionDescriptionLabel.text = sectionDescription;
}

- (UILabel *)sectionDescriptionLabel {
    if (!_sectionDescriptionLabel) {
        _sectionDescriptionLabel = [[UILabel alloc] init];
        _sectionDescriptionLabel.textAlignment = NSTextAlignmentLeft;
        _sectionDescriptionLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    }
    
    return _sectionDescriptionLabel;
}

@end
