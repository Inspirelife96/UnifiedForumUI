//
//  UFUIPageMenuView.h
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2021/12/9.
//

#import <UIKit/UIKit.h>

#import "UFUIPageView.h"

NS_ASSUME_NONNULL_BEGIN

@class UFUIPageMenuView;

// 数据源，定义了Menu的个数和每个Menu的内容
@protocol UFUIPageMenuViewDataSource <NSObject>

- (NSInteger)numberOfMenusInPageMenuView:(UFUIPageMenuView *)tabView;
- (NSString *)pageMenuView:(UFUIPageMenuView *)pageMenuView menuTitleAtIndex:(NSInteger)index;

@end

// 代理，点击某一个Menu时的处理，此时需要和PageView联动
@protocol UFUIPageMenuViewDelegate <NSObject>

- (void)tabView:(UFUIPageMenuView *)tabView didSelectIndex:(NSInteger)index;

@end

typedef NS_ENUM(NSInteger, UFUIPageMenuViewStyle) {
    UFUIPageMenuViewStyleFixed,
    UFUIPageMenuViewStyleWaterFlow
};

// 和PageView联动的菜单必须支持UFUIPageMenuViewProtocol协议
// 即当PageView翻页时，菜单必须做出相对应的反应
@interface UFUIPageMenuView : UIView <UFUIPageMenuViewProtocol>

// 把默认的初始化方法都禁了
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

// 必须用这个方法初始化。
// 数据源和代理必须设置，否则会出错
- (instancetype)initWithFrame:(CGRect)frame pageMenuViewDataSource:(id<UFUIPageMenuViewDataSource>)pageMenuViewDataSource pageMenuViewDelegate:(id<UFUIPageMenuViewDelegate>)pageMenuViewDelegate pageMenuViewStyle:(UFUIPageMenuViewStyle)pageMenuViewStyle;

// 数据源
@property (nonatomic, weak) id<UFUIPageMenuViewDataSource> pageMenuViewDataSource;

// 代理
@property (nonatomic, weak) id<UFUIPageMenuViewDelegate> pageMenuViewDelegate;

// 菜单风格
@property (nonatomic, assign) UFUIPageMenuViewStyle pageMenuViewStyle;

@end

NS_ASSUME_NONNULL_END
