//
//  UFPFService+Post.h
//  UFPFParse
//
//  Created by XueFeng Chen on 2021/6/24.
//

#import "UFPFService.h"

@class UFPFCategory;
@class UFPFTopic;
@class UFPFPost;
@class UFPFReply;
@class PFUser;

NS_ASSUME_NONNULL_BEGIN

@interface UFPFService (Post)

// - 查询某一个Topic的回帖
+ (NSArray <UFPFPost *> *)findPostsToTopic:(UFPFTopic *)toTopic
                                   orderBy:(NSString *)orderBy
                        isOrderByAscending:(BOOL)isOrderByAscending
                                      page:(NSInteger)page
                                 pageCount:(NSInteger)pageCount
                                     error:(NSError **)error;

// - 查询某一个Topic下某个人的所有回贴 - 例如：即只看楼主的功能
+ (NSArray <UFPFPost *> *)findPostsToTopic:(UFPFTopic *)toTopic
                                  fromUser:(PFUser *)fromUser
                                   orderBy:(NSString *)orderBy
                        isOrderByAscending:(BOOL)isOrderByAscending
                                      page:(NSInteger)page
                                 pageCount:(NSInteger)pageCount
                                     error:(NSError **)error;

// Post表添加
+ (UFPFPost *)addPostWithIsApproved:(BOOL)isApproved
                  isDeleted:(BOOL)isDeleted
                    content:(NSString *)content
           mediaFileObjects:(NSArray<PFFileObject *> * _Nullable)mediaFileObjects
                     mediaFileType:(NSString *)mediaFileType
                   fromUser:(PFUser *)fromUser
                    toTopic:(UFPFTopic *)toTopic
                      error:(NSError **)error;

// 更新

// 用户编辑Post的内容
+ (BOOL)updatePost:(UFPFPost *)post
           content:(NSString * _Nullable)content
  mediaFileObjects:(NSArray<PFFileObject *> * _Nullable)mediaFileObjects
             reply:(NSArray<UFPFReply *> * _Nullable)replies
             error:(NSError **)error;

//// 管理员可以设置锁定状态
//+ (BOOL)updatePost:(UFPFPost *)post isLocked:(BOOL)isLocked error:(NSError **)error;

// 管理员或者作者可以设置删除状态
+ (BOOL)updatePost:(UFPFPost *)post isDeleted:(BOOL)isDeleted error:(NSError **)error;

// 管理员可以设置审核状态
+ (BOOL)updatePost:(UFPFPost *)post isApproved:(BOOL)isApproved error:(NSError **)error;

// 辅助
+ (PFQuery *)buildPostQueryWhereFromUserIsBlockedByUser:(PFUser *)user;

+ (PFQuery *)buildPostQueryWhereFromUserIsDeleted;

+ (PFQuery *)buildPostQueryWhereFromUserIsLocked;

@end

NS_ASSUME_NONNULL_END
