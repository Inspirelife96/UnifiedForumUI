//
//  UFUITimeLineHeaderView.m
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2023/3/21.
//

#import "UFUITimeLineHeaderView.h"

#import "UFUITimeLineHeaderViewModel.h"

#import "UIImage+UFUIDefaultAvatar.h"

@implementation UFUITimeLineHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
    }

    return self;
}

- (void)buildUI {
    [self addSubview:self.avatarImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.timeInfoLabel];

    // 顶部的个人信息和交互 布局开始
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(12.0f);
        make.top.equalTo(self).with.offset(14.0f);
        make.bottom.equalTo(self).width.offset(14.0f);
        make.width.mas_equalTo(36.0f);
        make.height.mas_equalTo(36.0f);
    }];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarImageView.mas_right).with.offset(8.0f);
        make.top.equalTo(self).with.offset(12.0f);
        make.width.mas_greaterThanOrEqualTo(10.0f);
        make.height.mas_equalTo(20.0f);
    }];

    [self.timeInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(2.0f);
        make.width.mas_greaterThanOrEqualTo(10.0f);
        make.height.mas_equalTo(18.0f);
    }];
}

- (void)configWithTimeLineHeaderViewModel:(UFUITimeLineHeaderViewModel *)timeLineHeaderVM {
    if (timeLineHeaderVM.avatarUrlString && [timeLineHeaderVM.avatarUrlString jk_isValidUrl]) {
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:timeLineHeaderVM.avatarUrlString] placeholderImage:[UIImage ufui_defaultAvatar]];
    } else {
        [self.avatarImageView setImage:[UIImage ufui_defaultAvatar]];
    }
    
    self.titleLabel.text = timeLineHeaderVM.title;
    self.timeInfoLabel.text = timeLineHeaderVM.timeInfo;
}

@end
