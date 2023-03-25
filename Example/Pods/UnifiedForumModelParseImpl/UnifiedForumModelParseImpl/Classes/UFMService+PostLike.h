//
//  UFMService+PostLike.h
//  UnifiedForumModelParseImpl
//
//  Created by XueFeng Chen on 2022/12/5.
//

#import "UFMService.h"

@class UFMUserModel;
@class UFMPostModel;

NS_ASSUME_NONNULL_BEGIN

@interface UFMService (PostLike)

+ (void)addPostLikeFromUserModel:(UFMUserModel *)fromUserModel toPostModel:(UFMPostModel *)toPostModel error:(NSError **)error;

+ (void)deletePostLikeFromUserModel:(UFMUserModel *)fromUserModel toPostModel:(UFMPostModel *)toPostModel error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
