//
//  UFMTimeLineModel.m
//  UnifiedForumModelParseImpl
//
//  Created by XueFeng Chen on 2023/2/19.
//

#import "UFMTimeLineModel.h"

#import "UFMUserModel.h"
#import "UFMTopicModel.h"
#import "UFMPostModel.h"
#import "UFMReplyModel.h"

@implementation UFMTimeLineModel

- (instancetype)initWithMetaData:(id)metaData error:(NSError **)error {
    if (self = [super initWithMetaData:metaData error:error]) {
        // 如果是metaData是UFPFTimeLine类型的，可以进行如下的转换
        if ([metaData isKindOfClass:[UFPFTimeLine class]]) {
            UFPFTimeLine *timeLine = (UFPFTimeLine *)metaData;
            
            self.timeLineId = timeLine.objectId;
            
            PFUser *fromUser = timeLine.fromUser;
            [fromUser fetchIfNeeded:error];
            if (*error) {
                return nil;
            }
            
            self.fromUserModel = [[UFMUserModel alloc] initWithMetaData:fromUser error:error];
            if (*error) {
                return nil;
            }
            
            PFUser *toUser = timeLine.toUser;
            [toUser fetchIfNeeded:error];
            if (*error) {
                return nil;
            }
            
            self.toUserModel = [[UFMUserModel alloc] initWithMetaData:toUser error:error];
            if (*error) {
                return nil;
            }
            
            self.createdAt = timeLine.createdAt;
            self.isDeleted = timeLine.isDeleted;
            
            self.type = timeLine.type;
            
            UFPFTopic *topic = timeLine.topic;
            if (topic) {
                self.topicModel = [[UFMTopicModel alloc] initWithMetaData:topic error:error];
                if (*error) {
                    return nil;
                }
            }
            
            UFPFPost *post = timeLine.post;
            if (post) {
                self.postModel = [[UFMPostModel alloc] initWithMetaData:post error:error];
                if (*error) {
                    return nil;
                }
            }
            
            UFPFReply *reply = timeLine.reply;
            if (reply) {
                self.replyModel = [[UFMReplyModel alloc] initWithMetaData:reply error:error];
                if (*error) {
                    return nil;
                }
            }
        }
    }
    
    return self;
}

@end
