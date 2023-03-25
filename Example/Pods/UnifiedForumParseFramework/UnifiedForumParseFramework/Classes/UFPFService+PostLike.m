//
//  UFPFService+PostLike.m
//  UFPFParse
//
//  Created by XueFeng Chen on 2022/7/17.
//

#import "UFPFService+PostLike.h"

#import "UFPFDefines.h"

#import "UFPFService+User.h"
#import "UFPFService+Block.h"
#import "UFPFService+Notification.h"

#import "UFPFPost.h"
#import "UFPFPostLike.h"

@implementation UFPFService (PostLike)

// 判断用户是否喜欢这个Post
+ (BOOL)isPost:(UFPFPost *)post likedbyUser:(PFUser *)user error:(NSError **)error {
    NSArray<UFPFPostLike *> *postLikes =  [UFPFService _findPostLikeFromUser:user toPost:post isDeleted:NO error:error];
    
    if (*error) {
        return NO;
    } else {
        if (postLikes.count > 0) {
            return YES;
        } else {
            return NO;
        }
    }
}

// 添加
+ (UFPFPostLike *)addPostLikeWithFromUser:(PFUser *)fromUser toPost:(UFPFPost *)toPost error:(NSError **)error {
    // PostLike是否已经存在
    NSArray<UFPFPostLike *> *postLikes =  [UFPFService _findPostLikeFromUser:fromUser toPost:toPost isDeleted:NO error:error];
    if (*error) {
        return nil;
    } else {
        if (postLikes.count > 0) {
            return postLikes[0];
        }
    }
    
    // 存在相应的记录但isDeleted标记为是YES，此时修正为NO即可
    postLikes =  [UFPFService _findPostLikeFromUser:fromUser toPost:toPost isDeleted:YES error:error];
    if (*error) {
        return nil;
    } else {
        if (postLikes.count > 0) {
            UFPFPostLike *postLike = postLikes[0];
            BOOL succeeded = [UFPFService _updatePostLike:postLike isDeleted:NO error:error];
            if (!succeeded) {
                return nil;
            }
            return postLike;
        }
    }
    
    // 不存在记录，那么添加一条新的
    UFPFPostLike *postLike = [[UFPFPostLike alloc] init];
    postLike.fromUser = fromUser;
    postLike.toPost = toPost;
    postLike.isDeleted = NO;
    
    BOOL succeeded = [postLike save:error];
    
    if (succeeded) {
        // 首次喜欢，向消息表中添加一条记录
        NSError *notificationError = nil;
        [UFPFService addNotificationFromUser:fromUser toUser:toPost.fromUser type:UFPFNotificationTypeLike subType:UFPFNotificationSubTypeLikePost topic:nil post:toPost reply:nil messageGroup:nil error:&notificationError];
        return postLike;
    } else {
        return nil;
    }
}

// 删除
+ (BOOL)deletePostLike:(UFPFPostLike *)postLike error:(NSError **)error {
    return [UFPFService _updatePostLike:postLike isDeleted:YES error:error];
}

+ (BOOL)deletePostLikeFromUser:(PFUser *)fromUser toPost:(UFPFPost *)toPost error:(NSError **)error {
    NSArray<UFPFPostLike *> *postLikes =  [UFPFService _findPostLikeFromUser:fromUser toPost:toPost isDeleted:NO error:error];
    
    if (*error) {
        return NO;
    } else {
        // 理论上应该只找到一条记录
        if (postLikes.count > 0) {
            // 删除所有
            for (NSInteger i = 0; i < postLikes.count; i++) {
                UFPFPostLike *postLike = postLikes[i];
                BOOL succeeded = [UFPFService _updatePostLike:postLike isDeleted:YES error:error];
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

+ (NSArray<UFPFPostLike *> *)_findPostLikeFromUser:(PFUser *)fromUser toPost:(UFPFPost *)toPost isDeleted:(BOOL)isDeleted error:(NSError **)error {
    PFQuery *query = [PFQuery queryWithClassName:UFPFPostLikeKeyClass];
    [query whereKey:UFPFPostLikeKeyFromUser equalTo:fromUser];
    [query whereKey:UFPFPostLikeKeyToPost equalTo:toPost];
    [query whereKey:UFPFPostLikeKeyIsDeleted equalTo:@(isDeleted)];
    return [query findObjects:error];
}

+ (BOOL)_updatePostLike:(UFPFPostLike *)postLike isDeleted:(BOOL)isDeleted error:(NSError **)error {
    postLike.isDeleted = isDeleted;
    return [postLike save:error];
}

@end
