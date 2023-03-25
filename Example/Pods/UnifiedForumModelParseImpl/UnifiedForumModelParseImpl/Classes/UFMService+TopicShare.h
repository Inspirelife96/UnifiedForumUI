//
//  UFMService+TopicModelShare.h
//  UnifiedForumModelParseImpl
//
//  Created by XueFeng Chen on 2022/11/15.
//

#import "UFMService.h"

@class UFMUserModel;
@class UFMTopicModel;

NS_ASSUME_NONNULL_BEGIN

@interface UFMService (TopicShareModel)

+ (void)userModel:(UFMUserModel *)userModel shareTopicModel:(UFMTopicModel *)topicModel toPlatform:(NSString *)toPlatform error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
