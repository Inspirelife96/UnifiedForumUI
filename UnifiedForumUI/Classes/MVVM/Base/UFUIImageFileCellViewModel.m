//
//  UFUIImageFileCellViewModel.m
//  INSParseUI
//
//  Created by XueFeng Chen on 2022/2/18.
//

#import "UFUIImageFileCellViewModel.h"

@implementation UFUIImageFileCellViewModel

- (instancetype)initWithFileModel:(UFMFileModel *)fileModel fileCellStyle:(UFUIImageFileCellStyle)fileCellStyle {
    if (self = [super init]) {
        _fileModel = fileModel;
        _urlString = fileModel.url;
        _size = [self caluculateSizeByFileCellStyle:fileCellStyle];
    }
    
    return self;
}

- (CGSize)caluculateSizeByFileCellStyle:(UFUIImageFileCellStyle)fileCellStyle {
    if (fileCellStyle == UFUIImageFileCellStylePost) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width - 56.0f - 14.0f;
        CGFloat height = self.fileModel.imageHeight * width / self.fileModel.imageWidth;
        return CGSizeMake(width, height);
    }
    
    if (fileCellStyle == UFUIImageFileCellStyleTopicStandard) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width - 14.0f - 14.0f;
        CGFloat height = self.fileModel.imageHeight * width / self.fileModel.imageWidth;
        return CGSizeMake(width, height);
    }
    
    if (fileCellStyle == UFUIImageFileCellStyleTopicBriefMultiple) {
        CGFloat width = ([UIScreen mainScreen].bounds.size.width - 10.0f*2 - 10.0f * 2 - 5.0f * 2) / 3.0f;
        CGFloat height = width;
        return CGSizeMake(width, height);
    }
    
    if (fileCellStyle == UFUIImageFileCellStyleTopicBriefSingle) {
        CGFloat width = ([UIScreen mainScreen].bounds.size.width - 10.0f*2 - 10.0f * 2) *2.0f / 3.0f;
        CGFloat height = width;
        if (self.fileModel.imageWidth != 0) {
            height = self.fileModel.imageHeight * width / self.fileModel.imageWidth;
        }
        
        return CGSizeMake(width, height);
    }
    
    return CGSizeZero;
}

@end
