//
//  UFPFService+TopicLike.h
//  UFPFParse
//
//  Created by XueFeng Chen on 2022/5/19.
//

#import "UFPFService.h"

NS_ASSUME_NONNULL_BEGIN

@class UFPFTopic;
@class UFPFTopicLike;

@interface UFPFService (TopicLike)

// 查找喜欢这个Topic的用户
+ (NSArray<PFUser *> *)findUsersWhoLikesTopic:(UFPFTopic *)toTopic page:(NSInteger)page pageCount:(NSInteger)pageCount error:(NSError **)error;

// 查找用户喜欢的Topic
+ (NSArray<UFPFTopic *> *)findTopicsLikedByUser:(PFUser *)fromUser page:(NSInteger)page pageCount:(NSInteger)pageCount error:(NSError **)error;

// 判断用户是否喜欢这个Topic
+ (BOOL)isTopic:(UFPFTopic *)topic likedbyUser:(PFUser *)user error:(NSError **)error;

// 添加
+ (UFPFTopicLike *)addTopicLikeWithFromUser:(PFUser *)fromUser toTopic:(UFPFTopic *)toTopic error:(NSError **)error;

// 删除
+ (BOOL)deleteTopicLike:(UFPFTopicLike *)topicLike error:(NSError **)error;
+ (BOOL)deleteTopicLikeFromUser:(PFUser *)fromUser toTopic:(UFPFTopic *)toTopic error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
