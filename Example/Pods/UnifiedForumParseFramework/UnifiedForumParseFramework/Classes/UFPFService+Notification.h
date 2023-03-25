//
//  UFPFService+Notification.h
//  UFPFParse
//
//  Created by XueFeng Chen on 2022/5/28.
//

#import "UFPFService.h"

NS_ASSUME_NONNULL_BEGIN

@class UFPFTopic;
@class UFPFPost;
@class UFPFReply;
@class UFPFMessageGroup;
@class UFPFNotification;

@interface UFPFService (Notification)

+ (NSArray<UFPFNotification *> *)findCommentNotificationToUser:(PFUser *)toUser
                                                         page:(NSInteger)page
                                                    pageCount:(NSInteger)pageCount
                                                        error:(NSError **)error;

+ (NSArray<UFPFNotification *> *)findLikeNotificationToUser:(PFUser *)toUser
                                                      page:(NSInteger)page
                                                 pageCount:(NSInteger)pageCount
                                                     error:(NSError **)error;

+ (NSArray<UFPFNotification *> *)findFollowNotificationToUser:(PFUser *)toUser
                                                        page:(NSInteger)page
                                                   pageCount:(NSInteger)pageCount
                                                       error:(NSError **)error;

+ (NSArray<UFPFNotification *> *)findMessageGroupNotificationToUser:(PFUser *)toUser
                                                              page:(NSInteger)page
                                                         pageCount:(NSInteger)pageCount
                                                             error:(NSError **)error;

+ (NSArray<UFPFNotification *> *)findOtherNotificationToUser:(PFUser *)toUser
                                                       page:(NSInteger)page
                                                  pageCount:(NSInteger)pageCount
                                                      error:(NSError **)error;

// 部分在客户端实现，部分会在服务器端实现
+ (BOOL)addNotificationFromUser:(PFUser *)fromUser
                         toUser:(PFUser *)toUser
                           type:(NSString *)type
                        subType:(NSString *)subType
                          topic:(UFPFTopic * _Nullable)topic
                           post:(UFPFPost * _Nullable)post
                          reply:(UFPFReply * _Nullable)reply
                   messageGroup:(UFPFMessageGroup * _Nullable)messageGroup
                          error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
