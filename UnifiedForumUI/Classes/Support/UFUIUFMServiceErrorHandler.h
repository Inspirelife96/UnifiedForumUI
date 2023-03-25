//
//  UFUIUFMServiceErrorHandler.h
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2021/6/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UFUIUFMServiceErrorHandler : NSObject

+ (void)handleUFMServiceError:(NSError *)error;

+ (NSString *)errorMessage:(NSInteger)errorCode;

@end

NS_ASSUME_NONNULL_END
