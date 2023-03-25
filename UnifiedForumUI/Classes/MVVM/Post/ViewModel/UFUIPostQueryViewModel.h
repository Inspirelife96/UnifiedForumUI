//
//  UFUIPostQueryViewModel.h
//  INSParseUI
//
//  Created by XueFeng Chen on 2021/7/5.
//

#import "UFUIQueryViewModel.h"

#import "UFUIConstants.h"

@class UFMTopicModel;
@class UFUIImageFileCellViewModel;
@class YBIBImageData;

@class UFUIPostQueryHeaderViewModel;
@class UFUIPostQueryFooterViewModel;
@class UFUIPostQueryAddPostToTopicViewModel;
@class UFUIPostQueryAddReplyToPostViewModel;
@class UFUIPostQueryFilterViewModel;

NS_ASSUME_NONNULL_BEGIN

@interface UFUIPostQueryViewModel : UFUIQueryViewModel

// 除去继承自UFUIQueryViewModel，对TableView的内容进行处理之外

// 持有TopicModel，因为是展示这个Topic的Post
@property (nonatomic, strong) UFMTopicModel * topicModel;

// 顶部展示Topic的主要内容，由UFUIPostQueryHeaderViewModel负责视图模型
@property (nonatomic, strong) UFUIPostQueryHeaderViewModel *postQueryHeaderVM;

// 底部展示Topic的交互内容，由UFUIPostQueryFooterViewModel负责视图模型
@property (nonatomic, strong) UFUIPostQueryFooterViewModel *postQueryFooterVM;

// filter的视图模型，负责filter的选项
@property (nonatomic, strong) UFUIPostQueryFilterViewModel *postQueryFilterVM;

// 添加Post的视图模型
@property (nonatomic, strong) UFUIPostQueryAddPostToTopicViewModel *addPostVM;

// 添加Reply的视图模型
@property (nonatomic, strong, nullable) UFUIPostQueryAddReplyToPostViewModel *addReplyVM;

- (instancetype)initWithTopicModel:(UFMTopicModel *)topicModel;

// 可以作为讨论点，新功能
//- (void)addPost:(UFMPostModel *)postModel;

//// 点赞
//- (void)likeTopicInBackgroundWithBlock:(void(^)(NSError *_Nullable error))block;
//
//// 分享
//- (void)shareTopicToPlatformInBackgound:(NSString *)toPlatform withBlock:(void(^)(NSError *_Nullable error))block;
//
//// 点击关注用户
//- (void)changeIsFollowedByCurrentUserInbackgroundWithBlock:(void(^)(NSError *_Nullable error))block;
//
//// 添加评论
//- (void)addPostInBackground:(void(^)(NSError *error))block;
//
//// 添加回复
//- (void)addReplyInBackground:(void(^)(NSError *error))block;
//
//// filter相关操作
//- (void)filterToAll;
//- (void)filterToTopicHostOnly;
//- (void)ascend;
//- (void)descend;

@end

NS_ASSUME_NONNULL_END
