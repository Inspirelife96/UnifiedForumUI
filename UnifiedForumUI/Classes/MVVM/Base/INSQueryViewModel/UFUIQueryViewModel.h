//
//  UFUIQueryViewModel.h
//  INSParseUI
//
//  Created by XueFeng Chen on 2021/6/26.
//

#import <Foundation/Foundation.h>

@class UFUIObjectCellViewModel;
@class UFMObjectModel;

typedef NS_ENUM(NSInteger, UFUIQueryStatus) {
    UFUIQueryStatusNotStart,
    UFUIQueryStatusWorking,
    UFUIQueryStatusDone
};

NS_ASSUME_NONNULL_BEGIN

typedef NSArray * _Nonnull (^QueryBlock)(NSError **error);

@interface UFUIQueryViewModel : NSObject

// 所有的Cell列表，这个是为了注册用Cell用，必须设置
@property (nonatomic, strong) NSArray<Class> *objectCellClassArray;

// 查询语句，返回UFMObjectModel的数组，必须设置
@property (nonatomic, copy) QueryBlock queryBlock;

// 目标: cell数据模型，最终生成Cell模型的数组
@property (nonatomic, strong) NSArray<UFUIObjectCellViewModel *> *objectCellVMArray;

// 分页
@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, assign) NSUInteger objectsPerPage;

// 总计
@property (nonatomic, assign) NSUInteger lastLoadCount;
@property (nonatomic, assign) NSUInteger totalLoadCount;

// 空数据时的处理，Lottie支持
@property (nonatomic, strong) NSString *queryResultLottie;
@property (nonatomic, strong) NSString *queryResultDescription;

// 当前的处理状态
@property (nonatomic, assign) UFUIQueryStatus queryStatus;

// 提供模型-》Cell模型的映射，自定义子类时，必须实现
// 为什么提供API而不是成员变量？因为objectModel可能需要映射成不同的Cell，所以需要不同的CellViewModel来对应。
- (Class)objectCellViewModelClassForObjectModel:(UFMObjectModel *)objectModel;

// 加载首页数据
- (void)loadFirstPageInBackgroundSuccess:(nullable void (^)(void))success
                                 failure:(nullable void (^)(NSError *error))failure;

// 加载下一页数据
- (void)loadNextPageInBackgroundSuccess:(nullable void (^)(void))success
                                failure:(nullable void (^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
