//
//  UFUIImageFileCellViewModel.h
//  INSParseUI
//
//  Created by XueFeng Chen on 2022/2/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class UFMFileModel;
@class UFMFileModel;

//
typedef NS_ENUM(NSInteger, UFUIImageFileCellStyle) {
    UFUIImageFileCellStylePost,
    UFUIImageFileCellStyleTopicBriefMultiple,
    UFUIImageFileCellStyleTopicBriefSingle,
    UFUIImageFileCellStyleTopicStandard
};

@interface UFUIImageFileCellViewModel : NSObject

@property (nonatomic, strong) UFMFileModel *fileModel;

@property (nonatomic, copy) NSString *urlString;
@property (nonatomic, assign) CGSize size;

- (instancetype)initWithFileModel:(UFMFileModel *)fileModel fileCellStyle:(UFUIImageFileCellStyle)fileCellStyle;

@end

NS_ASSUME_NONNULL_END
