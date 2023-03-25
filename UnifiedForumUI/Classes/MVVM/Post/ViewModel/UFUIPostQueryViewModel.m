//
//  UFUIPostQueryViewModel.m
//  INSParseUI
//
//  Created by XueFeng Chen on 2021/7/5.
//

#import "UFUIPostQueryViewModel.h"

#import "UFMPostModel.h"

#import "UFUIPostCell.h"

#import "UFUIPostCellViewModel.h"

#import "UFUIPostQueryHeaderViewModel.h"

#import "UFUIPostQueryFooterViewModel.h"

#import "UFUIPostQueryFilterViewModel.h"

#import "UFUIPostQueryAddPostToTopicViewModel.h"

#import "UFUIPostQueryAddReplyToPostViewModel.h"

@interface UFUIPostQueryViewModel ()

@end

@implementation UFUIPostQueryViewModel

#pragma mark Init

- (instancetype)initWithTopicModel:(UFMTopicModel *)topicModel {
    if (self = [self init]) {
        self.topicModel = topicModel;
        
        self.postQueryHeaderVM = [[UFUIPostQueryHeaderViewModel alloc] initWithTopicModel:topicModel];
        
        self.postQueryFooterVM = [[UFUIPostQueryFooterViewModel alloc] initWithTopicModel:topicModel];
        
        self.postQueryFilterVM = [[UFUIPostQueryFilterViewModel alloc] init];
        
        self.addPostVM = [[UFUIPostQueryAddPostToTopicViewModel alloc] initWithTopicModel:topicModel];
        
        // 唯独这个需要指定PostCellVM
        self.addReplyVM = nil;

        // 父类的成员，在这里必须设置，此时已经知道对应的Cell有哪些
        self.objectCellClassArray = @[
            [UFUIPostCell class]
        ];
        
        // 具体的Query API，根据条件不同可以进行修改
        // Todo:warning!这种写法会不会在多线程中引起冲突，需要观察测试！
        WEAKSELF
        self.queryBlock = ^NSArray * _Nonnull(NSError *__autoreleasing  _Nullable * _Nullable error) {
            STRONGSELF
            BOOL isOrderByAscending = YES;
            if (self.postQueryFilterVM.postQueryOrderType == UFUIPostQueryOrderTypeDescend) {
                isOrderByAscending = NO;
            }
            
            if (self.postQueryFilterVM.postQueryFilterType == UFUIPostQueryFilterTypeAll) {
                return [UFMService findPostModelArrayToTopic:strongSelf.topicModel orderBy:@"createdAt" isOrderByAscending:isOrderByAscending page:strongSelf.currentPage pageCount:strongSelf.objectsPerPage error:error];
            } else {
                return [UFMService findPostModelArrayToTopic:strongSelf.topicModel fromUserModel:strongSelf.topicModel.fromUserModel orderBy:@"createdAt" isOrderByAscending:isOrderByAscending page:strongSelf.currentPage pageCount:strongSelf.objectsPerPage error:error];
            }
        };
    }
    
    return self;
}


#pragma mark Public Methods

//- (void)addPost:(UFMPostModel *)postModel {
//    if (self.postQueryFilterVM.postQueryFilterType == UFUIPostQueryFilterTypeAll) {
//        if (self.postQueryFilterVM.postQueryOrderType == UFUIPostQueryOrderTypeDescend) {
//            // 如果是全部显示，那么当逆序排列时，直接添加到CellVM的顶部
//        } else {
//            // 如果是全部显示，当顺序排列时
//            // - 如果数据已经全部加在完毕，那么直接把新的
//            if (self.lastLoadCount < self.objectsPerPage)
//            
//            
//        }
//    } else {
//        if ([self.topicModel.fromUserModel isEqualToUserModel:[UFMService currentUserModel]]) {
//            // 如果是只显示楼主且当前用户是楼主，则需要考虑将新添加的Post显示到TableView中
//            
//        } else {
//            // 否则什么都不用做
//        }
//    }
//}

- (Class)objectCellViewModelClassForObjectModel:(UFMObjectModel *)objectModel {
    return [UFUIPostCellViewModel class];
}

- (void)likeTopicInBackgroundWithBlock:(void(^)(NSError *_Nullable error))block {
    [self.postQueryFooterVM likeTopicInBackgroundWithBlock:block];
}

- (void)shareTopicToPlatformInBackgound:(NSString *)toPlatform withBlock:(void(^)(NSError *_Nullable error))block {
    [self.postQueryFooterVM shareTopicToPlatformInBackgound:toPlatform withBlock:block];
}

- (void)changeIsFollowedByCurrentUserInbackgroundWithBlock:(void(^)(NSError *_Nullable error))block {
    [self.postQueryHeaderVM changeIsFollowedByCurrentUserInbackgroundWithBlock:block];
}

// 添加评论
- (void)addPostInBackground:(void(^)(NSError *error))block {
    [self.addPostVM addPostInBackground:block];
}

// 添加回复
- (void)addReplyInBackground:(void(^)(NSError *error))block {
    [self.addReplyVM addReplyInBackground:block];
}

#pragma mark Private Methods

                                                            
#pragma mark Getter/Setter


- (void)filterToAll {
    self.postQueryFilterVM.postQueryFilterType = UFUIPostQueryFilterTypeAll;
//    WEAKSELF
//    self.queryBlock = ^NSArray * _Nonnull(NSError *__autoreleasing  _Nullable * _Nullable error) {
//        STRONGSELF
//        return [UFMService findPostModelArrayToTopic:strongSelf.topicModel orderBy:@"createdAt" page:strongSelf.currentPage pageCount:strongSelf.objectsPerPage error:error];
//    };
}

- (void)filterToTopicHostOnly {
    self.postQueryFilterVM.postQueryFilterType = UFUIPostQueryFilterTypeTopicHostOnly;
//    WEAKSELF
//    self.queryBlock = ^NSArray * _Nonnull(NSError *__autoreleasing  _Nullable * _Nullable error) {
//        STRONGSELF
//        return [UFMService findPostModelArrayToTopic:strongSelf.topicModel fromUserModel:strongSelf.topicModel.fromUserModel orderBy:@"createdAt" page:strongSelf.currentPage pageCount:strongSelf.objectsPerPage error:error];
//    };
}

- (void)ascend {
    self.postQueryFilterVM.postQueryOrderType = UFUIPostQueryOrderTypeAscend;
//    WEAKSELF
//    self.queryBlock = ^NSArray * _Nonnull(NSError *__autoreleasing  _Nullable * _Nullable error) {
//        STRONGSELF
//        return [UFMService findPostModelArrayToTopic:strongSelf.topicModel fromUserModel:strongSelf.topicModel.fromUserModel orderBy:@"createdAt" page:strongSelf.currentPage pageCount:strongSelf.objectsPerPage error:error];
//    };
}

- (void)descend {
    self.postQueryFilterVM.postQueryOrderType = UFUIPostQueryOrderTypeDescend;
//    WEAKSELF
//    self.queryBlock = ^NSArray * _Nonnull(NSError *__autoreleasing  _Nullable * _Nullable error) {
//        STRONGSELF
//        return [UFMService findPostModelArrayToTopic:strongSelf.topicModel fromUserModel:strongSelf.topicModel.fromUserModel orderBy:@"createdAt" page:strongSelf.currentPage pageCount:strongSelf.objectsPerPage error:error];
//    };
}

//- (void)setIsAsending:(BOOL)isAsending {
//    _isAsending = isAsending;
//    WEAKSELF
//    self.queryBlock = ^NSArray * _Nonnull(NSError *__autoreleasing  _Nullable * _Nullable error) {
//        STRONGSELF
//        return [UFMService findPostModelArrayToTopic:strongSelf.topicModel orderBy:@"createdAt" page:strongSelf.currentPage pageCount:strongSelf.objectsPerPage error:error];
//    };
//}
//
//- (void)setIsOwnerOnly:(BOOL)isOwnerOnly {
//    _isOwnerOnly = isOwnerOnly;
//    WEAKSELF
//    self.queryBlock = ^NSArray * _Nonnull(NSError *__autoreleasing  _Nullable * _Nullable error) {
//        STRONGSELF
//        return [UFMService findPostModelArrayToTopic:strongSelf.topicModel orderBy:@"createdAt" page:strongSelf.currentPage pageCount:strongSelf.objectsPerPage error:error];
//    };
//}

@end
