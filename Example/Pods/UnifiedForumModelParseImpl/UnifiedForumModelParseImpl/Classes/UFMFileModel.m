//
//  UFMFileModel.m
//  UFMParseImpl
//
//  Created by XueFeng Chen on 2022/11/8.
//

#import "UFMFileModel.h"

#import "UIImage+UFMCompress.h"

NSString *const _Nonnull UFMFileModelTypeTextPlain = @"txt";
NSString *const _Nonnull UFMFileModelTypeTextHTML = @"html";
NSString *const _Nonnull UFMFileModelTypeTextMarkDown = @"md";
NSString *const _Nonnull UFMFileModelTypeImagePNG = @"png";
NSString *const _Nonnull UFMFileModelTypeImageJPEG = @"jpeg";
NSString *const _Nonnull UFMFileModelTypeImageGIF = @"gif";
NSString *const _Nonnull UFMFileModelTypeVideoMPEG = @"mpeg";
NSString *const _Nonnull UFMFileModelTypeApplicationPDF = @"pdf";

@implementation UFMFileModel

- (instancetype)initWithMetaData:(id)metaData error:(NSError **)error {
    if (self = [super initWithMetaData:metaData error:error]) {
        NSAssert([metaData isKindOfClass:[PFFileObject class]], @"metaData type is incorrect");
        
        PFFileObject *fileObject = (PFFileObject *)metaData;
        
        self.url = fileObject.url;
        self.name = fileObject.name;
        self.dirty = fileObject.isDirty;

        // init
        self.fileType = @"";
        self.imageWidth = 200.0f;
        self.imageHeight = 200.0f;
        
        // 先判断后缀，决定文件类型
        NSArray *array = [self.name componentsSeparatedByString:@"."];
        if (array.count == 2) {
            NSString *fileName = array[0];
            NSString *fileType = array[1];
            
            self.fileType = fileType;
            
            if ([fileType isEqualToString:UFMFileModelTypeImagePNG] ||
                [fileType isEqualToString:UFMFileModelTypeImageJPEG] ||
                [fileType isEqualToString:UFMFileModelTypeImageGIF]) {
                // 图片文件则判断是否有预存的宽和高，否则默认200/200
                NSArray *sizeArray = [fileName componentsSeparatedByString:@"_"];
                if (sizeArray.count == 3) {
                    self.imageWidth = [sizeArray[1] floatValue];
                    self.imageHeight = [sizeArray[2] floatValue];
                } else {
                    self.imageWidth = 200.0f;
                    self.imageHeight = 200.0f;
                }
            }
        }
    }
    
    return self;
}

- (instancetype)initWithFileData:(NSData *)fileData fileType:(NSString *)fileType error:(NSError **)error {
    if (self = [super init]) {
        self.fileType = fileType;
        NSData *data = fileData;
        
        if ([fileType isEqualToString:UFMFileModelTypeImagePNG] ||
            [fileType isEqualToString:UFMFileModelTypeImageJPEG] ||
            [fileType isEqualToString:UFMFileModelTypeImageGIF]) {
            UIImage *image = [UIImage imageWithData:fileData];
            data = [image ufm_compressToByte:200 * 1024];
            image = [UIImage imageWithData:data];
            self.imageWidth = image.size.width;
            self.imageHeight = image.size.height;
            self.name = [NSString stringWithFormat:@"file_%.2f_%.2f.%@", self.imageWidth, self.imageHeight, fileType];
        } else {
            self.name = [NSString stringWithFormat:@"file.%@", fileType];
        }
        
        PFFileObject *fileObject = [PFFileObject fileObjectWithName:self.name data:data contentType:@"" error:error];
        
        if (*error) {
            return nil;
        } else {
            self.metaData = fileObject;
            self.url = fileObject.url;
            self.dirty = fileObject.isDirty;
        }
    }
    
    return self;
}

- (instancetype)initWithImage:(UIImage *)image error:(NSError **)error {
    if (self = [super init])  {
        NSData *data = [image ufm_compressToByte:200 * 1024];
        UIImage *compressedImage = [UIImage imageWithData:data];
        self.imageWidth = compressedImage.size.width;
        self.imageHeight = compressedImage.size.height;
        self.fileType = UFMFileModelTypeImageJPEG;
        self.name = [NSString stringWithFormat:@"file_%.2f_%.2f.%@", self.imageWidth, self.imageHeight, self.fileType];

        PFFileObject *fileObject = [PFFileObject fileObjectWithName:self.name data:data contentType:@"" error:error];
        
        if (*error) {
            return nil;
        } else {
            self.metaData = fileObject;
            self.url = fileObject.url;
            self.dirty = fileObject.isDirty;
        }
    }

    return self;
}


@end
