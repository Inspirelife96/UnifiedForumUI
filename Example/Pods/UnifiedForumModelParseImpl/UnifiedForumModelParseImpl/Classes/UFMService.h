//
//  UFMService.h
//  GlobalDataModel
//
//  Created by XueFeng Chen on 2022/11/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class UFMAppInfoModel;
@class UFMUserModel;

@class UFMConfiguration;

@interface UFMService : NSObject

+ (void)initializeWithConfiguration:(NSDictionary *)configuration;


@end

NS_ASSUME_NONNULL_END
