//
//  UFMReplyModel.m
//  Bolts
//
//  Created by XueFeng Chen on 2022/10/22.
//

#import "UFMReplyModel.h"

#import "UFMUserModel.h"
#import "UFMPostModel.h"
#import "UFMReplyModel.h"

@implementation UFMReplyModel

- (instancetype)initWithMetaData:(id)metaData error:(NSError **)error {
    if (self = [super initWithMetaData:metaData error:error]) {
        if ([metaData isKindOfClass:[UFPFReply class]]) {
            UFPFReply *reply = (UFPFReply *)metaData;
            
            self.replyId = reply.objectId;
            
            self.content = reply.content;
            
            self.likeCount = [reply.likeCount integerValue];
            
            self.toPostId = reply.toPost.objectId;
            
            self.createdAt = reply.createdAt;
            
            if (reply.toReply) {
                self.toReplyId = reply.toReply.objectId;
            }
            
            PFUser *fromUser = reply.fromUser;
            [fromUser fetchIfNeeded:error];
            if (*error) {
                return nil;
            }
            
            self.fromUserModel = [[UFMUserModel alloc] initWithMetaData:fromUser error:error];
            if (*error) {
                return nil;
            }
            
            UFPFPost *toPost = reply.toPost;
            [toPost fetchIfNeeded:error];
            if (*error) {
                return nil;
            }
            
            PFUser *toUser = reply.toPost.fromUser;
            
            if (reply.toReply) {
                UFPFReply *toReply = reply.toReply;
                [toReply fetchIfNeeded:error];
                if (*error) {
                    return nil;
                }
                toUser = reply.toReply.fromUser;
            }
            
            [toUser fetchIfNeeded:error];
            if (*error) {
                return nil;
            }

            self.toUserModel = [[UFMUserModel alloc] initWithMetaData:toUser error:error];
            if (*error) {
                return nil;
            }
        }
    }
    
    return self;
}

- (instancetype)initWithContent:(NSString *)content
                  fromUserModel:(UFMUserModel *)fromUserModel
                    toPostModel:(UFMPostModel *)toPostModel
                   toReplyModel:(UFMReplyModel *)toReplyModel
                          error:(NSError **)error {
    if (self = [super init]) {
        self.content = content;
        
        self.toPostId = toPostModel.postId;
        self.toUserModel = toPostModel.fromUserModel;
        if (toReplyModel) {
            self.toReplyId = toReplyModel.replyId;
            self.toUserModel = toReplyModel.fromUserModel;
        } else {
            self.toReplyId = nil;
        }

        self.fromUserModel = fromUserModel;

        self.isDeleted = NO;
        self.isApproved = YES;
                
        UFPFReply *reply = [[UFPFReply alloc] init];
        reply.content = content;
        reply.fromUser = (PFUser *)fromUserModel.metaData;
        reply.toPost = (UFPFPost *)toPostModel.metaData;
        if (toReplyModel) {
            reply.toReply = (UFPFReply *)toReplyModel.metaData;
        }
        reply.isDeleted = NO;
        reply.isApproved = YES;
        
        [reply save:error];

        if (!*error) {
            self.metaData = reply;
            self.replyId = reply.objectId;
            self.createdAt = reply.createdAt;
        } else {
            return nil;
        }
    }
    
    return self;
}

- (void)save:(NSError **)error {
    if ([self.metaData isKindOfClass:[UFPFReply class]]) {
        UFPFReply *reply = (UFPFReply *)self.metaData;
        [reply save:error];
    }
}

- (BOOL)isLikedByUserModel:(UFMUserModel *)userModel error:(NSError **)error {
    UFPFReply *reply = (UFPFReply *)self.metaData;
    PFUser *user = (PFUser *)userModel.metaData;
    
    return [UFPFService isReply:reply likedbyUser:user error:error];
}

@end
