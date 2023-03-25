//
//  UFMTimeLineModel.h
//  UnifiedForumModelParseImpl
//
//  Created by XueFeng Chen on 2023/2/19.
//

#import "UFMObjectModel.h"

@class UFMUserModel;
@class UFMTopicModel;
@class UFMPostModel;
@class UFMReplyModel;

NS_ASSUME_NONNULL_BEGIN

@interface UFMTimeLineModel : UFMObjectModel

// ID
@property (nonatomic, copy) NSString *timeLineId;

// 发布者信息
@property (nonatomic, strong) UFMUserModel *fromUserModel;

// Todo:这个待考虑
@property (nonatomic, strong) UFMUserModel *toUserModel;

// 动态类型
@property (nonatomic, copy) NSString *type;

@property (nonatomic, strong, nullable) UFMTopicModel *topicModel;

@property (nonatomic, strong, nullable) UFMPostModel *postModel;

@property (nonatomic, strong, nullable) UFMReplyModel *replyModel;

// 标记位：软删除
@property (nonatomic, assign) BOOL isDeleted;

// 发布日期
@property (nonatomic, strong) NSDate *createdAt;

@end

NS_ASSUME_NONNULL_END
