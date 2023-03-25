//
//  UFUIReplyCellViewModel.m
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2023/2/19.
//

#import "UFUIReplyCellViewModel.h"

#import "UFUIReplyCell.h"

@implementation UFUIReplyCellViewModel

- (instancetype)initWithObjectModel:(UFMObjectModel *)objectModel {
    if (self = [super initWithObjectModel:objectModel]) {
        self.cellIdentifier = NSStringFromClass([UFUIReplyCell class]);
        
        if ([objectModel isKindOfClass:[UFMReplyModel class]]) {
            self.replyModel = (UFMReplyModel *)objectModel;
            
            // 从数据模型中获取fromUserAvatarUrlString
            if (self.replyModel.fromUserModel.avatarImageModel) {
                self.fromUserAvatarUrlString = self.replyModel.fromUserModel.avatarImageModel.url;
            } else {
                self.fromUserAvatarUrlString = nil;
            }

            // 获取用户名
            self.fromUserName = self.replyModel.fromUserModel.username;
            
            // 生成标准的发布时间
            self.postTimeInfo = [self.replyModel.createdAt jk_timeInfo];
            
            // 点赞按钮的标题
            if (self.replyModel.likeCount > 0) {
                self.likeButtonTitle = [NSString stringWithFormat:@"%ld", self.replyModel.likeCount];
            } else {
                self.likeButtonTitle = KUFUILocalization(@"postCell.likeButton.title.default");
            }

            // Post的具体内容
            self.content = self.replyModel.content;
        }
    }
    
    return self;
}

- (void)likeReplyInBackgroundWithBlock:(UFUIBooleanResultBlock)block {
    NSAssert([UFMService currentUserModel], @"likeTopicInBackgroundWithBlock shouldn't be called when [UFMService currentUserModel] is nil");
    
    WEAKSELF
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        STRONGSELF
        NSError *error = nil;
        BOOL succeeded = YES;
        
        if (strongSelf.isLikedByCurrentUser) {
            [UFMService deleteReplyLikeFromUserModel:[UFMService currentUserModel] toReplyModel:self.replyModel error:&error];
            if (!error) {
                strongSelf.isLikedByCurrentUser = NO;
            }
        } else {
            [UFMService addReplyLikeFromUserModel:[UFMService currentUserModel] toReplyModel:self.replyModel error:&error];
            if (!error) {
                strongSelf.isLikedByCurrentUser = YES;
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            block(succeeded, error);
        });
    });
}

- (void)setIsLikedByCurrentUser:(BOOL)isLikedByCurrentUser {
    _isLikedByCurrentUser = isLikedByCurrentUser;
    
    if (self.replyModel.likeCount > 0) {
        self.likeButtonTitle = [NSString stringWithFormat:@"%ld", self.replyModel.likeCount];
    } else {
        self.likeButtonTitle = KUFUILocalization(@"postCell.likeButton.title.default");
    }
    
    if (_isLikedByCurrentUser) {
        _likeButtonTintColor = [UIColor redColor];
        _likeButtonTitleColor = [UIColor redColor];
    } else {
        _likeButtonTintColor = [UIColor labelColor];
        _likeButtonTitleColor = [UIColor secondaryLabelColor];
    }
}

- (void)reportReplyInBackgroundWithBlock:(UFUIBooleanResultBlock)block {
    // Todo:
}

@end
