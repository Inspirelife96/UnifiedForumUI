//
//  UFMService+TimeLine.m
//  UnifiedForumModelParseImpl
//
//  Created by XueFeng Chen on 2023/2/19.
//

#import "UFMService+TimeLine.h"

#import "UFMUserModel.h"
#import "UFMTimeLineModel.h"

@implementation UFMService (TimeLine)

+ (NSArray<UFMTimeLineModel *> *)findTimeLineModelArrayOfUser:(UFMUserModel *)userModel
                                                      orderBy:(NSString *)orderBy
                                           isOrderByAscending:(BOOL)isOrderByAscending
                                                         page:(NSUInteger)page
                                                    pageCount:(NSUInteger)pageCount
                                                        error:(NSError **)error {
    PFUser *user = (PFUser *)userModel.metaData;
    NSArray<UFPFTimeLine *> *metaDataArray = [UFPFService findTimeLineOfUser:user page:page pageCount:pageCount error:error];
    
    if (*error) {
        return nil;
    } else {
        return [UFMService _buildTimeLineModelArrayFromMetaDataArray:metaDataArray error:error];
    }
}

+ (NSArray<UFMTimeLineModel *> *)_buildTimeLineModelArrayFromMetaDataArray:(NSArray *)metaDataArray error:(NSError **)error {
    NSMutableArray *timeLineModelMutableArray = [[NSMutableArray alloc] initWithCapacity:metaDataArray.count];
    
    for (NSInteger i = 0; i < metaDataArray.count; i++) {
        UFMTimeLineModel *timeLineModel = [[UFMTimeLineModel alloc] initWithMetaData:metaDataArray[i] error:error];
        if(*error) {
            return nil;
        } else {
            [timeLineModelMutableArray addObject:timeLineModel];
        }
    }
    
    return [timeLineModelMutableArray copy];
}

@end
