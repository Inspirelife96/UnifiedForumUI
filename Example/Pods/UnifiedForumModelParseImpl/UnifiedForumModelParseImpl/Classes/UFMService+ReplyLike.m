//
//  UFMService+ReplyLike.m
//  UnifiedForumModelParseImpl
//
//  Created by XueFeng Chen on 2022/12/7.
//

#import "UFMService+ReplyLike.h"

#import "UFMUserModel.h"
#import "UFMReplyModel.h"

@implementation UFMService (ReplyLike)

+ (void)addReplyLikeFromUserModel:(UFMUserModel *)fromUserModel toReplyModel:(UFMReplyModel *)toReplyModel error:(NSError **)error {
    PFUser *fromUser = (PFUser *)fromUserModel.metaData;
    UFPFReply *toReply = (UFPFReply *)toReplyModel.metaData;
    [UFPFService addReplyLikeWithFromUser:fromUser toReply:toReply error:error];
    if (!*error) {
        toReplyModel.likeCount++;
    }
}

+ (void)deleteReplyLikeFromUserModel:(UFMUserModel *)fromUserModel toReplyModel:(UFMReplyModel *)toReplyModel error:(NSError **)error {
    PFUser *fromUser = (PFUser *)fromUserModel.metaData;
    UFPFReply *toReply = (UFPFReply *)toReplyModel.metaData;
    [UFPFService deleteReplyLikeFromUser:fromUser toReply:toReply error:error];
    if (!*error) {
        toReplyModel.likeCount--;
    }
}

@end
