//
//  UFUIPostQueryHeaderViewModel.m
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2022/12/12.
//

#import "UFUIPostQueryHeaderViewModel.h"

#import "UFUIConstants.h"

#import "UFUIImageFileCellViewModel.h"

@implementation UFUIPostQueryHeaderViewModel

- (instancetype)initWithTopicModel:(UFMTopicModel *)topicModel {
    self.topicModel = topicModel;
    
    self.title = topicModel.title;
    
    if (topicModel.fromUserModel.avatarImageModel) {
        self.fromUserAvatarUrlString = topicModel.fromUserModel.avatarImageModel.url;
    } else {
        self.fromUserAvatarUrlString = nil;
    }
    
    self.fromUserName = topicModel.fromUserModel.username;
    self.postTimeInfo = [topicModel.createdAt jk_timeInfo];
    
    self.content = topicModel.content;
    
    NSMutableArray *fileCellVMMutableArray = [[NSMutableArray alloc] init];
    NSMutableArray *imageDataMutableArray = [[NSMutableArray alloc] init];
    NSArray *fileModelArray = topicModel.fileModelArray;
    
    [fileModelArray enumerateObjectsUsingBlock:^(UFMFileModel   * _Nonnull fileModel, NSUInteger idx, BOOL * _Nonnull stop) {
        UFUIImageFileCellViewModel *fileCellVM = [[UFUIImageFileCellViewModel alloc] initWithFileModel:fileModel fileCellStyle:UFUIImageFileCellStyleTopicStandard];
        [fileCellVMMutableArray addObject:fileCellVM];
        
        YBIBImageData *imageData = [[YBIBImageData alloc] init];
        imageData.imageURL = [NSURL URLWithString:fileModel.url];
        [imageDataMutableArray addObject:imageData];
    }];
    
    self.fileCellVMArray = [fileCellVMMutableArray copy];
    self.imageDataArray = [imageDataMutableArray copy];
    
    self.fileContentCollectionViewSize = [self _calculateFileContentCollectionViewSize];
    
    self.isFollowedByCurrentUser = NO;
    self.isFollowStatusButtonHidden = NO;
    
    // 当前如果是登录状态，那么首先查看作者和登录者是否一致
    // 一致的话，则不显示Follow按钮
    // 否则查看是否Follow
    if ([UFMService currentUserModel]) {
        self.isFollowStatusButtonHidden = [topicModel.fromUserModel isEqualToUserModel:[UFMService currentUserModel]];
        
        // 只有在FollowStatusButton不是隐藏状态下，才需要检查Follow的状态
        if (!self.isFollowStatusButtonHidden) {
            WEAKSELF
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                STRONGSELF
                BOOL isFollowedByCurrentUser = [topicModel.fromUserModel isFollowedByUserModel:[UFMService currentUserModel]];
                
                if(self.isFollowedByCurrentUser != isFollowedByCurrentUser) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        strongSelf.isFollowedByCurrentUser = isFollowedByCurrentUser;
                    });
                }
            });
        }
    }
    
    return self;
}

- (CGSize)_calculateFileContentCollectionViewSize {
    if (self.fileCellVMArray.count == 0) {
        return CGSizeZero;
    }
    
    __block CGFloat mdiaContentCollectionViewWidth = 0;
    __block CGFloat mdiaContentCollectionViewHeight = 0;
    
    [self.fileCellVMArray enumerateObjectsUsingBlock:^(UFUIImageFileCellViewModel *  _Nonnull meidaContentCellVM, NSUInteger idx, BOOL * _Nonnull stop) {
        mdiaContentCollectionViewHeight += meidaContentCellVM.size.height;
        if (idx == self.fileCellVMArray.count - 1) {
            mdiaContentCollectionViewWidth = meidaContentCellVM.size.width;
        } else {
            mdiaContentCollectionViewHeight += 10.0f;
        }
    }];
    
    return CGSizeMake(mdiaContentCollectionViewWidth, mdiaContentCollectionViewHeight);
}

- (void)changeIsFollowedByCurrentUserInbackgroundWithBlock:(void(^)(NSError *_Nullable error))block {
    NSAssert([UFMService currentUserModel], @"likeTopicInBackgroundWithBlock shouldn't be called when [UFMService currentUserModel] is nil");
    
    WEAKSELF
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        STRONGSELF
        NSError *error = nil;
        
        if (strongSelf.isFollowedByCurrentUser) {
            [UFMService deleteFollowFromUserModel:[UFMService currentUserModel] toUserModel:self.topicModel.fromUserModel error:&error];
            if (!error) {
                strongSelf.isFollowedByCurrentUser = NO;
            }
        } else {
            [UFMService addFollowFromUserModel:[UFMService currentUserModel] toUserModel:self.topicModel.fromUserModel error:&error];
            if (!error) {
                strongSelf.isFollowedByCurrentUser = YES;
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            block(error);
        });
    });
}

- (void)setIsFollowedByCurrentUser:(BOOL)isFollowedByCurrentUser {
    _isFollowedByCurrentUser = isFollowedByCurrentUser;
    
    if (_isFollowedByCurrentUser) {
        self.followStatusButtonTitle = KUFUILocalization(@"postQueryHeaderView.followStatusButton.title.followed");
        self.follwStatusButtonBackgroundColor = [UIColor linkColor];
        self.followStatusButtonTitleColor = [UIColor systemBackgroundColor];
    } else {
        self.followStatusButtonTitle = KUFUILocalization(@"postQueryHeaderView.followStatusButton.title.follow");
        self.follwStatusButtonBackgroundColor = [UIColor secondarySystemBackgroundColor];
        self.followStatusButtonTitleColor = [UIColor secondaryLabelColor];
    }
}

@end
