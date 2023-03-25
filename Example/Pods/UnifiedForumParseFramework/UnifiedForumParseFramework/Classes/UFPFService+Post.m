//
//  UFPFService+Post.m
//  UFPFParse
//
//  Created by XueFeng Chen on 2021/6/24.
//

#import "UFPFService+Post.h"

#import "UFPFDefines.h"

#import "UFPFPost.h"
#import "UFPFTopic.h"

#import "UFPFService+Notification.h"
#import "UFPFService+User.h"
#import "UFPFService+Block.h"

#import <Parse/PFErrorUtilities.h>

@implementation UFPFService (Post)

+ (NSArray <UFPFPost *> *)findPostsToTopic:(UFPFTopic *)toTopic
                                   orderBy:(NSString *)orderBy
                        isOrderByAscending:(BOOL)isOrderByAscending
                                      page:(NSInteger)page
                                 pageCount:(NSInteger)pageCount
                                     error:(NSError **)error
{
    return [UFPFService findPostsToTopic:toTopic fromUser:nil category:nil orderBy:orderBy isOrderByAscending:isOrderByAscending page:page pageCount:pageCount error:error];
}

// - 查询某一个Topic下某个人的所有回贴 - 例如：即只看楼主的功能
+ (NSArray <UFPFPost *> *)findPostsToTopic:(UFPFTopic *)toTopic
                                  fromUser:(PFUser *)fromUser
                                   orderBy:(NSString *)orderBy
                        isOrderByAscending:(BOOL)isOrderByAscending
                                      page:(NSInteger)page
                                 pageCount:(NSInteger)pageCount
                                     error:(NSError **)error
{
    return [UFPFService findPostsToTopic:toTopic fromUser:fromUser category:nil orderBy:orderBy isOrderByAscending:isOrderByAscending page:page pageCount:pageCount error:error];
}

+ (NSArray *)findPostsToTopic:(UFPFTopic * _Nullable)toTopic
                     fromUser:(PFUser * _Nullable)fromUser
                     category:(UFPFCategory * _Nullable)category
                      orderBy:(NSString *)orderBy
           isOrderByAscending:(BOOL)isOrderByAscending
                         page:(NSInteger)page
                    pageCount:(NSInteger)pageCount
                        error:(NSError **)error
{
    PFQuery *query = [PFQuery queryWithClassName:UFPFPostKeyClass];
    
    // 默认条件1: 必须审核通过
    [query whereKey:UFPFPostKeyIsApproved equalTo:@(YES)];
    
    // 默认条件2: 不能标记为删除
    [query whereKey:UFPFPostKeyIsDeleted equalTo:@(NO)];
    
    // 默认条件3:发布者不能被注销
    PFQuery *isDeletedUserQuery = [PFQuery queryWithClassName:PFUserKeyClass];
    [isDeletedUserQuery whereKey:UFPFUserKeyIsDeleted equalTo:@(YES)];
    [query whereKey:UFPFPostKeyFromUser doesNotMatchQuery:isDeletedUserQuery];
    
    // 默认条件4:登录状态下，发布者不能在登录用户的黑名单中
    if ([PFUser currentUser]) {
        PFQuery *blockQuery = [PFQuery queryWithClassName:UFPFBlockKeyClass];
        [blockQuery whereKey:UFPFBlockKeyFromUser equalTo:[PFUser currentUser]];
        [query whereKey:UFPFPostKeyFromUser doesNotMatchKey:UFPFBlockKeyToUser inQuery:blockQuery];
    }

    // 查询条件1: 指定Topic
    if (toTopic) {
        [query whereKey:UFPFPostKeyToTopic equalTo:toTopic];
    }
    
    // 查询条件2: 指定FromUser
    if (fromUser) {
        [query whereKey:UFPFPostKeyFromUser equalTo:fromUser];
    }
    
    // 查询条件3: 指定板块
    if (category) {
        PFQuery *innerQuery = [PFQuery queryWithClassName:UFPFTopicKeyClass];
        [innerQuery whereKey:UFPFTopicKeyCategory equalTo:category];
        [query whereKey:UFPFPostKeyToTopic matchesQuery:innerQuery];
    }
    
    if (isOrderByAscending) {
        [query orderByAscending:orderBy];
    } else {
        [query orderByDescending:orderBy];
    }
    
    [query setSkip:pageCount * page];
    [query setLimit:pageCount];
    
    return [query findObjects:error];
}

+ (UFPFPost *)addPostWithIsApproved:(BOOL)isApproved
                  isDeleted:(BOOL)isDeleted
                    content:(NSString *)content
           mediaFileObjects:(NSArray<PFFileObject *> * _Nullable)mediaFileObjects
                     mediaFileType:(NSString *)mediaFileType
                   fromUser:(PFUser *)fromUser
                    toTopic:(UFPFTopic *)toTopic
                      error:(NSError **)error
{
    UFPFPost *post = [[UFPFPost alloc] init];
    
    post.isApproved = isApproved;
    post.isDeleted = isDeleted;
    post.content = content;
    
    if (mediaFileObjects) {
        post.mediaFileObjects = mediaFileObjects;
        post.mediaFileType = mediaFileType;
    }
    
    post.replies = @[];
    post.replyCount = @(0);
    
    post.likeCount = @(0);
    
    post.fromUser = fromUser;
    post.toTopic = toTopic;
    
    BOOL succeeded = [post save:error];
    
    if (succeeded) {
        //添加通知
        NSError *notificationError = nil;
        [UFPFService addNotificationFromUser:fromUser toUser:toTopic.fromUser type:UFPFNotificationTypeComment subType:UFPFNotificationSubTypeCommentTopic topic:nil post:post reply:nil messageGroup:nil error:&notificationError];
        return post;
    } else {
        return nil;
    }
}


+ (BOOL)updatePost:(UFPFPost *)post
           content:(NSString * _Nullable)content
  mediaFileObjects:(NSArray<PFFileObject *> * _Nullable)mediaFileObjects
             reply:(NSArray<UFPFReply *> * _Nullable)replies
             error:(NSError **)error;
{
    NSAssert([PFUser currentUser], @"必须登录才能更新Post");
    NSAssert([[PFUser currentUser].objectId isEqualToString:post.fromUser.objectId], @"登录用户必须和发布者一致才能更新Post");
    
    post.content = content;
    post.mediaFileObjects = mediaFileObjects;
    post.replies = replies;
    
    return [post save:error];
}

// 管理员或者作者可以设置删除状态
+ (BOOL)updatePost:(UFPFPost *)post isDeleted:(BOOL)isDeleted error:(NSError **)error {
    post.isDeleted = isDeleted;
    return [post save:error];
}

// 管理员可以设置审核状态
+ (BOOL)updatePost:(UFPFPost *)post isApproved:(BOOL)isApproved error:(NSError **)error {
    post.isApproved = isApproved;
    return [post save:error];
}

+ (PFQuery *)buildPostQueryWhereFromUserIsBlockedByUser:(PFUser *)user {
    PFQuery *postQuery = [PFQuery queryWithClassName:UFPFPostKeyClass];
    PFQuery *blockQuery = [UFPFService buildBlockQueryWhereFromUserIs:user];
    [postQuery whereKey:UFPFPostKeyFromUser matchesKey:UFPFBlockKeyToUser inQuery:blockQuery];
    return postQuery;
}

+ (PFQuery *)buildPostQueryWhereFromUserIsDeleted {
    PFQuery *postQuery = [PFQuery queryWithClassName:UFPFPostKeyClass];
    PFQuery *userQuery = [UFPFService buildUserQueryWhereUserIsDeleted];
    [postQuery whereKey:UFPFPostKeyFromUser matchesQuery:userQuery];
    return postQuery;
}

+ (PFQuery *)buildPostQueryWhereFromUserIsLocked {
    PFQuery *postQuery = [PFQuery queryWithClassName:UFPFPostKeyClass];
    PFQuery *userQuery = [UFPFService buildUserQueryWhereUserIsLocked];
    [postQuery whereKey:UFPFPostKeyFromUser matchesQuery:userQuery];
    return postQuery;
}

@end
