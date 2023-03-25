//
//  UFMService+TopicModelShare.m
//  UnifiedForumModelParseImpl
//
//  Created by XueFeng Chen on 2022/11/15.
//

#import "UFMService+TopicShare.h"

#import "UFMUserModel.h"
#import "UFMTopicModel.h"

@implementation UFMService (TopicShareModel)

+ (void)userModel:(UFMUserModel *)userModel shareTopicModel:(UFMTopicModel *)topicModel toPlatform:(NSString *)toPlatform error:(NSError **)error {
    PFUser *fromUser = (PFUser *)userModel.metaData;
    UFPFTopic *topic = (UFPFTopic *)topicModel.metaData;
    
    [UFPFService addShareTopic:topic fromUser:fromUser toPlatform:toPlatform error:error];
    
    if (!*error) {
        topicModel.shareCount++;
    }
}

@end
