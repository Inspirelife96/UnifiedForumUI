//
//  UFMService+PostLike.m
//  UnifiedForumModelParseImpl
//
//  Created by XueFeng Chen on 2022/12/5.
//

#import "UFMService+PostLike.h"

#import "UFMUserModel.h"
#import "UFMPostModel.h"

@implementation UFMService (PostLike)

+ (void)addPostLikeFromUserModel:(UFMUserModel *)fromUserModel toPostModel:(UFMPostModel *)toPostModel error:(NSError **)error {
    PFUser *fromUser = (PFUser *)fromUserModel.metaData;
    UFPFPost *toPost = (UFPFPost *)toPostModel.metaData;
    [UFPFService addPostLikeWithFromUser:fromUser toPost:toPost error:error];
    if (!*error){
        toPostModel.likeCount++;
    }
}

+ (void)deletePostLikeFromUserModel:(UFMUserModel *)fromUserModel toPostModel:(UFMPostModel *)toPostModel error:(NSError **)error {
    PFUser *fromUser = (PFUser *)fromUserModel.metaData;
    UFPFPost *toPost = (UFPFPost *)toPostModel.metaData;
    [UFPFService deletePostLikeFromUser:fromUser toPost:toPost error:error];
    if (!*error){
        toPostModel.likeCount--;
    }
}

@end
