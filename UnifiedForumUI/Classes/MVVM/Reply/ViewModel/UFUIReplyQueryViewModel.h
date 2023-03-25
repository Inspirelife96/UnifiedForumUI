//
//  UFUIReplyQueryViewModel.h
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2023/2/18.
//

#import "UFUIQueryViewModel.h"

@class UFUIReplyQueryHeaderViewModel;
@class UFUIReplyQueryAddReplyToPostViewModel;
@class UFUIReplyQueryAddReplyToReplyViewModel;

NS_ASSUME_NONNULL_BEGIN

@interface UFUIReplyQueryViewModel : UFUIQueryViewModel

// 持有postModel，因为是展示这个Post的Reply
@property (nonatomic, strong) UFMPostModel *postModel;

// 顶部展示Topic的主要内容，由UFUIPostQueryHeaderViewModel负责视图模型
@property (nonatomic, strong) UFUIReplyQueryHeaderViewModel *replyQueryHeaderVM;

// 添加AddReplyToPostView的视图模型
@property (nonatomic, strong, nullable) UFUIReplyQueryAddReplyToPostViewModel *addReplyToPostVM;

// 添加AddReplyToReplyView的视图模型
@property (nonatomic, strong, nullable) UFUIReplyQueryAddReplyToReplyViewModel *addReplyToReplyVM;

- (instancetype)initWithPostModel:(UFMPostModel *)postModel;

@end

NS_ASSUME_NONNULL_END
