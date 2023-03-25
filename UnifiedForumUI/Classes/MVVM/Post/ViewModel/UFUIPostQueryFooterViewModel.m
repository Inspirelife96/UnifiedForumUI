//
//  UFUIPostQueryFooterViewModel.m
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2022/12/12.
//

#import "UFUIPostQueryFooterViewModel.h"

#import "UFUIConstants.h"

@implementation UFUIPostQueryFooterViewModel

- (instancetype)initWithTopicModel:(UFMTopicModel *)topicModel {
    self.topicModel = topicModel;
    
    self.isLikedByCurrentUser = NO;

    if ([UFMService currentUserModel]) {
        WEAKSELF
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            STRONGSELF
            NSError *error = nil;
            BOOL isLikedByCurrentUser = [topicModel isLikedByUserModel:[UFMService currentUserModel] error:&error];
            if (!error && self.isLikedByCurrentUser != isLikedByCurrentUser) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    strongSelf.isLikedByCurrentUser = isLikedByCurrentUser;
                });
            }
        });
    }
    
    return self;
}

- (void)likeTopicInBackgroundWithBlock:(void(^)(NSError *_Nullable error))block {
    NSAssert([UFMService currentUserModel], @"likeTopicInBackgroundWithBlock shouldn't be called when [UFMService currentUserModel] is nil");
    
    WEAKSELF
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        STRONGSELF
        NSError *error = nil;
        
        if (strongSelf.isLikedByCurrentUser) {
            [UFMService deleteTopicLikeFromUserModel:[UFMService currentUserModel] toTopicModel:self.topicModel error:&error];
            if (!error) {
                strongSelf.isLikedByCurrentUser = NO;
            }
        } else {
            [UFMService addTopicLikeFromUserModel:[UFMService currentUserModel] toTopicModel:self.topicModel error:&error];
            if (!error) {
                strongSelf.isLikedByCurrentUser = YES;
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            block(error);
        });
    });
}

- (void)shareTopicToPlatformInBackgound:(NSString *)toPlatform withBlock:(void(^)(NSError *_Nullable error))block {
    WEAKSELF
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        STRONGSELF
        NSError *error = nil;
        
        [UFMService userModel:[UFMService currentUserModel] shareTopicModel:strongSelf.topicModel toPlatform:toPlatform error:&error];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            block(error);
        });
    });
}

- (void)setIsLikedByCurrentUser:(BOOL)isLikedByCurrentUser {
    _isLikedByCurrentUser = isLikedByCurrentUser;
    
    if (_isLikedByCurrentUser) {
        self.likeButtonTintColor = [UIColor redColor];
    } else {
        self.likeButtonTintColor = [UIColor linkColor];
    }
}



@end
