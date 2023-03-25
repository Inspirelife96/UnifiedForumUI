//
//  UFPFReply.h
//  UFPFParse
//
//  Created by XueFeng Chen on 2021/12/28.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@class UFPFPost;

@interface UFPFReply : PFObject <PFSubclassing>

// 标记
@property (nonatomic, assign) BOOL isApproved; // 审核，如果内容有问题，管理员可以通过该标记为对这条回复进行屏蔽
@property (nonatomic, assign) BOOL isDeleted; // 删除，作者可以通过该标记进行软删除

// 核心内容
@property (nonatomic, copy) NSString *content; // 即回复的内容。

// 统计字段：
@property (nonatomic, strong) NSNumber* likeCount; // 可以对Reply进行点赞，这个字段记录点赞的次数

// 关系
@property (nonatomic, strong) PFUser *fromUser; // 明确这条Reply是谁发布的
@property (nonatomic, strong) UFPFPost *toPost; // 这个字段不能为空，必须指定是针对哪个Post的回复
@property (nonatomic, strong) UFPFReply *toReply; // 如果该字段不为空，那么该回复是针对toPost下的toReply的回复

@end

NS_ASSUME_NONNULL_END
