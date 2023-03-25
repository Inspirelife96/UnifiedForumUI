//
//  UFPFService+Reply.m
//  UFPFParse
//
//  Created by XueFeng Chen on 2021/12/28.
//

#import "UFPFService+Reply.h"

#import "UFPFDefines.h"

#import "UFPFService+Notification.h"
#import "UFPFService+User.h"
#import "UFPFService+Block.h"

#import "UFPFPost.h"
#import "UFPFReply.h"

@implementation UFPFService (Reply)

+ (NSArray <UFPFReply *> *)findRepliesToPost:(UFPFPost *)toPost
                                    orderBy:(NSString *)orderBy
                          isOrderByAscending:(BOOL)isOrderByAscending
                                       page:(NSInteger)page
                                  pageCount:(NSInteger)pageCount
                                      error:(NSError **)error
{
    PFQuery *query = [PFQuery queryWithClassName:UFPFReplyKeyClass];
    
    // 默认条件1: 必须审核通过
    [query whereKey:UFPFReplyKeyIsApproved equalTo:@(YES)];
    
    // 默认条件2: 不能标记为删除
    [query whereKey:UFPFReplyKeyIsDeleted equalTo:@(NO)];
    
    // 默认条件4:登录状态下，发布者不能在登录用户的黑名单中
    PFQuery *isDeletedUserQuery = [PFQuery queryWithClassName:PFUserKeyClass];
    [isDeletedUserQuery whereKey:UFPFUserKeyIsDeleted equalTo:@(YES)];
    [query whereKey:UFPFPostKeyFromUser doesNotMatchQuery:isDeletedUserQuery];
    
    // 如果时登录用户，屏蔽黑名单
    if ([PFUser currentUser]) {
        PFQuery *blockQuery = [PFQuery queryWithClassName:UFPFBlockKeyClass];
        [blockQuery whereKey:UFPFBlockKeyFromUser equalTo:[PFUser currentUser]];
        [query whereKey:UFPFReplyKeyFromUser doesNotMatchKey:UFPFBlockKeyToUser inQuery:blockQuery];
    }
    
    [query whereKey:UFPFReplyKeyToPost equalTo:toPost];
    
    if (isOrderByAscending) {
        [query orderByAscending:orderBy];
    } else {
        [query orderByDescending:orderBy];
    }
    
    [query setSkip:pageCount * page];
    [query setLimit:pageCount];
    
    return [query findObjects:error];
}

+ (UFPFReply *)addReplyToPost:(UFPFPost *)toPost
            isApproved:(BOOL)isApproved
             isDeleted:(BOOL)isDeleted
               content:(NSString *)content
              fromUser:(PFUser *)fromUser
                 error:(NSError **)error {
    return [UFPFService addReplyToPost:toPost isApproved:isApproved isDeleted:isDeleted content:content fromUser:fromUser toReply:nil error:error];
}


+ (UFPFReply *)addReplyToReply:(UFPFReply *)toReply
            isApproved:(BOOL)isApproved
             isDeleted:(BOOL)isDeleted
               content:(NSString *)content
              fromUser:(PFUser *)fromUser
                  error:(NSError **)error {
    return [UFPFService addReplyToPost:toReply.toPost isApproved:isApproved isDeleted:isDeleted content:content fromUser:fromUser toReply:toReply error:error];
}

+ (UFPFReply *)addReplyToPost:(UFPFPost *)toPost
            isApproved:(BOOL)isApproved
             isDeleted:(BOOL)isDeleted
               content:(NSString *)content
              fromUser:(PFUser *)fromUser
               toReply:(UFPFReply * _Nullable)toReply
                 error:(NSError **)error
{
    UFPFReply *reply = [[UFPFReply alloc] init];
    
    reply.isApproved = isApproved;
    reply.isDeleted = isDeleted;
    
    reply.content = content;
    reply.fromUser = fromUser;
    reply.toPost = toPost;
    
    reply.likeCount = @(0);
    
    if (toReply) {
        reply.toReply = toReply;
    }
    
    BOOL succeeded = [reply save:error];
    
    // 这里我们不处理toPost里对应的计数和replies,交由服务器处理！！！重要
    
    // 添加通知
    // 如果是针对Post的回复，则发给Post的所有者
    // 如果是针对Reply的回复，则发给Reply的所有者
    if (succeeded) {
        PFUser *toUser = toPost.fromUser;
        NSString *subType = UFPFNotificationSubTypeCommentPost;
        if (toReply) {
            toUser = toReply.fromUser;
            subType = UFPFNotificationSubTypeCommentReply;
        }
        
        NSError *notificationError = nil;
        [UFPFService addNotificationFromUser:fromUser toUser:toUser type:UFPFNotificationTypeComment subType:subType topic:nil post:nil reply:reply messageGroup:nil error:&notificationError];
        
        return reply;
    } else {
        return nil;
    }
}

+ (BOOL)updateReply:(UFPFReply *)reply content:(NSString *)content error:(NSError **)error {
    NSAssert([PFUser currentUser], @"必须登录才能更新Reply");
    NSAssert([[PFUser currentUser].objectId isEqualToString:reply.fromUser.objectId], @"登录用户必须和发布者一致才能更新Post");

    reply.content = content;
    return [reply save:error];
}

+ (BOOL)updateReply:(UFPFReply *)reply isDeleted:(BOOL)isDeleted error:(NSError **)error {
    reply.isDeleted = isDeleted;
    return [reply save:error];
}

+ (BOOL)updateReply:(UFPFReply *)reply isApproved:(BOOL)isApproved error:(NSError **)error {
    reply.isApproved = isApproved;
    return [reply save:error];
}

+ (PFQuery *)buildReplyQueryWhereFromUserIsBlockedByUser:(PFUser *)user {
    PFQuery *replyQuery = [PFQuery queryWithClassName:UFPFReplyKeyClass];
    PFQuery *blockQuery = [UFPFService buildBlockQueryWhereFromUserIs:user];
    [replyQuery whereKey:UFPFReplyKeyFromUser matchesKey:UFPFBlockKeyToUser inQuery:blockQuery];
    return replyQuery;
}

+ (PFQuery *)buildReplyQueryWhereFromUserIsDeleted {
    PFQuery *replyQuery = [PFQuery queryWithClassName:UFPFReplyKeyClass];
    PFQuery *userQuery = [UFPFService buildUserQueryWhereUserIsDeleted];
    [replyQuery whereKey:UFPFReplyKeyFromUser matchesQuery:userQuery];
    return replyQuery;
}

+ (PFQuery *)buildReplyQueryWhereFromUserIsLocked {
    PFQuery *replyQuery = [PFQuery queryWithClassName:UFPFReplyKeyClass];
    PFQuery *userQuery = [UFPFService buildUserQueryWhereUserIsLocked];
    [replyQuery whereKey:UFPFReplyKeyFromUser matchesQuery:userQuery];
    return replyQuery;
}

@end
