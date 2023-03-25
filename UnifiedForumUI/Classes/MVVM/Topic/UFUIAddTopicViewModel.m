//
//  UFUIAddTopicViewModel.m
//  INSParseUI
//
//  Created by XueFeng Chen on 2021/7/2.
//

#import "UFUIAddTopicViewModel.h"

#import "JCTagListView.h"

//#import "UFUITextViewCellViewModel.h"
#import "UFUIImagePickerModel.h"

@interface UFUIAddTopicViewModel ()

// 理论上View是不应该出现在ViewModel里面的，但这个是用来计算高度的，并不用于展示，所以就放这里了
@property (nonatomic, strong) JCTagListView *tagListView;

@end

@implementation UFUIAddTopicViewModel

- (instancetype)init {
    if (self = [super init]) {
        _category = @"";
        _title = @"";
        _content = @"";
                        
        _selectedTags = [[NSMutableArray alloc] init];
        _imagePickerModel = [[UFUIImagePickerModel alloc] init];
        _selectedPhotoCollectionViewViewItemSpacing = 5.0;
        _selectedPhotoCollectionViewViewLineSpacing = 5.0;
    
//        _titleCellVM = [[UFUITextViewCellViewModel alloc] initWithCellDescription:@"" placeHolder:@"" maxNumberWords:100 maxNumberOfLines:5];
//
//        _contentCellVM =[[UFUITextViewCellViewModel alloc] initWithCellDescription:@"" placeHolder:@"" maxNumberWords:100 maxNumberOfLines:5];
    }
    
    return self;
}

- (CGSize)pickedPhotoCellSize {
    if (self.imagePickerModel.selectedPhotos.count == 0) {
        return CGSizeZero;
    }
    
    CGFloat pickedPhotoCellWidth = floor(([UIScreen jk_width] - 20.0f * 2 - self.selectedPhotoCollectionViewViewItemSpacing * 2)/3.0f);
    return CGSizeMake(pickedPhotoCellWidth, pickedPhotoCellWidth);
}

- (CGSize)pickedPhotoCollectionViewSize {
    if (self.imagePickerModel.selectedPhotos.count == 0) {
        return CGSizeZero;
    }
    
    CGFloat selectedPhotoCollectionVieWidth = [UIScreen jk_width] - 20.0f * 2;
    NSInteger lineNumber = (self.imagePickerModel.selectedPhotos.count - 1) / 3 + 1;
    CGFloat selectedPhotoCollectionViewHeight = ceil(self.pickedPhotoCellSize.height * lineNumber + self.selectedPhotoCollectionViewViewLineSpacing * (lineNumber - 1));
    
    return CGSizeMake(selectedPhotoCollectionVieWidth, selectedPhotoCollectionViewHeight);
}

- (CGFloat)heightForSelectedTagsView {
    if (self.selectedTags.count > 0) {
        self.tagListView.tags = self.selectedTags;
        return self.tagListView.contentHeight;
    } else {
        return 0.0f;
    }
}

- (BOOL)isAbleToPublish:(NSString **)errorMessage {
    if (![self.content isEqualToString:@""] || self.imagePickerModel.selectedPhotos.count > 0) {
        return YES;
    } else {
        *errorMessage = KUFUILocalization(@"addPostErrorAlert.subTitle.incorrectInput");
        return NO;
    }
}

- (void)clear {
    _category = @"";
    _title = @"";
    _content = @"";
    _selectedTags = [[NSMutableArray alloc] init];
    _imagePickerModel = [[UFUIImagePickerModel alloc] init];
}

- (BOOL)needWarningWhenCancel {
    if (![self.title isEqualToString:@""]
        || ![self.content isEqualToString:@""]
        || self.imagePickerModel.selectedPhotos.count > 0
        || self.selectedTags.count > 0) {
        return YES;
    } else {
        return NO;
    }
}

- (void)addTopicInBackground:(void(^)(NSError *error))block {
    dispatch_queue_t dispatchQueue = dispatch_queue_create("inspirelife.queue.add.topic", DISPATCH_QUEUE_CONCURRENT);
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
            UFMTopicModel *topicModel = [[UFMTopicModel alloc] initWithTitle:self.title content:self.content fileModelArray:fileModelArray fileType:fileType fromUserModel:[UFMService currentUserModel] category:self.category tags:self.selectedTags error:&error];
            
            if (topicModel) {
                [[NSNotificationCenter defaultCenter] postNotificationName:UFUITopicAddedNotification object:topicModel];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            block(error);
        });
    });
}

- (JCTagListView *)tagListView {
    if (!_tagListView) {
        _tagListView = [[JCTagListView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen jk_width] - 24.0f, 0)];
    }
    
    return _tagListView;
}

@end
