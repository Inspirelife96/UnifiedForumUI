//
//  UFPFService+Session.h
//  UFPFParse
//
//  Created by XueFeng Chen on 2022/7/1.
//

#import "UFPFService.h"

NS_ASSUME_NONNULL_BEGIN

@interface UFPFService (Session)

+ (BOOL)removeInvalidSessions:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
