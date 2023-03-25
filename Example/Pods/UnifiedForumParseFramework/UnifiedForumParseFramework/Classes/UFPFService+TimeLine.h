//
//  UFPFService+TimeLine.h
//  UnifiedForumParseFramework
//
//  Created by XueFeng Chen on 2023/2/19.
//

#import "UFPFService.h"

@class UFPFTimeLine;

NS_ASSUME_NONNULL_BEGIN

@interface UFPFService (TimeLine)

+ (NSArray<UFPFTimeLine *> *)findTimeLineOfUser:(PFUser *)fromUser
                                           page:(NSInteger)page
                                      pageCount:(NSInteger)pageCount
                                          error:(NSError **)error;
@end

NS_ASSUME_NONNULL_END
