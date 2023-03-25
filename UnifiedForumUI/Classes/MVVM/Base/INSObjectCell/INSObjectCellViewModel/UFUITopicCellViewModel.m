//
//  UFUITopicCellViewModel.m
//  INSParseUI
//
//  Created by XueFeng Chen on 2022/2/15.
//

#import "UFUITopicCellViewModel.h"

#import "UFUITopicCell.h"

#import "UFUIImageFileCellViewModel.h"

#import "UFUIConstants.h"

@implementation UFUITopicCellViewModel

#pragma mark Init

- (instancetype)initWithObjectModel:(UFMObjectModel *)objectModel {
    if (self = [super initWithObjectModel:objectModel]) {
        if ([objectModel isKindOfClass:[UFMTopicModel class]]) {
            // 重要，这个CellViewModel对应的是UFUITopicCell，必须设置
            self.cellIdentifier = NSStringFromClass([UFUITopicCell class]);
            self.topicModel = (UFMTopicModel *)objectModel;
            
            if (self.topicModel.fromUserModel.avatarImageModel) {
                self.fromUserAvatarUrlString = self.topicModel.fromUserModel.avatarImageModel.url;
            } else {
                self.fromUserAvatarUrlString = nil;
            }
            
            self.fromUserName = self.topicModel.fromUserModel.username;
            self.postTimeInfo = [self.topicModel.createdAt jk_timeInfo];
            
            self.title = self.topicModel.title;
            self.content = self.topicModel.content;
            
            NSMutableArray *fileCellVMMutableArray = [[NSMutableArray alloc] init];
            NSMutableArray *imageDataMutableArray = [[NSMutableArray alloc] init];
            NSArray *fileModelArray = self.topicModel.fileModelArray;
            
            // 根据图片数量，来设定UFUIImageFileCellViewModel
            // 多图模式和单图模式
            UFUIImageFileCellStyle fileCellStyle = UFUIImageFileCellStyleTopicBriefMultiple;
            if (fileModelArray.count == 1) {
                fileCellStyle = UFUIImageFileCellStyleTopicBriefSingle;
            }
            
            [fileModelArray enumerateObjectsUsingBlock:^(UFMFileModel  * _Nonnull fileModel, NSUInteger idx, BOOL * _Nonnull stop) {
                UFUIImageFileCellViewModel *fileCellVM = [[UFUIImageFileCellViewModel alloc] initWithFileModel:fileModel fileCellStyle:fileCellStyle];
                [fileCellVMMutableArray addObject:fileCellVM];
                
                YBIBImageData *imageData = [[YBIBImageData alloc] init];
                imageData.imageURL = [NSURL URLWithString:fileModel.url];
                [imageDataMutableArray addObject:imageData];
            }];
            
            self.fileCellVMArray = [fileCellVMMutableArray copy];
            
            // 计算图片内容给的Size
            // UITableView内嵌UICollectionView，两个内容的高度同时动态高度自适应的实现是有问题的
            // 因此还是推荐UITableView高度自适应，UICollectionView的高度提前进行计算。
            self.fileCollectionViewSize = [self _calculateFileCollectionViewSize];
            
            self.imageDataArray = [imageDataMutableArray copy];
            
            [self _updateCommentButtonTitle];
            [self _updateShareButtonTitle];
            
            // 默认情况下是NO
            self.isLikedByCurrentUser = NO;
            
            // 如果登录，则需要查询当前登录用户是否喜欢这个Topic
            if ([UFMService currentUserModel]) {
                NSError *error = nil;
                // todo:下面这样暂时注释掉了。等修正了再恢复
                //self.isLikedByCurrentUser = [self.topicModel isLikedByUserModel:[UFMService currentUserModel] error:&error];
            }
        }
    }
    
    return self;
}

#pragma mark Private Methods

- (CGSize)_calculateFileCollectionViewSize {
    if (self.fileCellVMArray.count == 0) {
        return CGSizeZero;
    }
    
    if (self.fileCellVMArray.count == 1) {
        UFUIImageFileCellViewModel *fileCellVM = self.fileCellVMArray[0];
        return fileCellVM.size;
    } else {
        __block CGFloat fileCollectionViewWidth = 0;
        __block CGFloat fileCollectionViewHeight = 0;
        
        [self.fileCellVMArray enumerateObjectsUsingBlock:^(UFUIImageFileCellViewModel *  _Nonnull fileCellVM, NSUInteger idx, BOOL * _Nonnull stop) {
            fileCollectionViewWidth += fileCellVM.size.width;
            if (idx == self.fileCellVMArray.count - 1) {
                fileCollectionViewHeight = fileCellVM.size.height;
            } else {
                fileCollectionViewWidth += 5.0f;
            }
        }];
        
        return CGSizeMake(fileCollectionViewWidth, fileCollectionViewHeight);
    }
}

- (void)_updateCommentButtonTitle {
    if (self.topicModel.postCount > 0) {
        self.postButtonTitle = [NSString stringWithFormat:@"%ld", self.topicModel.postCount];
    } else {
        self.postButtonTitle = KUFUILocalization(@"topicCell.postButton.title.default");
    }
}

- (void)_updateShareButtonTitle {
    if (self.topicModel.shareCount > 0) {
        self.shareButtonTitle = [NSString stringWithFormat:@"%ld", self.topicModel.shareCount];
    } else {
        self.shareButtonTitle = KUFUILocalization(@"topicCell.shareButton.title.default");
    }
}

#pragma mark Public Methods

- (void)likeTopicInBackgroundWithBlock:(UFUIBooleanResultBlock)block {
    NSAssert([UFMService currentUserModel], @"likeTopicInBackgroundWithBlock shouldn't be called when [UFMService currentUserModel] is nil");
    
    WEAKSELF
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        STRONGSELF
        NSError *error = nil;
        BOOL succeeded = YES;
        
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
            block(succeeded, error);
        });
    });
}

- (void)shareTopicToPlatformInBackgound:(NSString *)toPlatform withBlock:(UFUIBooleanResultBlock)block {
    WEAKSELF
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        STRONGSELF
        NSError *error = nil;
        BOOL succeeded = YES;
        
        [UFMService userModel:[UFMService currentUserModel] shareTopicModel:strongSelf.topicModel toPlatform:toPlatform error:&error];
        
        if (!error) {
            [self _updateShareButtonTitle];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            block(succeeded, error);
        });
    });
}


#pragma mark Getter/Setter

- (void)setIsLikedByCurrentUser:(BOOL)isLikedByCurrentUser {
    _isLikedByCurrentUser = isLikedByCurrentUser;
    
    if (self.topicModel.likeCount > 0) {
        self.likeButtonTitle = [NSString stringWithFormat:@"%ld", self.topicModel.likeCount];
    } else {
        self.likeButtonTitle = KUFUILocalization(@"topicCell.likeButton.title.default");
    }
    
    if (_isLikedByCurrentUser) {
        _likeButtonTintColor = [UIColor redColor];
        _likeButtonTitleColor = [UIColor redColor];
    } else {
        _likeButtonTintColor = [UIColor labelColor];
        _likeButtonTitleColor = [UIColor secondaryLabelColor];
    }
}

#pragma mark Legacy

//- (void)publicTopicInBackgroundWithBlock:(UFUIBooleanResultBlock)block {
//    [self _updateTopicStatusInBackground:@(INSParseRecordStatusPublic) withBlock:^(BOOL succeeded, NSError * _Nullable error) {
//        block(succeeded, error);
//    }];
//}
//
//- (void)banTopicInBackgroundWithBlock:(UFUIBooleanResultBlock)block {
//    [self _updateTopicStatusInBackground:@(INSParseRecordStatusBanned) withBlock:^(BOOL succeeded, NSError * _Nullable error) {
//        block(succeeded, error);
//    }];
//}
//
//- (void)_updateTopicStatusInBackground:(NSNumber *)status withBlock:(UFUIBooleanResultBlock)block {
//    NSAssert([PFUser currentUser], @"_updateTopicStatusInBackground shouldn't be called when [PFUser currentUser] is nil");
//
//    WEAKSELF
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        STRONGSELF
//        NSError *error = nil;
//        UFMTopicModel *topicModel = (UFMTopicModel *)strongSelf.objectModel;
//
//        BOOL succeeded = [INSParseOperationManager updateTopic:topicModel.topic toStatus:status error:&error];
//        if (succeeded) {
////            strongSelf.status = status;
//        }
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//            block(succeeded, error);
//        });
//    });
//}

//- (void)reportTopicForReasonInBackground:(INSParseReportReason)reason withBlock:(UFUIBooleanResultBlock)block {
//    NSAssert([PFUser currentUser], @"reportTopicForReasonInBackground shouldn't be called when [PFUser currentUser] is nil");
//
//    WEAKSELF
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        STRONGSELF
//        NSError *error = nil;
////        UFMTopicModel * topicModel = (UFMTopicModel *)strongSelf.objectModel;
//
//        BOOL succeeded = [INSNetworkManager reportTopic:self.topicModel fromUser:[INSNetworkManager currentUserModel] forReason:reason error:&error];
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//            block(succeeded, error);
//        });
//    });
//}

@end
