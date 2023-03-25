//
//  UFPFService+ReplyLike.m
//  UFPFParse
//
//  Created by XueFeng Chen on 2022/7/17.
//

#import "UFPFService+ReplyLike.h"

#import "UFPFDefines.h"

#import "UFPFReply.h"
#import "UFPFReplyLike.h"

#import "UFPFService+User.h"
#import "UFPFService+Notification.h"

@implementation UFPFService (ReplyLike)

// 判断用户是否喜欢这个Reply
+ (BOOL)isReply:(UFPFReply *)reply likedbyUser:(PFUser *)user error:(NSError **)error {
    NSArray<UFPFReplyLike *> *replyLikes = [UFPFService _findReplyLikeFromUser:user toReply:reply isDeleted:NO error:error];
    
    if (*error) {
        return NO;
    } else {
        if (replyLikes.count > 0) {
            return YES;
        } else {
            return NO;
        }
    }
}

// 添加
+ (UFPFReplyLike *)addReplyLikeWithFromUser:(PFUser *)fromUser toReply:(UFPFReply *)toReply error:(NSError **)error {
    // ReplyLike是否已经存在
    NSArray<UFPFReplyLike *> *replyLikes =  [UFPFService _findReplyLikeFromUser:fromUser toReply:toReply isDeleted:NO error:error];
    if (*error) {
        return nil;
    } else {
        if (replyLikes.count > 0) {
            return replyLikes[0];
        }
    }
    
    // 存在相应的记录但isDeleted标记为是YES，此时修正为NO即可
    replyLikes =  [UFPFService _findReplyLikeFromUser:fromUser toReply:toReply isDeleted:YES error:error];
    if (*error) {
        return nil;
    } else {
        if (replyLikes.count > 0) {
            UFPFReplyLike *replyLike = replyLikes[0];
            BOOL succeeded = [UFPFService _updateReplyLike:replyLike isDeleted:NO error:error];
            if (!succeeded) {
                return nil;
            }
            return replyLike;
        }
    }
    
    // 不存在记录，那么添加一条新的
    UFPFReplyLike *replyLike = [[UFPFReplyLike alloc] init];
    replyLike.fromUser = fromUser;
    replyLike.toReply = toReply;
    replyLike.isDeleted = NO;
    
    BOOL succeeded = [replyLike save:error];
    
    if (succeeded) {
        // 首次喜欢，向消息表中添加一条记录
        NSError *notificationError = nil;
        [UFPFService addNotificationFromUser:fromUser toUser:toReply.fromUser type:UFPFNotificationTypeLike subType:UFPFNotificationSubTypeLikeReply topic:nil post:nil reply:toReply messageGroup:nil error:&notificationError];
        return replyLike;
    } else {
        return nil;
    }
}

// 删除
+ (BOOL)deleteReplyLike:(UFPFReplyLike *)replyLike error:(NSError **)error {
    return [UFPFService _updateReplyLike:replyLike isDeleted:YES error:error];
}

+ (BOOL)deleteReplyLikeFromUser:(PFUser *)fromUser toReply:(UFPFReply *)toReply error:(NSError **)error {
    NSArray<UFPFReplyLike *> *replyLikes =  [UFPFService _findReplyLikeFromUser:fromUser toReply:toReply isDeleted:NO error:error];
    
    if (*error) {
        return NO;
    } else {
        // 理论上应该只找到一条记录
        if (replyLikes.count > 0) {
            // 删除所有
            for (NSInteger i = 0; i < replyLikes.count; i++) {
                UFPFReplyLike *replyLike = replyLikes[i];
                BOOL succeeded = [UFPFService _updateReplyLike:replyLike isDeleted:YES error:error];
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

+ (NSArray<UFPFReplyLike *> *)_findReplyLikeFromUser:(PFUser *)fromUser toReply:(UFPFReply *)toReply isDeleted:(BOOL)isDeleted error:(NSError **)error {
    PFQuery *query = [PFQuery queryWithClassName:UFPFReplyLikeKeyClass];
    [query whereKey:UFPFReplyLikeKeyFromUser equalTo:fromUser];
    [query whereKey:UFPFReplyLikeKeyToReply equalTo:toReply];
    [query whereKey:UFPFReplyLikeKeyIsDeleted equalTo:@(isDeleted)];
    return [query findObjects:error];
}

+ (BOOL)_updateReplyLike:(UFPFReplyLike *)replyLike isDeleted:(BOOL)isDeleted error:(NSError **)error {
    replyLike.isDeleted = isDeleted;
    return [replyLike save:error];
}

@end
