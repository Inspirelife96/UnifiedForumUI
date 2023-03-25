//
//  UFUIPageMenuView.m
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2021/12/9.
//

#import "UFUIPageMenuView.h"

#import "UFUIMenuItem.h"

@interface UFUIPageMenuView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

// 菜单用CollectionView来展示
@property (nonatomic, strong) UICollectionView *tabCollectionView;

// 底部的指示器
@property (nonatomic, strong) UIView *indicatorView;

// 分割线
@property (nonatomic, strong) UIView *seperatorView;

// 菜单文本的宽度的数组
@property (nonatomic, strong) NSArray *titleWidthArray;

// 选中时文本的颜色
@property (nonatomic, strong) UIColor *selectionTextColor;

// 未选中时文本的颜色
@property (nonatomic, strong) UIColor *deselectionTextColor;

// 当前选中的菜单
@property (nonatomic, assign) NSInteger currentSelectionIndex;

@end

@implementation UFUIPageMenuView


#pragma mark Init

- (instancetype)initWithFrame:(CGRect)frame pageMenuViewDataSource:(id<UFUIPageMenuViewDataSource>)pageMenuViewDataSource pageMenuViewDelegate:(id<UFUIPageMenuViewDelegate>)pageMenuViewDelegate pageMenuViewStyle:(UFUIPageMenuViewStyle)pageMenuViewStyle {
    if (self = [super initWithFrame:frame]) {
        self.pageMenuViewDataSource = pageMenuViewDataSource;
        self.pageMenuViewDelegate = pageMenuViewDelegate;
        self.pageMenuViewStyle = pageMenuViewStyle;
        
        // 初始时指定第一个菜单
        self.currentSelectionIndex = 0;

        [self buildUI];
    }
    
    return self;
}

- (void)buildUI {
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor secondarySystemBackgroundColor];

    // 添加菜单并布局
    [self addSubview:self.tabCollectionView];
    [self.tabCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    // 添加底部的分割线并布局
    [self addSubview:self.seperatorView];
    [self.seperatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(0.5f);
    }];

    // 注意，指示器是tabCollectionView的子视图
    // 具体的布局由_tabDidScrollToIndex内设定
    [self.tabCollectionView addSubview:self.indicatorView];

    // 初始时，滚动到第一个菜单
    [self _tabDidScrollToIndex:self.currentSelectionIndex];
}

#pragma mark UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.pageMenuViewStyle == UFUIPageMenuViewStyleFixed) {
        // 固定模式，宽度均分
        CGFloat itemWidth = self.tabCollectionView.bounds.size.width/[self.pageMenuViewDataSource numberOfMenusInPageMenuView:self];
        return CGSizeMake(itemWidth, self.tabCollectionView.bounds.size.height);
    } else {
        // 瀑布布局，每个Cell的宽度为菜单文本的宽度+10.0f(MenuItem内部的布局是菜单Label+左右各5.0的边距)
        return CGSizeMake([self.titleWidthArray[indexPath.row] floatValue] + 10.0f, self.tabCollectionView.bounds.size.height);
    }
}

#pragma mark UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // 点击菜单，PageMenuView本身不用做任何事，让代理处理
    // 此时需要和PageView联动，把PageView滚动到对应的页面，同时再由代理回调scrollViewDidScrollToIndex处理菜单的UI更新
    if ([self.pageMenuViewDelegate respondsToSelector:@selector(tabView:didSelectIndex:)]) {
        [self.pageMenuViewDelegate tabView:self didSelectIndex:indexPath.row];
    }
}

#pragma mark UICollectionViewDataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UFUIMenuItem *tabItem = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UFUIMenuItem class]) forIndexPath:indexPath];
    // 具体每个菜单的内容由数据源提供
    tabItem.titleLabel.text = [self.pageMenuViewDataSource pageMenuView:self menuTitleAtIndex:indexPath.row];
    
    if (self.currentSelectionIndex == indexPath.row) {
        tabItem.titleLabel.textColor = self.selectionTextColor;
    } else {
        tabItem.titleLabel.textColor = self.deselectionTextColor;
    }

    return tabItem;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    // 具体有多少个菜单由数据源提供
    return [self.pageMenuViewDataSource numberOfMenusInPageMenuView:self];
}

#pragma mark UFUIPageMenuViewProtocol

// 这个协议主要考虑当PageView滚动到contentOffsetX时，PageMenuView需要怎么处理
// 一般用来处理当PageView左右缓慢滑动时，PageMenuView的指示器也做相应的滑动
// 也可以不做任何处理
- (void)scrollViewHorizontalScrolledContentOffsetX:(CGFloat)contentOffsetX {
    // 当前的行为：
    // 即当PageView左右缓慢滑动不超过一个页面时，PageMenuView的指示器做相应的滑动。
    // 如果连续滑动超过一个页面时，不做任何处理
    CGFloat offsetX = contentOffsetX - (self.bounds.size.width) * self.currentSelectionIndex;

    CGFloat offsetXPercentage = fabs(offsetX/self.bounds.size.width);
    
    // 如果offsetXPercentage > 1 则不用考虑了
    if (offsetXPercentage > 1) {
        return;
    }
    
    NSInteger tabNumber = [self.pageMenuViewDataSource numberOfMenusInPageMenuView:self];
    
    NSInteger targetIndex = 0;
    
    if (offsetX > 0) {
        targetIndex = self.currentSelectionIndex + 1;
    } else {
        targetIndex = self.currentSelectionIndex - 1;
    }
    
    // 如果超过范围，则直接返回
    if (targetIndex < 0 || targetIndex > tabNumber - 1) {
        return;
    }
    
    CGFloat fromXPos = [self _xPosForTabItemAtIndex:self.currentSelectionIndex];
    CGFloat toXPos = [self _xPosForTabItemAtIndex:targetIndex];
    CGFloat fromTitleWidth = [self.titleWidthArray[self.currentSelectionIndex] floatValue];
    CGFloat toTitleWidth = [self.titleWidthArray[targetIndex] floatValue];

    CGFloat widthDiff = toTitleWidth - fromTitleWidth;
    CGFloat XPosDiff = toXPos - fromXPos;

    CGFloat indicatorXPos = fromXPos + XPosDiff * offsetXPercentage;
    CGFloat indicatorWidth = fromTitleWidth + widthDiff * offsetXPercentage;

    self.indicatorView.frame = CGRectMake(indicatorXPos, CGRectGetHeight(self.bounds) - 8, indicatorWidth, 2);
}

// 滚动到对应的菜单
- (void)scrollViewDidScrollToIndex:(NSInteger)index {
    [self _tabDidScrollToIndex:index];
}

- (void)scrollViewWillScrollFromIndex:(NSInteger)index {
    //目前不做处理
}

- (void)pageViewheaderViewVerticalScrolledContentPercentY:(CGFloat)contentPercentY {
    //目前不做处理
}

#pragma mark Private Methods

- (void)_tabDidScrollToIndex:(NSInteger)index {
    // 更新currentSelectionIndex
    self.currentSelectionIndex = index;

    //必要，主要时为了更新选中/未选中的字体颜色
    [self.tabCollectionView reloadData];

    // 将当前选中的菜单居中
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tabCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:true];
    
    // 更新指示器的位置
    [self _updateIndicatorFrameToIndex:index];
}

- (CGFloat)_xPosForTabItemAtIndex:(NSInteger)index {
    if (self.pageMenuViewStyle == UFUIPageMenuViewStyleFixed) {
        CGFloat itemWidth = self.bounds.size.width/[self.pageMenuViewDataSource numberOfMenusInPageMenuView:self];
        CGFloat titleWidth = [self.titleWidthArray[index] floatValue];
        if (titleWidth > itemWidth) {
            return itemWidth * index;
        } else {
            return itemWidth * index + (itemWidth - titleWidth)/2.0f;
        }
    } else {
        // 左边距
        CGFloat xPos = 5.0f;
        for (NSInteger i = 0; i < index; i++) {
            xPos += [self.titleWidthArray[i] floatValue];
            xPos += 5.0f; // 右边距
            xPos += 5.0f; // 左边距
        }
        return xPos;
    }
}

- (void)_updateIndicatorFrameToIndex:(NSInteger)index {
    CGFloat xPos = [self _xPosForTabItemAtIndex:index];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.indicatorView.frame = CGRectMake(xPos, CGRectGetHeight(self.bounds) - 8, [self.titleWidthArray[index] floatValue], 2);
    }];
}

#pragma mark Getter/Setter

- (UICollectionView *)tabCollectionView {
    if (!_tabCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumInteritemSpacing = 0.0f;
        flowLayout.minimumLineSpacing = 0.0f;
        flowLayout.estimatedItemSize = CGSizeZero;
        
        _tabCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        
        _tabCollectionView.delegate = self;
        _tabCollectionView.dataSource = self;
        
        _tabCollectionView.showsVerticalScrollIndicator = NO;
        _tabCollectionView.showsHorizontalScrollIndicator = NO;

        [_tabCollectionView registerClass:[UFUIMenuItem class] forCellWithReuseIdentifier:NSStringFromClass([UFUIMenuItem class])];
    }
    
    return _tabCollectionView;
}

- (NSArray *)titleWidthArray {
    if (!_titleWidthArray) {
        NSMutableArray *titleWidthMutalbeArray = [[NSMutableArray alloc] init];

        // 字体必须和MenuItem内的Label设定的字体一致，这样计算出来的宽度才会准确
        UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        NSDictionary *attributes = @{NSFontAttributeName:font};

        NSInteger titleNumber = [self.pageMenuViewDataSource numberOfMenusInPageMenuView:self];
        for (NSInteger i = 0; i < titleNumber; i++) {
            NSString *title = [self.pageMenuViewDataSource pageMenuView:self menuTitleAtIndex:i];
            CGRect titleSize = [title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, font.lineHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
            [titleWidthMutalbeArray addObject:@(titleSize.size.width)];
        }
        
        _titleWidthArray = [titleWidthMutalbeArray copy];
    }
    
    return _titleWidthArray;
}

- (UIView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIView alloc] initWithFrame:CGRectZero];
        
        _indicatorView.backgroundColor = self.selectionTextColor;
        _indicatorView.layer.cornerRadius = 1;
        _indicatorView.layer.masksToBounds = YES;

        // 设定初始位置
        CGFloat xPos = [self _xPosForTabItemAtIndex:self.currentSelectionIndex];
        _indicatorView.frame = CGRectMake(xPos, CGRectGetHeight(self.bounds) - 8, [self.titleWidthArray[self.currentSelectionIndex] floatValue], 2);
    }
    
    return _indicatorView;
}

- (UIView *)seperatorView {
    if (!_seperatorView) {
        _seperatorView =  [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds) - 0.5, CGRectGetWidth(self.bounds), 0.5)];
        _seperatorView.backgroundColor = [UIColor clearColor];
    }
    
    return _seperatorView;
}


- (UIColor *)deselectionTextColor {
    if (!_deselectionTextColor) {
        _deselectionTextColor = [UIColor secondaryLabelColor];
    }
    
    return _deselectionTextColor;
}

- (UIColor *)selectionTextColor {
    if (!_selectionTextColor) {
        _selectionTextColor = [UIColor linkColor];
    }
    
    return _selectionTextColor;
}

@end
