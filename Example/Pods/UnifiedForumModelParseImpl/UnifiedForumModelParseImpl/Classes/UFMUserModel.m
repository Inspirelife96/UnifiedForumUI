//
//  UFMUserModel.m
//  Bolts
//
//  Created by XueFeng Chen on 2022/10/22.
//

#import "UFMUserModel.h"

#import "UFMFileModel.h"

@implementation UFMUserModel

- (instancetype)initWithMetaData:(id)metaData error:(NSError **)error {
    if (self = [super initWithMetaData:metaData error:error]) {
        NSAssert([metaData isKindOfClass:[PFUser class]], @"metaData type is incorrect");
        
        PFUser *user = (PFUser *)metaData;
        
        self.userId = user.objectId;
        
        self.username = user.username;
        
        self.joinedAt = user.createdAt;
        
        UFPFStatisticsInfo *statisticsInfo = [user objectForKey:@"statisticsInfo"];
        [statisticsInfo fetchIfNeeded:error];
        if (*error) {
            return nil;
        } else {
            self.profileviews = [statisticsInfo.profileViews integerValue];
            self.reputation = [statisticsInfo.reputation integerValue];
            self.topicCount = [statisticsInfo.topicCount integerValue];
            self.postCount = [statisticsInfo.postCount integerValue];
            self.followingCount = [statisticsInfo.followingCount integerValue];
            self.followerCount = [statisticsInfo.followerCount integerValue];
            self.likedCount = [statisticsInfo.likedCount integerValue];
        }
                
        self.isLocked = [[user objectForKey:UFPFUserKeyIsLocked] boolValue];

        self.isDeleted = [[user objectForKey:UFPFUserKeyIsDeleted] boolValue];

        PFFileObject *avatarImageFileObject = [user objectForKey:UFPFUserKeyAvatar];
        if (avatarImageFileObject) {
            self.avatarImageModel = [[UFMFileModel alloc] initWithMetaData:avatarImageFileObject error:nil];
        } else {
            self.avatarImageModel = nil;
        }
        
        PFFileObject *backgroundImageFileObject = [user objectForKey:UFPFUserKeyBackgroundImage];
        if (backgroundImageFileObject) {
            self.backgroundImageModel = [[UFMFileModel alloc] initWithMetaData:backgroundImageFileObject error:nil];
        } else {
            self.backgroundImageModel = nil;
        }
        
        NSString *bio = [user objectForKey:UFPFUserKeyBio];
        if (bio && ![bio isEqualToString:@""]) {
            self.bio = bio;
        } else {
            self.bio = nil;
        }
        
        self.isAnonymousUser = [PFAnonymousUtils isLinkedWithUser:user];
    }
    
    return self;
}

- (BOOL)isEqualToUserModel:(UFMUserModel *)userModel {
    return [self.userId isEqualToString:userModel.userId];
}

- (BOOL)isFollowedByUserModel:(UFMUserModel *)userModel {
    PFUser *fromUser = (PFUser *)userModel.metaData;
    PFUser *toUser = (PFUser *)self.metaData;
    
    NSError *error = nil;
    return [UFPFService isFollowFromUser:fromUser toUser:toUser error:&error];
}

- (void)upgradeBio:(NSString * __nullable)bio avatarImage:(UIImage * __nullable)avatarImage backgroundImage:(UIImage * __nullable)backgroundImage error:(NSError **)error {
    PFUser *currentUser = (PFUser *)self.metaData;
    
    if (bio) {
        [currentUser setObject:bio forKey:UFPFUserKeyBio];
    }
    
    UFMFileModel *newAvatarImageModel = nil;
    UFMFileModel *newBackgroundImageModel = nil;

    if (avatarImage) {
        NSData *avatarImageData = UIImageJPEGRepresentation(avatarImage, 1.0);
        UFMFileModel *avatarImageModel = [[UFMFileModel alloc] initWithFileData:avatarImageData fileType:UFMFileModelTypeImageJPEG error:error];
        if (*error) {
            return;
        } else {
            newAvatarImageModel = avatarImageModel;
            [currentUser setObject:newAvatarImageModel.metaData forKey:UFPFUserKeyAvatar];
        }
    }
    
    if (backgroundImage) {
        NSData *backgroudImage = UIImageJPEGRepresentation(backgroundImage, 1.0);
        UFMFileModel *backgroundImageModel = [[UFMFileModel alloc] initWithFileData:backgroudImage fileType:UFMFileModelTypeImageJPEG error:error];
        if (*error) {
            return;
        } else {
            newBackgroundImageModel = backgroundImageModel;
            [currentUser setObject:backgroundImageModel.metaData forKey:UFPFUserKeyAvatar];
        }
    }
    
    [currentUser save:error];
    
    if (*error) {
        return;
    } else {
        if (bio) {
            self.bio = bio;
        }
        
        if (newAvatarImageModel) {
            self.avatarImageModel = newAvatarImageModel;
        }
        
        if (newBackgroundImageModel) {
            self.backgroundImageModel = newBackgroundImageModel;
        }
    }
    
}

@end
