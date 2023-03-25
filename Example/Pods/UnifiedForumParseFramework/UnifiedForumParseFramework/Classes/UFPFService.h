//
//  UFPFService.h
//  UFPFParse
//
//  Created by XueFeng Chen on 2021/6/22.
//

#import <Foundation/Foundation.h>

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface UFPFService : NSObject

+ (PFFileObject *)addImageData:(NSData *)imageData error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
