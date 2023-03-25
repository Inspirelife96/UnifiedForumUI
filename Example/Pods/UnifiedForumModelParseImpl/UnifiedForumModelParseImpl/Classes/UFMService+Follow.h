//
//  UFMService+Follow.h
//  UnifiedForumModelParseImpl
//
//  Created by XueFeng Chen on 2022/12/10.
//

#import "UFMService.h"

NS_ASSUME_NONNULL_BEGIN

@interface UFMService (Follow)

+ (void)addFollowFromUserModel:(UFMUserModel *)fromUserModel toUserModel:(UFMUserModel *)toUserModel error:(NSError **)error;

+ (void)deleteFollowFromUserModel:(UFMUserModel *)fromUserModel toUserModel:(UFMUserModel *)toUserModel error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
