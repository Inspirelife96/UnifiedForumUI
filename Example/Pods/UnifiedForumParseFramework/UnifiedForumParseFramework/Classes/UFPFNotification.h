//
//  UFPFNotification.h
//  UFPFParse
//
//  Created by XueFeng Chen on 2022/5/20.
//

#import <Parse/Parse.h>

@class UFPFTopic;
@class UFPFPost;
@class UFPFReply;
@class UFPFMessageGroup;

NS_ASSUME_NONNULL_BEGIN

@interface UFPFNotification : PFObject <PFSubclassing>

@property (nonatomic, strong) PFUser *fromUser;
@property (nonatomic, strong) PFUser *toUser;

// 通知类型，包括
// UFPFNotificationTypeComment 评论
// UFPFNotificationTypeLike 赞和喜欢
// UFPFNotificationTypeMessage 关注
// UFPFNotificationTypeFollow 私信
// UFPFNotificationTypeOther 其他（管理员消息）
@property (nonatomic, strong) NSString *type;

// 通知子类型，包括
// UFPFNotificationSubTypeCommentTopic;
// UFPFNotificationSubTypeCommentPost;
// UFPFNotificationSubTypeCommentReply;
// UFPFNotificationSubTypeLikeTopic;
// UFPFNotificationSubTypeLikePost;
// UFPFNotificationSubTypeLikeReply;
// UFPFNotificationSubTypeOtherTopicIsNotApproved;
// UFPFNotificationSubTypeOtherPostIsNotApproved;
// UFPFNotificationSubTypeOtherReplyIsNotApproved;
@property (nonatomic, strong) NSString *subType;

@property (nonatomic, strong) UFPFTopic *topic;
@property (nonatomic, strong) UFPFPost *post;
@property (nonatomic, strong) UFPFReply *reply;

@property (nonatomic, strong) UFPFMessageGroup *messageGroup;

// 特例：每一个fromUser/toUser组合仅保留最新的一条数据。
// 如果组合不存在，则添加，如果组合存在，则更新。
//@property (nonatomic, strong) UFPFMessage *message;
//@property (nonatomic, strong) NSNumber *unreadMessageCount;

@end

NS_ASSUME_NONNULL_END
