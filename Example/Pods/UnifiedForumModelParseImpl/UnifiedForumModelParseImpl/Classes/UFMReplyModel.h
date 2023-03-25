//
//  UFMReplyModel.h
//  Bolts
//
//  Created by XueFeng Chen on 2022/10/22.
//

#import "UFMObjectModel.h"

@class UFMPostModel;
@class UFMReplyModel;
@class UFMUserModel;

NS_ASSUME_NONNULL_BEGIN

@interface UFMReplyModel : UFMObjectModel

// ID
@property (nonatomic, copy) NSString *replyId;

// 回复内容，Reply仅能包含文字，没有标题，且不允许包含其他附件内容
@property (nonatomic, copy) NSString *content;

// 点赞数
@property (nonatomic, assign) NSInteger likeCount;

// 针对哪个Post的回复，这里我们不再转化为PostModel，
// 否则会出现PostModel持有ReplyModel，ReplyModel又持有PostModel的死循环
@property (nonatomic, copy) NSString *toPostId;

// 针对哪个Reply的回复，这是由于存在针对回复的回复
@property (nonatomic, copy, nullable) NSString *toReplyId;

// 发布者
@property (nonatomic, strong) UFMUserModel *fromUserModel;

// 针对谁的回复
@property (nonatomic, strong) UFMUserModel *toUserModel;

// 创建时间
@property (nonatomic, strong) NSDate *createdAt;

// 标记位：是否许可，管理员可批准
@property (nonatomic, assign) BOOL isApproved;

// 标记位：软删除，作者可删除
@property (nonatomic, assign) BOOL isDeleted;

// 从UI创建新的时候，toPostModel和toReplyModel是知道的
- (instancetype)initWithContent:(NSString *)content
                  fromUserModel:(UFMUserModel *)fromUserModel
                    toPostModel:(UFMPostModel *)toPostModel
                   toReplyModel:(UFMReplyModel *)toReplyModel
                          error:(NSError **)error;

- (void)save:(NSError **)error;

- (BOOL)isLikedByUserModel:(UFMUserModel *)userModel error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
