//
//  UFMService+TopicModelLike.h
//  UnifiedForumModelParseImpl
//
//  Created by XueFeng Chen on 2022/11/15.
//

#import "UFMService.h"

@class UFMUserModel;
@class UFMTopicModel;

NS_ASSUME_NONNULL_BEGIN

@interface UFMService (TopicLikeModel)

+ (void)addTopicLikeFromUserModel:(UFMUserModel *)fromUserModel toTopicModel:(UFMTopicModel *)toTopicModel error:(NSError **)error;

+ (void)deleteTopicLikeFromUserModel:(UFMUserModel *)fromUserModel toTopicModel:(UFMTopicModel *)toTopicModel error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
