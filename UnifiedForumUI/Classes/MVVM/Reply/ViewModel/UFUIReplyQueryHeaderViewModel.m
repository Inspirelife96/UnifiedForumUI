//
//  UFUIReplyQueryHeaderViewModel.m
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2023/2/19.
//

#import "UFUIReplyQueryHeaderViewModel.h"

#import "UFUIPostCell.h"

#import "UFMObjectModel.h"
#import "UFMFileModel.h"
#import "UFMPostModel.h"
#import "UFMReplyModel.h"

#import "UFUIImageFileCellViewModel.h"
#import "UFUISimpleReplyCellViewModel.h"

#import "UFUIConstants.h"

@implementation UFUIReplyQueryHeaderViewModel

- (instancetype)initWithPostModel:(UFMPostModel *)postModel {
    if (self = [super init]) {
        self.postModel = postModel;
        
        // 从数据模型中获取fromUserAvatarUrlString
        if (self.postModel.fromUserModel.avatarImageModel) {
            self.fromUserAvatarUrlString = self.postModel.fromUserModel.avatarImageModel.url;
        } else {
            self.fromUserAvatarUrlString = nil;
        }

        // 获取用户名
        self.fromUserName = self.postModel.fromUserModel.username;
        
        // 生成标准的发布时间
        self.postTimeInfo = [self.postModel.createdAt jk_timeInfo];
        
        // 点赞按钮的标题
        if (self.postModel.likeCount > 0) {
            self.likeButtonTitle = [NSString stringWithFormat:@"%ld", self.postModel.likeCount];
        } else {
            self.likeButtonTitle = KUFUILocalization(@"postCell.likeButton.title.default");
        }

        // Post的具体内容
        self.content = self.postModel.content;

        [self sizeFileCollectionView];
    }
    
    return self;
}

- (void)sizeFileCollectionView {
    // 基于self.postModel.fileModelArray生成fileCellVMArray和imageDataArray
    NSMutableArray *fileCellVMMutableArray = [[NSMutableArray alloc] init];
    NSMutableArray *imageDataMutableArray = [[NSMutableArray alloc] init];
    
    NSArray *fileModelArray = self.postModel.fileModelArray;
    
    [fileModelArray enumerateObjectsUsingBlock:^(UFMFileModel   * _Nonnull fileModel, NSUInteger idx, BOOL * _Nonnull stop) {
        UFUIImageFileCellViewModel *fileVM = [[UFUIImageFileCellViewModel alloc] initWithFileModel:fileModel fileCellStyle:UFUIImageFileCellStylePost];
        [fileCellVMMutableArray addObject:fileVM];
        
        YBIBImageData *imageData = [[YBIBImageData alloc] init];
        imageData.imageURL = [NSURL URLWithString:fileModel.url];
        [imageDataMutableArray addObject:imageData];
    }];
    
    self.fileCellVMArray = [fileCellVMMutableArray copy];
    self.imageDataArray = [imageDataMutableArray copy];
    
    // 基于获取的图片，计算FileContentCollectionView的大小
    self.fileCollectionViewSize = [self calculateFileContentCollectionViewSize];
}

- (CGSize)calculateFileContentCollectionViewSize {
    if (self.fileCellVMArray.count == 0) {
        return CGSizeZero;
    }
    
    NSArray *fileModelArray = self.postModel.fileModelArray;
    
    __block CGFloat mdiaContentCollectionViewWidth = 0;
    __block CGFloat mdiaContentCollectionViewHeight = 0;
    
    [self.fileCellVMArray enumerateObjectsUsingBlock:^(UFUIImageFileCellViewModel *  _Nonnull fileContentCellVM, NSUInteger idx, BOOL * _Nonnull stop) {
        // FileContentCell的高度
        mdiaContentCollectionViewHeight += fileContentCellVM.size.height;
        
        // 间距
        if (idx == fileModelArray.count - 1) {
            mdiaContentCollectionViewWidth = fileContentCellVM.size.width;
        } else {
            mdiaContentCollectionViewHeight += 10.0f;
        }
    }];
    
    return CGSizeMake(mdiaContentCollectionViewWidth, mdiaContentCollectionViewHeight);
}

- (void)likePostInBackgroundWithBlock:(UFUIBooleanResultBlock)block {
    NSAssert([UFMService currentUserModel], @"likeTopicInBackgroundWithBlock shouldn't be called when [UFMService currentUserModel] is nil");
    
    WEAKSELF
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        STRONGSELF
        NSError *error = nil;
        BOOL succeeded = YES;
        
        if (strongSelf.isLikedByCurrentUser) {
            [UFMService deletePostLikeFromUserModel:[UFMService currentUserModel] toPostModel:self.postModel error:&error];
            if (!error) {
                strongSelf.isLikedByCurrentUser = NO;
            }
        } else {
            [UFMService addPostLikeFromUserModel:[UFMService currentUserModel] toPostModel:self.postModel error:&error];
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
    
    if (self.postModel.likeCount > 0) {
        self.likeButtonTitle = [NSString stringWithFormat:@"%ld", self.postModel.likeCount];
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

@end
