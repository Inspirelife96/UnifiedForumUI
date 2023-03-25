//
//  UFUITopicQueryViewModel.m
//  INSParseUI
//
//  Created by XueFeng Chen on 2021/6/27.
//

#import "UFUITopicQueryViewModel.h"

#import "UFUIConstants.h"

#import "UFMTopicModel.h"

#import "UFUITopicCell.h"
#import "UFUITopicCellViewModel.h"

@implementation UFUITopicQueryViewModel

- (instancetype)init {
    if (self = [super init]) {
        // 重写objectCellClassStringArray，指定为最终映射的Cell为UFUITopicCell类型
        self.objectCellClassArray = @[
            [UFUITopicCell class]
        ];
    }
    
    return self;
}

- (instancetype)initQueryTopicWithOrderBy:(NSString *)orderBy {
    if (self = [self init]) {
        WEAKSELF
        self.queryBlock = ^NSArray * _Nonnull(NSError *__autoreleasing  _Nullable * _Nullable error) {
            STRONGSELF
            return [UFMService findTopicModelArrayOrderBy:orderBy isOrderByAscending:NO page:strongSelf.currentPage  pageCount:strongSelf.objectsPerPage error:error];
        };
    }
    
    return self;
}

- (instancetype)initQueryTopicWithCreatedByUserModel:(UFMUserModel *)userModel {
    if (self = [self init]) {
        WEAKSELF
        self.queryBlock = ^NSArray * _Nonnull(NSError *__autoreleasing  _Nullable * _Nullable error) {
            STRONGSELF
            return [UFMService findTopicModelArrayCreatedByUserModel:userModel orderBy:@"createdAt" isOrderByAscending:NO page:strongSelf.currentPage pageCount:strongSelf.objectsPerPage error:error];
        };
    }
    
    return self;
}


- (instancetype)initQueryTopicWithCategory:(NSString *)category {
    if (self = [self init]) {
        WEAKSELF
        self.queryBlock = ^NSArray * _Nonnull(NSError *__autoreleasing  _Nullable * _Nullable error) {
            STRONGSELF
            return [UFMService findTopicModelArrayWithCategory:category orderBy:@"createdAt" isOrderByAscending:NO page:strongSelf.currentPage  pageCount:strongSelf.objectsPerPage error:error];
        };
    }
    
    return self;
}

- (instancetype)initQueryTopicWithFollowedByUser:(UFMUserModel *)userModel {
    if (self = [self init]) {
        WEAKSELF
        self.queryBlock = ^NSArray * _Nonnull(NSError *__autoreleasing  _Nullable * _Nullable error) {
            STRONGSELF
            return [UFMService findTopicModelArrayFollowedByUserModel:userModel orderBy:@"createdAt" isOrderByAscending:NO page:strongSelf.currentPage  pageCount:strongSelf.objectsPerPage error:error];
        };
    }
    
    return self;
}

- (instancetype)initQueryTopicWithTag:(NSString *)tag {
    if (self = [self init]) {
        WEAKSELF
        self.queryBlock = ^NSArray * _Nonnull(NSError *__autoreleasing  _Nullable * _Nullable error) {
            STRONGSELF
            return [UFMService findTopicModelArrayWithTag:tag orderBy:@"createdAt" isOrderByAscending:NO page:strongSelf.currentPage  pageCount:strongSelf.objectsPerPage error:error];
        };
    }
    
    return self;
}

- (Class)objectCellViewModelClassForObjectModel:(UFMObjectModel *)objectModel {
    return [UFUITopicCellViewModel class];
}

@end
