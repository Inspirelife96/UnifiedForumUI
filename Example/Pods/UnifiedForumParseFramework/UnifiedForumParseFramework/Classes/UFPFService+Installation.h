//
//  UFPFService+Installation.h
//  UFPFParse
//
//  Created by XueFeng Chen on 2022/6/8.
//

#import "UFPFService.h"

NS_ASSUME_NONNULL_BEGIN

@interface UFPFService (Installation)

+ (BOOL)linkCurrentInstalltionWithCurrentUser:(NSError **)error;

+ (BOOL)unlinkCurrentInstalltionWithCurrentUser:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
