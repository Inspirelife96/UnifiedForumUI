//
//  UFMService+ReplyModel.h
//  UnifiedForumModelParseImpl
//
//  Created by XueFeng Chen on 2023/2/19.
//

#import "UFMService.h"

@class UFMPostModel;
@class UFMReplyModel;

NS_ASSUME_NONNULL_BEGIN

@interface UFMService (ReplyModel)

// - 查询某一个Post的回复
+ (NSArray<UFMReplyModel *> *)findReplyModelArrayToPost:(UFMPostModel *)toPostModel
                                                orderBy:(NSString *)orderBy
                                     isOrderByAscending:(BOOL)isOrderByAscending
                                                   page:(NSInteger)page
                                              pageCount:(NSInteger)pageCount
                                                  error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
