//
//  UFMService+TimeLine.h
//  UnifiedForumModelParseImpl
//
//  Created by XueFeng Chen on 2023/2/19.
//

#import "UFMService.h"

@class UFMTimeLineModel;
@class UFMUserModel;

NS_ASSUME_NONNULL_BEGIN

@interface UFMService (TimeLine)

+ (NSArray<UFMTimeLineModel *> *)findTimeLineModelArrayOfUser:(UFMUserModel *)userModel
                                                      orderBy:(NSString *)orderBy
                                           isOrderByAscending:(BOOL)isOrderByAscending
                                                         page:(NSUInteger)page
                                                    pageCount:(NSUInteger)pageCount
                                                        error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
