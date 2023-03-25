//
//  UFPFService+TopicLike.m
//  UFPFParse
//
//  Created by XueFeng Chen on 2022/5/19.
//

#import "UFPFService+TopicLike.h"

#import "UFPFDefines.h"

#import "UFPFTopic.h"
#import "UFPFTopicLike.h"

#import "UFPFService+Notification.h"
#import "UFPFService+User.h"
#import "UFPFService+Block.h"

@implementation UFPFService (TopicLike)

// 查找喜欢这个Topic的用户
+ (NSArray<PFUser *> *)findUsersWhoLikesTopic:(UFPFTopic *)toTopic page:(NSInteger)page pageCount:(NSInteger)pageCount error:(NSError **)error {
    PFQuery *query = [PFQuery queryWithClassName:UFPFTopicLikeKeyClass];
    
    // 查询的必要条件
    [query whereKey:UFPFTopicKeyIsDeleted equalTo:@(NO)];
    [query whereKey:UFPFTopicLikeKeyToTopic equalTo:toTopic];

    // 去除fromUser是注销用户
    PFQuery *deletedUserQuery = [UFPFService buildUserQueryWhereUserIsDeleted];
    [query whereKey:UFPFTopicLikeKeyFromUser doesNotMatchQuery:deletedUserQuery];
    
    // 去除fromUser是禁止用户
    PFQuery *lockedUserQuery = [UFPFService buildUserQueryWhereUserIsLocked];
    [query whereKey:UFPFTopicLikeKeyFromUser doesNotMatchQuery:lockedUserQuery];

    // 如果是登录用户，屏蔽黑名单
    if ([PFUser currentUser]) {
        PFQuery *blockQuery = [UFPFService buildBlockQueryWhereFromUserIs:[PFUser currentUser]];
        [query whereKey:UFPFTopicLikeKeyFromUser doesNotMatchKey:UFPFBlockKeyToUser inQuery:blockQuery];
    }
    
    [query includeKey:UFPFTopicLikeKeyFromUser];
    [query includeKey:UFPFTopicLikeKeyToTopic];
        
    [query orderByDescending:UFPFKeyCreatedAt];

    [query setSkip:pageCount * page];
    [query setLimit:pageCount];
    
    NSArray<UFPFTopicLike *> *topicLikes = [query findObjects:error];
    
    if (*error) {
        return @[];
    } else {
        NSMutableArray *userMutableArray = [[NSMutableArray alloc] init];
        
        [topicLikes enumerateObjectsUsingBlock:^(UFPFTopicLike *  _Nonnull topicLike, NSUInteger idx, BOOL * _Nonnull stop) {
            if (topicLike.isDeleted == NO) {
                PFUser *user = topicLike.fromUser;
                [userMutableArray addObject:user];
            }
        }];
        
        return [userMutableArray copy];
    }
}

// 查找用户喜欢的Topic
+ (NSArray<UFPFTopic *> *)findTopicsLikedByUser:(PFUser *)fromUser page:(NSInteger)page pageCount:(NSInteger)pageCount error:(NSError **)error {
    PFQuery *query = [PFQuery queryWithClassName:UFPFTopicLikeKeyClass];
    
    [query whereKey:UFPFTopicKeyIsDeleted equalTo:@(NO)];
    [query whereKey:UFPFTopicLikeKeyFromUser equalTo:fromUser];
    
    // 理论上，我们需要继续对toTopic进行筛选，剔除那些无效的toTopic，例如：
    // - Topic本身被作者删除了，被作者隐藏了，被管理员禁了。
    // - Topic的发布者注销了，或者被管理员禁了
    // - Topic的发布者在当前登录用户的黑名单里
    //
    // 但剔除这些无效的toTopic，用户的体验可能会有瑕疵，请看下面的例子：
    // - A用户喜欢了用户B发布的Topic1，
    // - 用户B把Topic1删除了
    // - 用户A查找自己喜欢的Topic，却发现自己明明喜欢了Topic1，却怎么也找不到了
    //
    // 因此，从用户的体验上来说，我更倾向展示这些无效的toTopic，并在用户进一步展开时
    // 提示用户，因为某些原因，这些Topic已经无法展开了。
    
    // 基于上述原因，我们不再对toTopic进行筛选
        
    [query includeKey:UFPFTopicLikeKeyFromUser];
    [query includeKey:UFPFTopicLikeKeyToTopic];
        
    [query orderByDescending:UFPFKeyCreatedAt];

    [query setSkip:pageCount * page];
    [query setLimit:pageCount];
    
    NSArray<UFPFTopicLike *> *topicLikes =  [query findObjects:error];
    
    if (*error) {
        return @[];
    } else {
        NSMutableArray *userMutableArray = [[NSMutableArray alloc] init];
        
        [topicLikes enumerateObjectsUsingBlock:^(UFPFTopicLike *  _Nonnull topicLike, NSUInteger idx, BOOL * _Nonnull stop) {
            if (topicLike.isDeleted == NO) {
                UFPFTopic *topic = topicLike.toTopic;
                [userMutableArray addObject:topic];
            }
        }];
        
        return [userMutableArray copy];
    }
}

+ (BOOL)isTopic:(UFPFTopic *)topic likedbyUser:(PFUser *)user error:(NSError **)error {
    NSArray<UFPFTopicLike *> *topicLikes = [UFPFService _findTopicLikeFromUser:user toTopic:topic isDeleted:NO error:error];

    if (*error) {
        return NO;
    } else {
        if (topicLikes.count > 0) {
            return YES;
        } else {
            return NO;
        }
    }
}

// 添加
+ (UFPFTopicLike *)addTopicLikeWithFromUser:(PFUser *)fromUser toTopic:(UFPFTopic *)toTopic error:(NSError **)error {
    NSArray<UFPFTopicLike *> *topicLikes = [UFPFService _findTopicLikeFromUser:fromUser toTopic:toTopic isDeleted:NO error:error];
    
    if (*error) {
        return nil;
    } else {
        if (topicLikes.count > 0) {
            return topicLikes[0];
        }
    }
    
    topicLikes = [UFPFService _findTopicLikeFromUser:fromUser toTopic:toTopic isDeleted:YES error:error];

    if (*error) {
        return nil;
    } else {
        if (topicLikes.count > 0) {
            UFPFTopicLike *topicLike = topicLikes[0];
            BOOL succeeded = [UFPFService _updateTopicLike:topicLike isDeleted:NO error:error];
            if (!succeeded) {
                return nil;
            }
            return topicLike;
        }
    }
    
    UFPFTopicLike *topicLike = [[UFPFTopicLike alloc] init];
    topicLike.fromUser = fromUser;
    topicLike.toTopic = toTopic;
    topicLike.isDeleted = NO;
    
    BOOL succeeded = [topicLike save:error];
    
    if (succeeded) {
        // 首次喜欢，向消息表中添加一条记录
        // 该操作不管是否成功，不会影响addTopicLike的操作，因此操作执行后，返回YES。
        NSError *notificationError = nil;
        [UFPFService addNotificationFromUser:fromUser toUser:toTopic.fromUser type:UFPFNotificationTypeLike subType:UFPFNotificationSubTypeLikeTopic topic:toTopic post:nil reply:nil messageGroup:nil error:&notificationError];
        
        return topicLike;
    } else {
        return nil;
    }
}

// 逻辑删除
+ (BOOL)deleteTopicLike:(UFPFTopicLike *)topicLike error:(NSError **)error {
    return [UFPFService _updateTopicLike:topicLike isDeleted:YES error:error];
}

// 逻辑删除
+ (BOOL)deleteTopicLikeFromUser:(PFUser *)fromUser toTopic:(UFPFTopic *)toTopic error:(NSError **)error {
    NSArray<UFPFTopicLike *> *topicLikes = [UFPFService _findTopicLikeFromUser:fromUser toTopic:toTopic isDeleted:NO error:error];
    
    if (*error) {
        return NO;
    } else {
        // 理论上应该只找到一条记录
        if (topicLikes.count > 0) {
            // 删除所有
            for (NSInteger i = 0; i < topicLikes.count; i++) {
                UFPFTopicLike *topicLike = topicLikes[i];
                BOOL succeeded = [UFPFService _updateTopicLike:topicLike isDeleted:YES error:error];
                if (!succeeded) {
                    return NO;
                }
            }
            return YES;
        } else {
            return YES;//没找到，证明已经删除了
        }
    }
}

+ (NSArray<UFPFTopicLike *> *)_findTopicLikeFromUser:(PFUser *)fromUser toTopic:(UFPFTopic *)toTopic isDeleted:(BOOL)isDeleted error:(NSError **)error {
    PFQuery *query = [PFQuery queryWithClassName:UFPFTopicLikeKeyClass];
    [query whereKey:UFPFTopicLikeKeyFromUser equalTo:fromUser];
    [query whereKey:UFPFTopicLikeKeyToTopic equalTo:toTopic];
    [query whereKey:UFPFTopicLikeKeyIsDeleted equalTo:@(isDeleted)];
    return [query findObjects:error];
}

+ (BOOL)_updateTopicLike:(UFPFTopicLike *)topicLike isDeleted:(BOOL)isDeleted error:(NSError **)error {
    topicLike.isDeleted = isDeleted;
    return [topicLike save:error];
}

@end
