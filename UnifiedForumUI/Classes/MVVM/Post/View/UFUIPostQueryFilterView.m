//
//  UFUIPostQueryFilterView.m
//  INSParseUI
//
//  Created by XueFeng Chen on 2021/12/23.
//

#import "UFUIPostQueryFilterView.h"


#import "UFUIConstants.h"

#import "UFUIPostQueryFilterViewModel.h"

@interface UFUIPostQueryFilterView ()

@property (nonatomic, strong) UIView *orderButtonBackgroundView;

@end

@implementation UFUIPostQueryFilterView

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

- (void)dealloc {
    @try {
        [self removeObserver:self forKeyPath:@"postQueryFilterVM.postQueryFilterType"];
        [self removeObserver:self forKeyPath:@"postQueryFilterVM.postQueryOrderType"];
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}

- (void)buildUI {
    [self setBackgroundColor:[UIColor systemBackgroundColor]];
    [self addSubview:self.filterToAllButton];
    [self addSubview:self.filterToTopicHostOnlyButton];
    [self addSubview:self.orderButtonBackgroundView];
    [self addSubview:self.ascendButton];
    [self addSubview:self.descendButton];
    
    [self.filterToAllButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(10.0f);
        make.top.equalTo(self).with.offset(10.0f);
        make.bottom.equalTo(self).with.offset(-10.0f);
        make.width.mas_greaterThanOrEqualTo(0.0f);
    }];
    
    [self.filterToTopicHostOnlyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.filterToAllButton.mas_right).with.offset(10.0f);
        make.top.equalTo(self.filterToAllButton);
        make.bottom.equalTo(self.filterToAllButton);
        make.width.mas_greaterThanOrEqualTo(0.0f);
    }];
    
    [self.descendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-10.0f);
        make.top.equalTo(self.filterToAllButton);
        make.bottom.equalTo(self.filterToAllButton);
        make.width.mas_greaterThanOrEqualTo(0.0f);
    }];
    
    [self.ascendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.descendButton.mas_left).with.offset(-10.0f);
        make.top.equalTo(self.filterToAllButton);
        make.bottom.equalTo(self.filterToAllButton);
        make.width.mas_greaterThanOrEqualTo(0.0f);
    }];
    
    [self.orderButtonBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.ascendButton);
        make.right.equalTo(self.descendButton);
        make.top.equalTo(self.filterToAllButton);
        make.bottom.equalTo(self.filterToAllButton);
    }];
}

#pragma mark Actions

- (void)clickFilterToAllButton:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickFilterToAllButtonInPostQueryFilterView:)]) {
        [self.delegate clickFilterToAllButtonInPostQueryFilterView:self];
    }
}

- (void)clickFilterToTopicHostOnlyButton:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickFilterToTopicHostOnlyButtonInPostQueryFilterView:)]) {
        [self.delegate clickFilterToTopicHostOnlyButtonInPostQueryFilterView:self];
    }
}

- (void)clickAscendButton:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickAscendButtonInPostQueryFilterView:)]) {
        [self.delegate clickAscendButtonInPostQueryFilterView:self];
    }
}

- (void)clickDescendButton:(UIButton *)sender {
    [self.ascendButton setSelected:NO];
    [self.descendButton setSelected:YES];
    [self _updateOrderButtonUI];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickDescendButtonInPostQueryFilterView:)]) {
        [self.delegate clickDescendButtonInPostQueryFilterView:self];
    }
}

- (void)configWithPostQueryFilterViewModel:(UFUIPostQueryFilterViewModel *)postQueryFilterVM {
    self.postQueryFilterVM = postQueryFilterVM;
    
    [self _updateOrderButtonUI];
    [self _updateFilterButtonUI];
    
    [self addObserver:self forKeyPath:@"postQueryFilterVM.postQueryFilterType" options:NSKeyValueObservingOptionNew context:nil];
    
    [self addObserver:self forKeyPath:@"postQueryFilterVM.postQueryOrderType" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"postQueryFilterVM.postQueryFilterType"]) {
        // 安全起见，我们可能会在子线程更新KVO监控的值，因此如果需要UI更新的话，务必在主线程中执行。
        dispatch_async(dispatch_get_main_queue(), ^{
            [self _updateFilterButtonUI];
        });
    } else if ([keyPath isEqualToString:@"postQueryFilterVM.postQueryOrderType"]) {
        // 安全起见，我们可能会在子线程更新KVO监控的值，因此如果需要UI更新的话，务必在主线程中执行。
        dispatch_async(dispatch_get_main_queue(), ^{
            [self _updateOrderButtonUI];
        });
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark Private Methods

- (void)_updateOrderButtonUI {
    if (self.postQueryFilterVM.postQueryOrderType == UFUIPostQueryOrderTypeAscend) {
        [self.ascendButton setSelected:YES];
        [self.descendButton setSelected:NO];
        self.ascendButton.layer.borderWidth = 0.5f;
        self.descendButton.layer.borderWidth = 0.0f;
    } else {
        [self.ascendButton setSelected:NO];
        [self.descendButton setSelected:YES];
        self.ascendButton.layer.borderWidth = 0.0f;
        self.descendButton.layer.borderWidth = 0.5f;
    }
}

- (void)_updateFilterButtonUI {
    if (self.postQueryFilterVM.postQueryFilterType == UFUIPostQueryFilterTypeAll) {
        [self.filterToAllButton setSelected:YES];
        [self.filterToTopicHostOnlyButton setSelected:NO];
        self.filterToAllButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        self.filterToTopicHostOnlyButton.titleLabel.font = [UIFont systemFontOfSize:13];
    } else {
        [self.filterToAllButton setSelected:NO];
        [self.filterToTopicHostOnlyButton setSelected:YES];
        self.filterToAllButton.titleLabel.font = [UIFont systemFontOfSize:13];
        self.filterToTopicHostOnlyButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    }
}

- (UIButton *)_createFilterButton {
    UIButton *button = [[UIButton alloc] init];
    [button setTitleColor:[UIColor labelColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    
    return button;
}

- (UIButton *)_createOrderButton {
    UIButton *button = [[UIButton alloc] init];
    
    [button setTitleColor:[UIColor labelColor] forState:UIControlStateNormal];
    
    button.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    
    button.layer.borderColor = [UIColor separatorColor].CGColor;
    button.layer.borderWidth = 0.5f;
    [button jk_setBackgroundColor:[UIColor systemBackgroundColor] forState:UIControlStateSelected];
    [button jk_setBackgroundColor:[UIColor secondarySystemBackgroundColor] forState:UIControlStateNormal];
    button.layer.cornerRadius = 10.0f;
    button.layer.masksToBounds = YES;
    
    return button;
}

#pragma mark Getter/Setter

- (UIButton *)filterToAllButton {
    if (!_filterToAllButton) {
        _filterToAllButton = [self _createFilterButton];
        [_filterToAllButton setTitle:KUFUILocalization(@"postQueryFilterView.filterToAllButton.title") forState:UIControlStateNormal];
        [_filterToAllButton setSelected:YES];
        [_filterToAllButton addTarget:self action:@selector(clickFilterToAllButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _filterToAllButton;
}

- (UIButton *)filterToTopicHostOnlyButton {
    if (!_filterToTopicHostOnlyButton) {
        _filterToTopicHostOnlyButton = [self _createFilterButton];
        [_filterToTopicHostOnlyButton setTitle:KUFUILocalization(@"postQueryFilterView.filterToTopicHostOnlyButton.title") forState:UIControlStateNormal];
        [_filterToTopicHostOnlyButton setSelected:NO];
        [_filterToTopicHostOnlyButton addTarget:self action:@selector(clickFilterToTopicHostOnlyButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _filterToTopicHostOnlyButton;
}

- (UIButton *)ascendButton {
    if (!_ascendButton) {
        _ascendButton = [self _createOrderButton];
        [_ascendButton setTitle:KUFUILocalization(@"postQueryFilterView.ascendButton.title") forState:UIControlStateNormal];
        [_ascendButton setSelected:YES];
        [_ascendButton addTarget:self action:@selector(clickAscendButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _ascendButton;
}

- (UIButton *)descendButton {
    if (!_descendButton) {
        _descendButton = [self _createOrderButton];
        [_descendButton setTitle:KUFUILocalization(@"postQueryFilterView.descendButton.title") forState:UIControlStateNormal];
        [_descendButton setSelected:NO];
        [_descendButton addTarget:self action:@selector(clickDescendButton:) forControlEvents:UIControlEventTouchUpInside];

    }
    
    return _descendButton;
}

- (UIView *)orderButtonBackgroundView {
    if (!_orderButtonBackgroundView) {
        _orderButtonBackgroundView = [[UIView alloc] init];
        _orderButtonBackgroundView.backgroundColor = [UIColor secondarySystemBackgroundColor];
        _orderButtonBackgroundView.layer.cornerRadius = 10.0f;
        _orderButtonBackgroundView.layer.masksToBounds = YES;
    }
    
    return _orderButtonBackgroundView;
}

@end
