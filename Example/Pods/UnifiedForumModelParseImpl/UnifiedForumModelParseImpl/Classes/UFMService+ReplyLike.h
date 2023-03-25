//
//  UFMService+ReplyLike.h
//  UnifiedForumModelParseImpl
//
//  Created by XueFeng Chen on 2022/12/7.
//

#import "UFMService.h"

@class UFMReplyModel;
@class UFMUserModel;

NS_ASSUME_NONNULL_BEGIN

@interface UFMService (ReplyLike)

+ (void)addReplyLikeFromUserModel:(UFMUserModel *)fromUserModel toReplyModel:(UFMReplyModel *)toReplyModel error:(NSError **)error;

+ (void)deleteReplyLikeFromUserModel:(UFMUserModel *)fromUserModel toReplyModel:(UFMReplyModel *)toReplyModel error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
