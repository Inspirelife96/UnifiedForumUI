//
//  UFUIQueryViewModel.m
//  INSParseUI
//
//  Created by XueFeng Chen on 2021/6/26.
//

#import "UFUIQueryViewModel.h"

#import "UFUIConstants.h"

#import "UFUIObjectCell.h"
#import "UFUIObjectCellViewModel.h"

#import "UFMObjectModel.h"

@interface UFUIQueryViewModel ()

//@property (nonatomic, strong, readwrite) NSArray<UFUIObjectCellViewModel *> *objectCellVMArray;

@end

@implementation UFUIQueryViewModel

- (instancetype)init {
    if (self = [super init]) {
        _objectCellClassArray = @[
            [UFUIObjectCell class]
        ];
        
        _queryBlock = ^NSArray * _Nonnull(NSError *__autoreleasing  _Nullable * _Nullable error) {
            return @[];
        };
        
        // 初始值
        _objectCellVMArray = @[];

        // 初始值
        _currentPage = 0;
        _objectsPerPage = 5;
        
        // 初始值
        _lastLoadCount = 0;
        _totalLoadCount = 0;
                
        // 初始值
        _queryResultLottie = @"default_lottie";
        _queryResultDescription = @"";
        
        // 初始值
        _queryStatus = UFUIQueryStatusNotStart;
    }
    
    return self;
}

- (void)loadFirstPageInBackgroundSuccess:(nullable void (^)(void))success
                                 failure:(nullable void (^)(NSError *error))failure {
    // 加载第一页的话，就重制所有内容
    _currentPage = 0;
    _lastLoadCount = 0;
    _totalLoadCount = 0;
    
    [self loadDataInBackgroundSuccess:^{
        success();
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)loadNextPageInBackgroundSuccess:(nullable void (^)(void))success
                                failure:(nullable void (^)(NSError *error))failure {
    // 页数+1
    _currentPage++;
    
    [self loadDataInBackgroundSuccess:^{
        success();
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)loadDataInBackgroundSuccess:(nullable void (^)(void))success
                            failure:(nullable void (^)(NSError *error))failure {
    WEAKSELF
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        STRONGSELF
        
        NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
        
        // 当前如果不是第一页，copy已经获取的数据
        if (strongSelf.currentPage != 0) {
            [mutableArray addObjectsFromArray:strongSelf.objectCellVMArray];
        }
        
        NSError *error = nil;
        
        // 开始处理
        strongSelf.queryStatus = UFUIQueryStatusWorking;

        // 执行查询，由子类自己定义需要查询的内容
        NSArray *lastLoadArray = strongSelf.queryBlock(&error);
        
        if (error) {
            // 出错了，则啥都不做
        } else {
            // 成功的话
            // 将查询的数据转成CellViewModel，追加到objectCellVMArray数组尾部
            for (NSInteger i = 0; i < lastLoadArray.count; i++) {
                UFMObjectModel *objectModel = lastLoadArray[i];
                
                // 核心代码，objectCellViewModelClassForObjectModel由子类实现
                // 根据返回的ObjectModel的类型，来确定需要生成的ObjectViewModel的类型
                Class objectCellViewModelClass = [strongSelf objectCellViewModelClassForObjectModel:objectModel];
                
                // 生成ObjectViewModel并添加到数组尾部
                UFUIObjectCellViewModel *objectCellVM = [[objectCellViewModelClass alloc] initWithObjectModel:objectModel];
                [mutableArray addObject:objectCellVM];
            }
        }

        strongSelf.queryStatus = UFUIQueryStatusDone;

        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                strongSelf.queryResultDescription = KUFUILocalization(@"queryView.result.description.failed");
                strongSelf.queryResultLottie = @"error_lottie";
                failure(error);
            } else {
                // 更新Table的数据源，必须放入主线程中。
                // 如果在子线程中更行，容易导致table刷新过程中，对应的数据源被更新，而导致crash。
                strongSelf.objectCellVMArray = [mutableArray copy];
                strongSelf.lastLoadCount = lastLoadArray.count;
                strongSelf.totalLoadCount = strongSelf.objectCellVMArray.count;
                
                // 如果是没有查询到任何内容，设置空内容
                if (strongSelf.totalLoadCount == 0) {
                    strongSelf.queryResultDescription = KUFUILocalization(@"queryView.result.description.empty");
                    strongSelf.queryResultLottie = @"empty_lottie";
                }

                success();
            }
        });
    });
}

- (Class)objectCellViewModelClassForObjectModel:(UFMObjectModel *)objectModel {
    return [UFUIObjectCellViewModel class];
}

@end
