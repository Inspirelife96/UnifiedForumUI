//
//  UFPFService+Reply.h
//  UFPFParse
//
//  Created by XueFeng Chen on 2021/12/28.
//

#import "UFPFService.h"

NS_ASSUME_NONNULL_BEGIN

@class UFPFPost;
@class UFPFReply;

@interface UFPFService (Reply)

// 查

// Reply表查询
// 通常是一种用例
// - 查询某一个回贴的全部回复 - 标准需求
//
// 需要注意，仅返回isApproved = YES && isDeleted = NO的回复
//

+ (NSArray <UFPFReply *> *)findRepliesToPost:(UFPFPost *)toPost
                                    orderBy:(NSString *)orderBy
                          isOrderByAscending:(BOOL)isOrderByAscending
                                       page:(NSInteger)page
                                  pageCount:(NSInteger)pageCount
                                      error:(NSError **)error;
// 增
+ (UFPFReply *)addReplyToPost:(UFPFPost *)toPost
            isApproved:(BOOL)isApproved
             isDeleted:(BOOL)isDeleted
               content:(NSString *)content
              fromUser:(PFUser *)fromUser
                 error:(NSError **)error;


+ (UFPFReply *)addReplyToReply:(UFPFReply *)toReply
            isApproved:(BOOL)isApproved
             isDeleted:(BOOL)isDeleted
               content:(NSString *)content
              fromUser:(PFUser *)fromUser
                 error:(NSError **)error;

// 改

+ (BOOL)updateReply:(UFPFReply *)reply content:(NSString *)content error:(NSError **)error;

+ (BOOL)updateReply:(UFPFReply *)reply isDeleted:(BOOL)isDeleted error:(NSError **)error;

+ (BOOL)updateReply:(UFPFReply *)reply isApproved:(BOOL)isApproved error:(NSError **)error;


// 辅助
+ (PFQuery *)buildReplyQueryWhereFromUserIsBlockedByUser:(PFUser *)user;

+ (PFQuery *)buildReplyQueryWhereFromUserIsDeleted;

+ (PFQuery *)buildReplyQueryWhereFromUserIsLocked;

@end

NS_ASSUME_NONNULL_END
