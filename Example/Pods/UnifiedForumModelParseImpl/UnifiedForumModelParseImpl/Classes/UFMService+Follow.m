//
//  UFMService+Follow.m
//  UnifiedForumModelParseImpl
//
//  Created by XueFeng Chen on 2022/12/10.
//

#import "UFMService+Follow.h"

#import "UFMUserModel.h"

@implementation UFMService (Follow)

+ (void)addFollowFromUserModel:(UFMUserModel *)fromUserModel toUserModel:(UFMUserModel *)toUserModel error:(NSError **)error {
    PFUser *fromUser = (PFUser *)fromUserModel.metaData;
    PFUser *toUser = (PFUser *)toUserModel.metaData;
    [UFPFService addFollowFromUser:fromUser toUser:toUser error:error];
}

+ (void)deleteFollowFromUserModel:(UFMUserModel *)fromUserModel toUserModel:(UFMUserModel *)toUserModel error:(NSError **)error {
    PFUser *fromUser = (PFUser *)fromUserModel.metaData;
    PFUser *toUser = (PFUser *)toUserModel.metaData;
    [UFPFService deleteFollowFromUser:fromUser toUser:toUser error:error];
}

@end
