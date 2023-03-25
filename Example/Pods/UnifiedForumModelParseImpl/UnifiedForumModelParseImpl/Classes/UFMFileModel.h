//
//  UFMFileModel.h
//  UFMParseImpl
//
//  Created by XueFeng Chen on 2022/11/8.
//

#import "UFMObjectModel.h"

extern NSString *const _Nonnull UFMFileModelTypeTextPlain;
extern NSString *const _Nonnull UFMFileModelTypeTextHTML;
extern NSString *const _Nonnull UFMFileModelTypeTextMarkDown;
extern NSString *const _Nonnull UFMFileModelTypeImagePNG;
extern NSString *const _Nonnull UFMFileModelTypeImageJPEG;
extern NSString *const _Nonnull UFMFileModelTypeImageGIF;
extern NSString *const _Nonnull UFMFileModelTypeVideoMPEG;
extern NSString *const _Nonnull UFMFileModelTypeApplicationPDF;

NS_ASSUME_NONNULL_BEGIN

@interface UFMFileModel : UFMObjectModel

// 文件url
@property (nonatomic, copy) NSString *url;

// 文件名，上传会以一定的格式进行命名，用来解析额外的信息
@property (nonatomic, copy) NSString *name;

// 是否是新上传的
@property (nonatomic, assign, getter=isDirty) BOOL dirty;

// 文件类型 由文件名后缀解析获得
@property (nonatomic, assign) NSString *fileType;

// 图片的宽/高，由文件名解析获得
@property (nonatomic, assign) CGFloat imageWidth;
@property (nonatomic, assign) CGFloat imageHeight;

- (instancetype)initWithFileData:(NSData *)fileData fileType:(NSString *)fileType error:(NSError **)error;

- (instancetype)initWithImage:(UIImage *)image error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
