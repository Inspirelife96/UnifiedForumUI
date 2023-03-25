//
//  UFUIEmptyDataSetView.m
//  INSParseUI
//
//  Created by XueFeng Chen on 2021/12/24.
//

#import "UFUIEmptyDataSetView.h"

#import "UFUIConstants.h"
#import "UFUIBundle.h"

@implementation UFUIEmptyDataSetView

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
    
    [self addSubview:self.animationView];
    [self addSubview:self.titleLabel];
    
    [self.animationView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(150);
    }];
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(self.animationView.mas_bottom);
    }];
    
}

- (CompatibleAnimationView *)animationView {
    if (!_animationView) {
        _animationView = [[CompatibleAnimationView alloc] init];
        // Todo:warning:
        CompatibleAnimation *animation = [[CompatibleAnimation alloc] initWithName:@"default_lottie" subdirectory:@"" bundle:[UFUIBundle resourceBundle]];
        
//        CompatibleAnimation *animation = [[CompatibleAnimation alloc] initWithName:@"default_lottie" bundle:[UFUIBundle resourceBundle]];
        _animationView.compatibleAnimation = animation;
        [_animationView setLoopAnimationCount:-1];
        [_animationView play];
    }
    
    return _animationView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        
        _titleLabel.text = KUFUILocalization(@"emptyDataSetView.titleLabel.text.default");
    }
    
    return _titleLabel;
}

@end
