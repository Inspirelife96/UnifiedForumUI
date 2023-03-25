//
//  UFMPostModel.h
//  Bolts
//
//  Created by XueFeng Chen on 2022/10/22.
//

#import "UFMObjectModel.h"

@class UFMTopicModel;
@class UFMFileModel;
@class UFMReplyModel;
@class UFMUserModel;

NS_ASSUME_NONNULL_BEGIN

@interface UFMPostModel : UFMObjectModel

// ID
@property (nonatomic, copy) NSString *postId;

// post内容，post没有title了
@property (nonatomic, copy) NSString *content;

// post可以有附加内容
@property (nonatomic, strong) NSArray<UFMFileModel *> *fileModelArray;
@property (nonatomic, copy) NSString *fileType;

// 针对post的部分回复，用于展示，上限5条
@property (nonatomic, strong) NSArray<UFMReplyModel *> *replyModelArray;

// 回复的总数
@property (nonatomic, assign) NSInteger replyCount;

// 点赞数
@property (nonatomic, assign) NSInteger likeCount;

// 是针对哪个Topic的评论
@property (nonatomic, strong) UFMTopicModel *toTopicModel;

// 创建时间
@property (nonatomic, strong) NSDate *createdAt;

// 标记位：是否许可，管理员可批准
@property (nonatomic, assign) BOOL isApproved;

// 标记位：软删除，作者可删除
@property (nonatomic, assign) BOOL isDeleted;

// 发布者
@property (nonatomic, strong) UFMUserModel *fromUserModel;

- (instancetype)initWithContent:(NSString *)content
                 fileModelArray:(NSArray<UFMFileModel *> * _Nullable)fileModelArray
                       fileType:(NSString *)fileType
                  fromUserModel:(UFMUserModel *)fromUserModel
                   toTopicModel:(UFMTopicModel *)topicModel
                          error:(NSError **)error;

- (void)save:(NSError **)error;

- (BOOL)isLikedByUserModel:(UFMUserModel *)userModel error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
