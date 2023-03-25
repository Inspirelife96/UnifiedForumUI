//
//  UFMService+PostModel.h
//  UnifiedForumModelParseImpl
//
//  Created by XueFeng Chen on 2022/11/16.
//

#import "UFMService.h"

NS_ASSUME_NONNULL_BEGIN

@class UFMTopicModel;
@class UFMPostModel;
@class UFMUserModel;

@interface UFMService (Post)

// - 查询某一个Topic的回帖
+ (NSArray<UFMPostModel *> *)findPostModelArrayToTopic:(UFMTopicModel *)toTopicModel
                                               orderBy:(NSString *)orderBy
                                    isOrderByAscending:(BOOL)isOrderByAscending
                                                  page:(NSInteger)page
                                             pageCount:(NSInteger)pageCount
                                                 error:(NSError **)error;

// - 查询某一个Topic下某个人的所有回贴 - 例如：即只看楼主的功能
+ (NSArray<UFMPostModel *> *)findPostModelArrayToTopic:(UFMTopicModel *)toTopicModel
                                         fromUserModel:(UFMUserModel *)fromUserModel
                                               orderBy:(NSString *)orderBy
                                    isOrderByAscending:(BOOL)isOrderByAscending
                                                  page:(NSInteger)page
                                             pageCount:(NSInteger)pageCount
                                                 error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
