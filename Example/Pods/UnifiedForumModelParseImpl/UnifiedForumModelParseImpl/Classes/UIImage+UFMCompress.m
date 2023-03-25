//
//  UIImage+Compress.m
//  UnifiedForumModelParseImpl
//
//  Created by XueFeng Chen on 2022/11/12.
//

#import "UIImage+UFMCompress.h"

@implementation UIImage (UFMCompress)

- (NSData *)ufm_compressToByte:(NSUInteger)maxLength {
    //首先判断原图大小是否在要求内，如果满足要求则不进行压缩，over
    CGFloat compression = 1;
    UIImage *originalImage = self;
    NSData *originalImageData = UIImageJPEGRepresentation(originalImage, compression);
    
    if (originalImageData.length < maxLength)  {
        return originalImageData;
    }
    
    // 压 这里 压缩比 采用二分法进行处理，6次二分后的最小压缩比是0.015625，已经够小了
    
    NSData *compressedImageData = [self _compressImage:originalImage toByte:maxLength];
    
    if (compressedImageData.length < maxLength) {
        return compressedImageData;
    }
    
    // 如果还不满足需求，再缩
    CGFloat ratio = (CGFloat)maxLength / originalImageData.length;
    UIImage *resizedImage = [self _resizeImage:originalImage ByRatio:ratio];
    
    // 缩完之后再压
    return [self _compressImage:resizedImage toByte:maxLength];
}

- (NSData *)_compressImage:(UIImage *)image toByte:(NSUInteger)maxLength {
    CGFloat max = 1;
    CGFloat min = 0;
    CGFloat compression = 1;
    NSData *compressedData = nil;
    
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        compressedData = UIImageJPEGRepresentation(image, compression);
        if (compressedData.length < maxLength * 0.9) {
            min = compression;
        } else if (compressedData.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    
    return compressedData;
}

- (UIImage *)_resizeImage:(UIImage *)image ByRatio:(CGFloat)ratio {
    CGSize size = CGSizeMake((NSUInteger)(image.size.width * sqrtf(ratio)),
                             (NSUInteger)(image.size.height * sqrtf(ratio)));
    
    return [self _resizeImage:image toSize:size];
}

- (UIImage *)_resizeImage:(UIImage *)image toSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *resizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resizeImage;
}

@end
