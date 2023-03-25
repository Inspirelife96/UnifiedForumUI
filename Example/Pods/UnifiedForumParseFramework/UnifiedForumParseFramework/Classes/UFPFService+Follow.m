//
//  UFPFService+Follow.m
//  UFPFParse
//
//  Created by XueFeng Chen on 2021/6/24.
//

#import "UFPFService+Follow.h"

#import "UFPFDefines.h"

#import "UFPFFollow.h"

#import "UFPFService+Notification.h"
#import "UFPFService+User.h"
#import "UFPFService+Block.h"

typedef NS_ENUM(NSInteger, UFPFUserRelationType) {
    UFPFUserRelationTypeFollow,
    UFPFUserRelationTypeFollowed
};

@implementation UFPFService (Follow)

// 查找user的粉丝
+ (NSArray <PFUser *> *)findFollower:(PFUser *)user
                                page:(NSInteger)page
                           pageCount:(NSInteger)pageCount
                               error:(NSError **)error {
    return [UFPFService _findUserRelationShip:UFPFUserRelationTypeFollowed forUser:user page:page pageCount:pageCount error:error];
}

// 查找user的关注
+ (NSArray <PFUser *> *)findFollowing:(PFUser *)user
                                 page:(NSInteger)page
                            pageCount:(NSInteger)pageCount
                                error:(NSError **)error {
    return [UFPFService _findUserRelationShip:UFPFUserRelationTypeFollow forUser:user page:page pageCount:pageCount error:error];
}

// Follow表添加
+ (UFPFFollow *)addFollowFromUser:(PFUser *)fromUser toUser:(PFUser *)toUser error:(NSError **)error {
    // 查询Follow表内是否存在记录
    NSArray<UFPFFollow *> *followArray = [UFPFService _findFollowFromUser:fromUser toUser:toUser isDeleted:NO error:error];
    
    if (*error) {
        return nil;
    } else {
        // 存在，则直接返回
        if (followArray.count > 0) {
            return followArray[0];
        }
    }
    
    // 查找Follow表内是否存在记录但标记isDeleted=YES
    followArray = [UFPFService _findFollowFromUser:fromUser toUser:toUser isDeleted:YES error:error];

    if (*error) {
        return nil;
    } else {
        // 存在，则修改标记位
        if (followArray.count > 0) {
            UFPFFollow *follow = followArray[0];
            BOOL succeeded = [UFPFService _updateFollow:follow isDeleted:NO error:error];
            if (!succeeded) {
                return follow;
            }
        }
    }
    
    UFPFFollow *follow = [[UFPFFollow alloc] init];
    follow.fromUser = fromUser;
    follow.toUser = toUser;
    follow.isDeleted = NO;
    BOOL succeeded = [follow save:error];
    if (succeeded) {
        // 首次关注，向消息表中添加一条记录
        [UFPFService addNotificationFromUser:fromUser toUser:toUser type:UFPFNotificationTypeFollow subType:UFPFNotificationSubTypeNone topic:nil post:nil reply:nil messageGroup:nil error:error];
        return follow;
    } else {
        return nil;
    }
}

+ (BOOL)isFollowFromUser:(PFUser *)fromUser toUser:(PFUser *)toUser error:(NSError **)error {
    NSArray *followArray = [UFPFService _findFollowFromUser:fromUser toUser:toUser isDeleted:NO error:error];
    
    if (*error) {
        return NO;
    } else {
        // 存在，则直接返回
        if (followArray.count > 0) {
            return YES;
        } else {
            return NO;
        }
    }
}

// 逻辑删除
+ (BOOL)deleteFollow:(UFPFFollow *)follow error:(NSError **)error {
    return [UFPFService _updateFollow:follow isDeleted:YES error:error];
}

// 逻辑删除
+ (BOOL)deleteFollowFromUser:(PFUser *)fromUser toUser:(PFUser *)toUser error:(NSError **)error {
    NSArray *followArray = [UFPFService _findFollowFromUser:fromUser toUser:toUser isDeleted:NO error:error];
    
    if (*error) {
        return NO;
    } else {
        // 理论上应该只找到一条记录
        if (followArray.count > 0) {
            // 删除所有
            for (NSInteger i = 0; i < followArray.count; i++) {
                UFPFFollow *follow = followArray[i];
                BOOL succeeded = [UFPFService _updateFollow:follow isDeleted:YES error:error];
                if (!succeeded) {
                    return NO;
                }
            }
            return YES;
        } else {
            return YES;//没找到，证明没有关注，不需要删除了
        }
    }
}

#pragma mark Private Methods

+ (NSArray *)_findFollowFromUser:(PFUser *)fromUser toUser:(PFUser *)toUser isDeleted:(BOOL)isDeleted error:(NSError **)error {
    PFQuery *query = [PFQuery queryWithClassName:UFPFFollowKeyClass];
    [query whereKey:UFPFFollowKeyFromUser equalTo:fromUser];
    [query whereKey:UFPFFollowKeyToUser equalTo:toUser];
    [query whereKey:UFPFFollowKeyIsDeleted equalTo:@(isDeleted)];
    
    return [query findObjects:error];
}

+ (BOOL)_updateFollow:(UFPFFollow *)follow isDeleted:(BOOL)isDeleted error:(NSError **)error {
    follow.isDeleted = isDeleted;
    return [follow save:error];
}

// 查找user的关注
+ (NSArray <PFUser *> *)_findUserRelationShip:(UFPFUserRelationType)type
                                      forUser:(PFUser *)user
                                         page:(NSInteger)page
                                    pageCount:(NSInteger)pageCount
                                        error:(NSError **)error {
    PFQuery *query = [PFQuery queryWithClassName:UFPFFollowKeyClass];
    
    // 删除标记必须为NO
    [query whereKey:UFPFFollowKeyIsDeleted equalTo:@(NO)];
    
    NSString *conditionKey = UFPFFollowKeyFromUser;
    NSString *tagetKey = UFPFFollowKeyToUser;
    
    if (type == UFPFUserRelationTypeFollowed) {
        conditionKey = UFPFFollowKeyToUser;
        tagetKey = UFPFFollowKeyFromUser;
    }
    
    // 根据查找的关系类型，设定条件
    [query whereKey:conditionKey equalTo:user];
    
    // 返回的列表的用户，不能为注销的用户
    PFQuery *deletedUserQuery = [UFPFService buildUserQueryWhereUserIsDeleted];
    [query whereKey:tagetKey doesNotMatchQuery:deletedUserQuery];
    
    // 不能为锁定用户
    PFQuery *lockedUserQuery = [UFPFService buildUserQueryWhereUserIsLocked];
    [query whereKey:tagetKey doesNotMatchQuery:lockedUserQuery];
    
    // 如果是登录用户，返回的用户不能在登录用户黑名单中
    if ([PFUser currentUser]) {
        PFQuery *blockQuery = [UFPFService buildBlockQueryWhereFromUserIs:[PFUser currentUser]];
        [query whereKey:tagetKey doesNotMatchKey:UFPFBlockKeyToUser inQuery:blockQuery];
    }
    
    [query includeKey:tagetKey];
    
    [query setSkip:pageCount * page];
    [query setLimit:pageCount];
    
    // 逆向排序
    [query orderByDescending:@"createdAt"];
    
    NSArray *followArray = [query findObjects:error];
    
    if (*error) {
        return @[];
    } else {
        NSMutableArray *userMutableArray = [[NSMutableArray alloc] init];
        
        [followArray enumerateObjectsUsingBlock:^(UFPFFollow *  _Nonnull follow, NSUInteger idx, BOOL * _Nonnull stop) {
            PFUser *user = [follow objectForKey:tagetKey];
            [userMutableArray addObject:user];
        }];
        
        return [userMutableArray copy];
    }
}

@end
