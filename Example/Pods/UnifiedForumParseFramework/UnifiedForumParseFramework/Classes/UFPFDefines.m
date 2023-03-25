//
//  UFPFDefines.m
//  UFPFParse
//
//  Created by XueFeng Chen on 2021/6/22.
//

#import "UFPFDefines.h"

NSString *const UFPFTimeLineTypeAddTopic = @"Add Topic";
NSString *const UFPFTimeLineTypeAddPost = @"Add Post";
NSString *const UFPFTimeLineTypeAddReply = @"Add Reply";
NSString *const UFPFTimeLineTypeLikeTopic = @"Like Topic";
NSString *const UFPFTimeLineTypeLikePost = @"Like Post";
NSString *const UFPFTimeLineTypeLikeReply = @"Like Reply";
NSString *const UFPFTimeLineTypeReportTopic = @"Report Topic";
NSString *const UFPFTimeLineTypeReportPost = @"Report Post";
NSString *const UFPFTimeLineTypeReportReply = @"Report Reply";
NSString *const UFPFTimeLineTypeFollow = @"Follow";
//NSString *const UFPFTimeLineTypeUnfollow = @"Unfollow";

NSString *const UFPFNotificationTypeComment = @"Comment";
NSString *const UFPFNotificationTypeLike = @"Like";
NSString *const UFPFNotificationTypeMessage = @"Message";
NSString *const UFPFNotificationTypeFollow = @"Follow";
NSString *const UFPFNotificationTypeOther = @"Other";

NSString *const UFPFNotificationSubTypeNone = @"None";
NSString *const UFPFNotificationSubTypeCommentTopic = @"Comment Topic";
NSString *const UFPFNotificationSubTypeCommentPost = @"Comment Post";
NSString *const UFPFNotificationSubTypeCommentReply = @"Comment Reply";
NSString *const UFPFNotificationSubTypeLikeTopic = @"Like Topic";
NSString *const UFPFNotificationSubTypeLikePost = @"Like Post";
NSString *const UFPFNotificationSubTypeLikeReply = @"Like Reply";
NSString *const UFPFNotificationSubTypeOtherTopicIsNotApproved = @"Topic Is Not Approved";
NSString *const UFPFNotificationSubTypeOtherPostIsNotApproved = @"Post Is Not Approved";
NSString *const UFPFNotificationSubTypeOtherReplyIsNotApproved = @"Reply Is Not Approved";

// PFObject 表自带下面四个字段，所以下面的所有其他表都自带这四个字段

NSString *const UFPFKeyObjectId = @"objectId";
NSString *const UFPFKeyCreatedAt = @"createdAt";
NSString *const UFPFKeyUpdatedAt = @"updateAt";
NSString *const UFPFKeyACL = @"ACL";

# pragma mark - Installtion 表

// 表名为：_Installation，系统默认定了如下字段，你可以在 PFInstallationConstants中找到他们的定义
//
// NSString *const PFInstallationKeyParseVersion = @"parseVersion";
// NSString *const PFInstallationKeyDeviceType = @"deviceType";
// NSString *const PFInstallationKeyInstallationId = @"installationId";
// NSString *const PFInstallationKeyDeviceToken = @"deviceToken";
// NSString *const PFInstallationKeyAppName = @"appName";
// NSString *const PFInstallationKeyAppVersion = @"appVersion";
// NSString *const PFInstallationKeyAppIdentifier = @"appIdentifier";
// NSString *const PFInstallationKeyTimeZone = @"timeZone";
// NSString *const PFInstallationKeyLocaleIdentifier = @"localeIdentifier";
// NSString *const PFInstallationKeyBadge = @"badge";
// NSString *const PFInstallationKeyChannels = @"channels";

// 需要追加的定义

// Class key
NSString *const PFInstalltionKeyClass = @"_Installation";

// Field keys
NSString *const UFPFInstalltionKeyLinkedUser = @"linkedUser";

#pragma mark - User 表

// User 表 ： 用户表，由Parse Server提供，除了默认的字段之外，需要额外添加一些字段。

// Class key
NSString *const PFUserKeyClass = @"_User";

// Field keys

// 系统提供的字段
//NSString *const PFUserKeyEmailVerified = @"emailVerified";
//NSString *const PFUserKeyAuthData = @"authData";
//NSString *const PFUserKeyUserName = @"userName";
//NSString *const PFUserKeyPassword = @"password";
//NSString *const PFUserKeyEmail = @"email";

// 自定义字段
NSString *const UFPFUserKeyIsLocked = @"isLocked";
NSString *const UFPFUserKeyIsDeleted = @"isDeleted";
NSString *const UFPFUserKeyStatisticsInfo = @"statisticsInfo";
NSString *const UFPFUserKeyAvatar = @"avatar";
NSString *const UFPFUserKeyBackgroundImage = @"backgroundImage";
NSString *const UFPFUserKeyBio = @"bio";
NSString *const UFPFUserKeyBadgeCount = @"badgeCount";
NSString *const UFPFUserKeyPreferredLanguage = @"preferredLanguage";

# pragma mark - Topics 表

// Topics 表 ： 主题

// Class key
NSString *const UFPFTopicKeyClass = @"Topic";

// Field keys

// 标记
NSString *const UFPFTopicKeyIsLocked = @"isLocked";
NSString *const UFPFTopicKeyIsDeleted = @"isDeleted";
NSString *const UFPFTopicKeyIsPrivate = @"isPrivate";
NSString *const UFPFTopicKeyIsApproved = @"isApproved";
NSString *const UFPFTopicKeyIsPopular = @"isPopular";

// 核心字段：
NSString *const UFPFTopicKeyTitle = @"title"; // 标题 （NSString）
NSString *const UFPFTopicKeyContent = @"comtent"; // 内容（NSString）
NSString *const UFPFTopicKeyMediaFileObjects = @"mediaFileObjects"; // 图片，可多图 (NSArray<PFFile *>)
NSString *const UFPFTopicKeyMediaFileType = @"mediaFileType";
NSString *const UFPFTopicKeyFromUser = @"fromUser"; // 创建者（PFUser）

// 统计字段：
NSString *const UFPFTopicKeyPostCount = @"postCount"; // 回帖数（NSNumber）
NSString *const UFPFTopicLikeKeyCount = @"likeCount"; // 点赞数（NSNumber）
NSString *const UFPFTopicKeyShareCount = @"shareCount"; // 分享数（NSNumber）

// 板块/话题：
NSString *const UFPFTopicKeyCategory = @"category"; // 标签 （UFPFCategory）
NSString *const UFPFTopicKeyTags = @"tags"; // 标签 （NSArray）

# pragma mark - Posts 表

// Posts 表 ： 回帖

// Class key
NSString *const UFPFPostKeyClass = @"Post";

// Field keys

// 标记
NSString *const UFPFPostKeyIsLocked = @"isLocked";
NSString *const UFPFPostKeyIsApproved = @"isApproved";
NSString *const UFPFPostKeyIsDeleted = @"isDeleted";

// 核心内容
NSString *const UFPFPostKeyContent = @"content";
NSString *const UFPFPostKeyMediaFileObjects = @"mediaFileObjects";
NSString *const UFPFPostKeyMediaFileType = @"mediaFileType";
NSString *const UFPFPostKeyReplies = @"replies";

// 统计字段：
NSString *const UFPFPostKeyReplyCount = @"replyCount";
NSString *const UFPFPostLikeKeyCount = @"likeCount";

// 关系
NSString *const UFPFPostKeyFromUser = @"fromUser";
NSString *const UFPFPostKeyToTopic = @"toTopic";

# pragma mark - Replies 表

// Replies 表 ： 回复表 指用户针对回帖发表的内容，只能是文字。

// Class key
NSString *const UFPFReplyKeyClass = @"Reply";

// Field keys

// 标记
NSString *const UFPFReplyKeyIsLocked = @"isLocked";
NSString *const UFPFReplyKeyIsApproved = @"isApproved";
NSString *const UFPFReplyKeyIsDeleted = @"isDeleted";

// 核心内容
NSString *const UFPFReplyKeyContent = @"content";

// 统计字段：
NSString *const UFPFReplyLikeKeyCount = @"likeCount";

// 关系
NSString *const UFPFReplyKeyFromUser = @"fromUser";
NSString *const UFPFReplyKeyToPost = @"toPost";
NSString *const UFPFReplyKeyToReply = @"toReply";

# pragma mark - Categories 表

// Categories 表 ： 板块

// Class key
NSString *const UFPFCategoryKeyClass = @"Category";

// Field keys
NSString *const UFPFCategoryKeyName = @"name";

# pragma mark - Tags 表

// Tags 表 ： 标签

// Class key
NSString *const UFPFTagKeyClass = @"Tag";

// Field keys
NSString *const UFPFTagKeyName = @"name";

# pragma mark - TopicLikes 表

// TopicLikes 表 ：主题点赞

// Class key
NSString *const UFPFTopicLikeKeyClass = @"TopicLike";

// Field keys
NSString *const UFPFTopicLikeKeyFromUser = @"fromUser";
NSString *const UFPFTopicLikeKeyToTopic = @"toTopic";
NSString *const UFPFTopicLikeKeyIsDeleted = @"isDeleted";

# pragma mark - PostLikes 表

// PostLikes 表 ：回帖点赞

// Class key
NSString *const UFPFPostLikeKeyClass = @"PostLike";

// Field keys
NSString *const UFPFPostLikeKeyFromUser = @"fromUser";
NSString *const UFPFPostLikeKeyToPost = @"toPost";
NSString *const UFPFPostLikeKeyIsDeleted = @"isDeleted";

# pragma mark - ReplyLikes 表

// ReplyLikes 表 ：回复点赞

// Class key
NSString *const UFPFReplyLikeKeyClass = @"ReplyLike";

// Field keys
NSString *const UFPFReplyLikeKeyFromUser = @"fromUser";
NSString *const UFPFReplyLikeKeyToReply = @"toReply";
NSString *const UFPFReplyLikeKeyIsDeleted = @"isDeleted";

# pragma mark - TopicReports 表

// TopicReports 表 ：主题举报

// Class key
NSString *const UFPFTopicReportKeyClass = @"TopicReport";

// Field keys
NSString *const UFPFTopicReportKeyFromUser = @"fromUser";
NSString *const UFPFTopicReportKeyToTopic = @"toTopic";

# pragma mark - PostReports 表

// PostReports 表 ：回帖举报

// Class key
NSString *const UFPFPostReportKeyClass = @"PostReport";

// Field keys
NSString *const UFPFPostReportKeyFromUser = @"fromUser";
NSString *const UFPFPostReportKeyToPost = @"toPost";

# pragma mark - ReplyReports 表

// ReplyReports 表 ：回复举报

// Class key
NSString *const UFPFReplyReportKeyClass = @"ReplyReport";

// Field keys
NSString *const UFPFReplyReportKeyFromUser = @"fromUser";
NSString *const UFPFReplyReportKeyToReply = @"toReply";


# pragma mark - Shares 表

// Shares 表 指用户分享Topic

// Class key
NSString *const UFPFShareKeyClass = @"Share";

// Field keys
NSString *const UFPFShareKeyTopic = @"topic"; // 分享的Topic
NSString *const UFPFShareKeyFromUser = @"fromUser"; // 谁分享的
NSString *const UFPFShareKeyToPlatform = @"toPlatform"; // 分享到什么地方了

# pragma mark - Follows 表

// Follows 表： 指用户之间的关系

// Class key
NSString *const UFPFFollowKeyClass = @"Follow";

// Field keys
NSString *const UFPFFollowKeyFromUser = @"fromUser"; // 关注
NSString *const UFPFFollowKeyToUser = @"toUser"; // 被关注
NSString *const UFPFFollowKeyIsDeleted = @"isDeleted"; // 被关注


# pragma mark - Blocks 表

// Blocks 表： 黑名单表

// Class key
NSString *const UFPFBlockKeyClass = @"Block";

// Field keys
NSString *const UFPFBlockKeyFromUser = @"fromUser"; // 发起者
NSString *const UFPFBlockKeyToUser = @"toUser"; // 黑名单用户


# pragma mark - Notifications 表

// Notifications 表 该表每存入一条记录（后台就会发送一条推送给消息接受者）

// Class key
NSString *const UFPFTimeLineKeyClass = @"TimeLine";

NSString *const UFPFTimeLineKeyFromUser = @"fromUser"; // 消息发送者
NSString *const UFPFTimeLineKeyToUser = @"toUser"; // 消息接受者
NSString *const UFPFTimeLineKeyType = @"type";
NSString *const UFPFTimeLineKeyTopic = @"topic";
NSString *const UFPFTimeLineKeyPost = @"post";
NSString *const UFPFTimeLineKeyReply = @"reply";
NSString *const UFPFTimeLineKeyIsDeleted = @"isDeleted";


# pragma mark - StatisticsInfos 表

// StatisticsInfos表 User表创建StatisticsInfo字段和其关联，方便读取用户的关注/粉丝/Topic数/获得的赞等统计记录记录。

// Class key
NSString *const UFPFStatisticsInfoKeyClass = @"StatisticsInfo";

// Field keys
NSString *const UFPFStatisticsInfoKeyUser = @"user"; // 用户
NSString *const UFPFStatisticsInfoKeyProfileviews = @"profileViews"; // 用户
NSString *const UFPFStatisticsInfoKeyReputation = @"reputation"; // 用户
NSString *const UFPFStatisticsInfoKeyTopicCount = @"topicCount"; // 用户
NSString *const UFPFStatisticsInfoKeyPostCount = @"postCount"; // 用户
NSString *const UFPFStatisticsInfoKeyFollowerCount = @"followerCount"; // 粉丝
NSString *const UFPFStatisticsInfoKeyFollowingCount = @"followingCount"; // 关注
NSString *const UFPFStatisticsInfoKeyLikedCount = @"likedCount"; // 获赞数


# pragma mark - Notification 表

// Class key
NSString *const UFPFNotificationKeyClass = @"Notification";

// Field keys

NSString *const UFPFNotificationKeyFromUser = @"fromUser";
NSString *const UFPFNotificationKeyToUser = @"toUser";
NSString *const UFPFNotificationKeyType = @"type";
NSString *const UFPFNotificationKeySubType = @"subType";
NSString *const UFPFNotificationKeyTopic = @"topic";
NSString *const UFPFNotificationKeyPost = @"post";
NSString *const UFPFNotificationKeyReply = @"reply";
NSString *const UFPFNotificationKeyMessage = @"message";

# pragma mark - Message 表

// Message表 保存用户的私信信息

// Class key
NSString *const UFPFMessageKeyClass = @"Message";

// Field keys
NSString *const UFPFMessageKeyFromUser = @"fromUser"; // 用户
NSString *const UFPFMessageKeyToUser = @"toUser"; // 用户
NSString *const UFPFMessageKeyContent = @"content"; // 用户


# pragma mark - MessageGroup 表

// Message表 保存用户的私信信息

// Class key
NSString *const UFPFMessageGroupKeyClass = @"MessageGroup";

// Field keys
NSString *const UFPFMessageGroupKeyFromUser = @"fromUser";
NSString *const UFPFMessageGroupKeyToUser = @"toUser";
NSString *const UFPFMessageGroupKeyLastMessage = @"lastMessage";
NSString *const UFPFMessageGroupKeyUnreadMessageCount = @"unreadMessageCount";


# pragma mark - BadgeCount 表

// Message表 保存用户的私信信息

// Class key
NSString *const UFPFBadgeCountKeyClass = @"BadgeCount";

// Field keys
NSString *const UFPFBadgeCountKeyUser = @"user";
NSString *const UFPFBadgeCountKeyTotalCount = @"totalCount";
NSString *const UFPFBadgeCountKeyCommentCount = @"commentCount";
NSString *const UFPFBadgeCountKeyLikeCount = @"likeCount";
NSString *const UFPFBadgeCountKeyFollowCount = @"followCount";
NSString *const UFPFBadgeCountKeyMessageCount = @"messageCount";
NSString *const UFPFBadgeCountKeyOtherCount = @"otherCount";


# pragma mark - AppInfo 表

// AppInfo表 保存应用的相关信息

// Class key
NSString *const UFPFAppInfoKeyClass = @"AppInfo";

// Field keys
NSString *const UFPFAppInfoKeyUser = @"version";


