//
//  UFUIObjectCellViewModel.h
//  INSParseUI
//
//  Created by XueFeng Chen on 2022/2/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class UFMObjectModel;

@interface UFUIObjectCellViewModel : NSObject

// 重要，持有数据模型
@property (nonatomic, strong) UFMObjectModel *objectModel;

// 重要，子类初始化时必须设定。
// CellViewModel和Cell一一对应，在子类根据UFMObjectModel对象初始化时，肯定是知道这个VM对应的Cell是什么的。
@property (nonatomic, copy) NSString *cellIdentifier;

// 重要，在Cell和CellViewModel绑定前必须设定。
// 一般在(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath代理中进行设置
@property (nonatomic, strong) NSIndexPath *indexPath;

// 初始化，必须由UFMObjectModel进行初始化
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)new NS_UNAVAILABLE;
- (instancetype)initWithObjectModel:(UFMObjectModel *)objectModel NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
