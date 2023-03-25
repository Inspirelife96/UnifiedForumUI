//
//  UFMService+PostModel.m
//  UnifiedForumModelParseImpl
//
//  Created by XueFeng Chen on 2022/11/16.
//

#import "UFMService+PostModel.h"

#import "UFMTopicModel.h"
#import "UFMPostModel.h"
#import "UFMUserModel.h"

@implementation UFMService (PostModel)

// - 查询某一个Topic的回帖
+ (NSArray<UFMPostModel *> *)findPostModelArrayToTopic:(UFMTopicModel *)toTopicModel
                                               orderBy:(NSString *)orderBy
                                    isOrderByAscending:(BOOL)isOrderByAscending
                                                  page:(NSInteger)page
                                             pageCount:(NSInteger)pageCount
                                                 error:(NSError **)error {
    UFPFTopic *topic = (UFPFTopic *)toTopicModel.metaData;
    
    
    NSArray<UFPFPost *> *metaDataArray = [UFPFService findPostsToTopic:topic orderBy:orderBy isOrderByAscending:isOrderByAscending page:page pageCount:pageCount error:error];
    
    if (*error) {
        return nil;
    } else {
        return [UFMService _buildPostModelArrayFromMetaDataArray:metaDataArray error:error];
    }
}

// - 查询某一个Topic下某个人的所有回贴 - 例如：即只看楼主的功能
+ (NSArray<UFMPostModel *> *)findPostModelArrayToTopic:(UFMTopicModel *)toTopicModel
                                         fromUserModel:(UFMUserModel *)fromUserModel
                                               orderBy:(NSString *)orderBy
                                    isOrderByAscending:(BOOL)isOrderByAscending
                                                  page:(NSInteger)page
                                             pageCount:(NSInteger)pageCount
                                                 error:(NSError **)error {
    UFPFTopic *topic = (UFPFTopic *)toTopicModel.metaData;
    PFUser *fromUser = (PFUser *)fromUserModel.metaData;
    
    NSArray<UFPFPost *> *metaDataArray = [UFPFService findPostsToTopic:topic fromUser:fromUser orderBy:orderBy isOrderByAscending:isOrderByAscending page:page pageCount:pageCount error:error];
    
    if (*error) {
        return nil;
    } else {
        return [UFMService _buildPostModelArrayFromMetaDataArray:metaDataArray error:error];
    }
    
}


+ (NSArray<UFMPostModel *> *)_buildPostModelArrayFromMetaDataArray:(NSArray *)metaDataArray error:(NSError **)error {
    NSMutableArray *postMutableArray = [[NSMutableArray alloc] initWithCapacity:metaDataArray.count];
    
    for (NSInteger i = 0; i < metaDataArray.count; i++) {
        UFMPostModel *postModel = [[UFMPostModel alloc] initWithMetaData:metaDataArray[i] error:error];
        if(*error) {
            return nil;
        } else {
            [postMutableArray addObject:postModel];
        }
    }
    
    return [postMutableArray copy];
}

@end
