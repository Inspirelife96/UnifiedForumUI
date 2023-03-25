//
//  UFPFService+PostReport.h
//  UFPFParse
//
//  Created by XueFeng Chen on 2022/7/22.
//

#import "UFPFService.h"

#import "UFPFDefines.h"

NS_ASSUME_NONNULL_BEGIN

@class UFPFPost;
@class UFPFPostReport;

@interface UFPFService (PostReport)

+ (UFPFPostReport *)addPostReportFromUser:(PFUser *)fromUser toPost:(UFPFPost *)toPost forReason:(UFPFParseReportReason)reason error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
