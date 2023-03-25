//
//  UIImage+Compress.h
//  UnifiedForumModelParseImpl
//
//  Created by XueFeng Chen on 2022/11/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (UFMCompress)

- (NSData *)ufm_compressToByte:(NSUInteger)maxLength;

@end

NS_ASSUME_NONNULL_END
