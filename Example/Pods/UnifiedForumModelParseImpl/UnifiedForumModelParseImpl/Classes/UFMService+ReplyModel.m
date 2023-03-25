//
//  UFMService+ReplyModel.m
//  UnifiedForumModelParseImpl
//
//  Created by XueFeng Chen on 2023/2/19.
//

#import "UFMService+ReplyModel.h"

#import "UFMPostModel.h"
#import "UFMReplyModel.h"

@implementation UFMService (ReplyModel)

+ (NSArray<UFMReplyModel *> *)findReplyModelArrayToPost:(UFMPostModel *)toPostModel
                                                orderBy:(NSString *)orderBy
                                     isOrderByAscending:(BOOL)isOrderByAscending
                                                   page:(NSInteger)page
                                              pageCount:(NSInteger)pageCount
                                                  error:(NSError **)error {
    UFPFPost *post = (UFPFPost *)toPostModel.metaData;
    
    NSArray<UFPFReply *> *metaDataArray = [UFPFService findRepliesToPost:post orderBy:orderBy isOrderByAscending:isOrderByAscending page:page pageCount:pageCount error:error];
    
    if (*error) {
        return nil;
    } else {
        return [UFMService _buildReplyModelArrayFromMetaDataArray:metaDataArray error:error];
    }
}

+ (NSArray<UFMReplyModel *> *)_buildReplyModelArrayFromMetaDataArray:(NSArray *)metaDataArray error:(NSError **)error {
    NSMutableArray *replyModelMutableArray = [[NSMutableArray alloc] initWithCapacity:metaDataArray.count];
    
    for (NSInteger i = 0; i < metaDataArray.count; i++) {
        UFMReplyModel *replyModel = [[UFMReplyModel alloc] initWithMetaData:metaDataArray[i] error:error];
        if(*error) {
            return nil;
        } else {
            [replyModelMutableArray addObject:replyModel];
        }
    }
    
    return [replyModelMutableArray copy];
}

@end
