//
//  UFMService+TopicModel.h
//  UnifiedForumModelParseImpl
//
//  Created by XueFeng Chen on 2022/11/16.
//

#import "UFMService.h"

@class UFMTopicModel;
@class UFMUser;

NS_ASSUME_NONNULL_BEGIN

@interface UFMService (Topic)

// 0 无条件，直接查询Topic表，根据orderBy进行排序，例如查询热门的Topic。
+ (NSArray<UFMTopicModel *> *)findTopicModelArrayOrderBy:(NSString *)orderBy
                                      isOrderByAscending:(BOOL)isOrderByAscending
                                                    page:(NSUInteger)page
                                               pageCount:(NSUInteger)pageCount
                                                   error:(NSError **)error;

// 1 根据Category查询，一般用来展示某个板块的内容
+ (NSArray<UFMTopicModel *> *)findTopicModelArrayWithCategory:(NSString *)category
                                                      orderBy:(NSString *)orderBy
                                           isOrderByAscending:(BOOL)isOrderByAscending
                                                         page:(NSUInteger)page
                                                    pageCount:(NSUInteger)pageCount
                                                        error:(NSError **)error;

// 2 根据Tag查询，一般用来展示某个标签的内容
+ (NSArray<UFMTopicModel *> *)findTopicModelArrayWithTag:(NSString *)tag
                                                 orderBy:(NSString *)orderBy
                                      isOrderByAscending:(BOOL)isOrderByAscending
                                                    page:(NSUInteger)page
                                               pageCount:(NSUInteger)pageCount
                                                   error:(NSError **)error;

// 3 根据fromUser查询，一般用来展示某个用户的内容
+ (NSArray<UFMTopicModel *> *)findTopicModelArrayCreatedByUserModel:(UFMUserModel *)userModel
                                                            orderBy:(NSString *)orderBy
                                                 isOrderByAscending:(BOOL)isOrderByAscending
                                                               page:(NSInteger)page
                                                          pageCount:(NSInteger)pageCount
                                                              error:(NSError **)error;

// 4 根据关注，一般用来展示用户关注的内容
+ (NSArray<UFMTopicModel *> *)findTopicModelArrayFollowedByUserModel:(UFMUserModel *)userModel
                                                             orderBy:(NSString *)orderBy
                                                  isOrderByAscending:(BOOL)isOrderByAscending
                                                                page:(NSInteger)page
                                                           pageCount:(NSInteger)pageCount
                                                               error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
