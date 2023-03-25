//
//  UFUIObjectCell.h
//  INSParseUI
//
//  Created by XueFeng Chen on 2021/6/27.
//

#import <UIKit/UIKit.h>

@class UFUIObjectCellViewModel;

NS_ASSUME_NONNULL_BEGIN

@interface UFUIObjectCell : UITableViewCell

// 重要，持有CellVM
@property (nonatomic, strong) UFUIObjectCellViewModel *objectCellVM;

// 重要，指定Cell内用户交互的代理。
// 由各个子类自己定义具体的代理和API
@property (nonatomic, weak) id delegate;

// 根据CellVM对Cell的具体内容进行配置
- (void)configWithObjectCellViewModel:(UFUIObjectCellViewModel *)objectCellVM;

@end

NS_ASSUME_NONNULL_END
