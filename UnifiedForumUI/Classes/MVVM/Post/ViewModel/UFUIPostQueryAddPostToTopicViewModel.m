//
//  UFUIPostQueryAddPostToTopicViewModel.m
//  INSParseUI
//
//  Created by XueFeng Chen on 2022/1/22.
//

#import "UFUIPostQueryAddPostToTopicViewModel.h"

#import "UFMTopicModel.h"

#import "UFUIImagePickerModel.h"

@implementation UFUIPostQueryAddPostToTopicViewModel

#pragma mark init

- (instancetype)initWithTopicModel:(UFMTopicModel *)topicModel {
    if (self = [super init]) {
        _toTopicModel = topicModel;
        
        _toLabelText = [NSString stringWithFormat:KUFUILocalization(@"addPostView.titleLabel.text"),  topicModel.fromUserModel.username];
        
        _selectedPhotoCollectionViewViewItemSpacing = 5.0f;
        _selectedPhotoCollectionViewViewLineSpacing = 5.0f;
        
        [self clear];
    }
    
    return self;
}

#pragma mark Public Methods

- (CGSize)pickedPhotoCellSize {
    if (self.imagePickerModel.selectedPhotos.count == 0) {
        return CGSizeZero;
    }
    
    CGFloat pickedPhotoCellWidth = floor(([UIScreen jk_width] - 12.0f * 2 - self.selectedPhotoCollectionViewViewItemSpacing * 2)/3.0f);
    return CGSizeMake(pickedPhotoCellWidth, pickedPhotoCellWidth);
}

- (CGSize)pickedPhotoCollectionViewSize {
    if (self.imagePickerModel.selectedPhotos.count == 0) {
        return CGSizeZero;
    }
    
    CGFloat selectedPhotoCollectionVieWidth = [UIScreen jk_width] - 12.0f * 2;
    NSInteger lineNumber = (self.imagePickerModel.selectedPhotos.count - 1) / 3 + 1;
    CGFloat selectedPhotoCollectionVieHeight = ceil(12.0f * 2 + self.pickedPhotoCellSize.height * lineNumber + self.selectedPhotoCollectionViewViewLineSpacing * (lineNumber - 1));
    
    
    return CGSizeMake(selectedPhotoCollectionVieWidth, selectedPhotoCollectionVieHeight);
}

- (void)clear {
    self.content = @"";
    self.imagePickerModel = [[UFUIImagePickerModel alloc] init];
}

- (BOOL)isAbleToPublish:(NSString **)errorMessage {
    if (![self.content isEqualToString:@""] || self.imagePickerModel.selectedPhotos.count > 0) {
        return YES;
    } else {
        *errorMessage = KUFUILocalization(@"addPostErrorAlert.subTitle.incorrectInput");
        return NO;
    }
}

- (void)addPostInBackground:(void(^)(NSError *error))block {
    dispatch_queue_t dispatchQueue = dispatch_queue_create("inspirelife.queue.add.feed", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t dispatchGroup = dispatch_group_create();

    NSMutableArray *fileModelArray = [[NSMutableArray alloc] init];
    __block NSError *error = nil;
    __block NSString *fileType = @"";

    // 上传所有的照片，如果有一张上传失败，则失败
    [self.imagePickerModel.selectedPhotos enumerateObjectsUsingBlock:^(UIImage * _Nonnull photoImage, NSUInteger idx, BOOL * _Nonnull stop) {
        dispatch_group_async(dispatchGroup, dispatchQueue, ^{
            NSError *fileModelError = nil;
            UFMFileModel *fileModel = [[UFMFileModel alloc] initWithImage:photoImage error:&fileModelError];
            if (!fileModelError) {
                [fileModelArray addObject:fileModel];
                fileType = fileModel.fileType;
            } else {
                error = fileModelError;
            }
        });
    }];

    // 只有全部照片上传成功后，才可以上传
    dispatch_group_notify(dispatchGroup, dispatchQueue, ^{
        if (!error) {
            UFMPostModel *postModel = [[UFMPostModel alloc] initWithContent:self.content fileModelArray:fileModelArray fileType:fileType fromUserModel:[UFMService currentUserModel] toTopicModel:self.toTopicModel error:&error];
            
            if (postModel) {
                [[NSNotificationCenter defaultCenter] postNotificationName:UFUIPostAddedNotification object:postModel];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            block(error);
        });
    });
}

@end
