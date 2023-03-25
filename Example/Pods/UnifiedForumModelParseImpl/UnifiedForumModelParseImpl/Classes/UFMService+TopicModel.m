//
//  UFMService+TopicModel.m
//  UnifiedForumModelParseImpl
//
//  Created by XueFeng Chen on 2022/11/16.
//

#import "UFMService+TopicModel.h"

#import "UFMTopicModel.h"
#import "UFMUserModel.h"

@implementation UFMService (Topic)

// 查询API

// 0 无条件，直接查询Topic表，根据orderBy进行排序，例如查询热门的Topic。
+ (NSArray<UFMTopicModel *> *)findTopicModelArrayOrderBy:(NSString *)orderBy
                                      isOrderByAscending:(BOOL)isOrderByAscending
                                                    page:(NSUInteger)page
                                               pageCount:(NSUInteger)pageCount
                                                   error:(NSError **)error {
    NSArray<UFPFTopic *> *metaDataArray = [UFPFService findTopicsOrderBy:orderBy isOrderByAscending:isOrderByAscending page:page pageCount:pageCount error:error];
    
    if (*error) {
        return nil;
    } else {
        return [UFMService _buildTopicModelArrayFromMetaDataArray:metaDataArray error:error];
    }
}

// 1 根据Category查询，一般用来展示某个板块的内容
+ (NSArray<UFMTopicModel *> *)findTopicModelArrayWithCategory:(NSString *)category
                                                      orderBy:(NSString *)orderBy
                                           isOrderByAscending:(BOOL)isOrderByAscending
                                                         page:(NSUInteger)page
                                                    pageCount:(NSUInteger)pageCount
                                                        error:(NSError **)error {
    NSArray<UFPFTopic *> *metaDataArray = [UFPFService findTopicsWithCategory:category orderBy:orderBy isOrderByAscending:isOrderByAscending page:page pageCount:pageCount error:error];
    
    if (*error) {
        return nil;
    } else {
        return [UFMService _buildTopicModelArrayFromMetaDataArray:metaDataArray error:error];
    }
}

// 2 根据Tag查询，一般用来展示某个标签的内容
+ (NSArray<UFMTopicModel *> *)findTopicModelArrayWithTag:(NSString *)tag
                                                 orderBy:(NSString *)orderBy
                                      isOrderByAscending:(BOOL)isOrderByAscending
                                                    page:(NSUInteger)page
                                               pageCount:(NSUInteger)pageCount
                                                   error:(NSError **)error {
    NSArray<UFPFTopic *> *metaDataArray = [UFPFService findTopicsWithTag:tag orderBy:orderBy isOrderByAscending:isOrderByAscending page:page pageCount:pageCount error:error];
    
    if (*error) {
        return nil;
    } else {
        return [UFMService _buildTopicModelArrayFromMetaDataArray:metaDataArray error:error];
    }
}

// 3 根据fromUser查询，一般用来展示某个用户的内容
+ (NSArray<UFMTopicModel *> *)findTopicModelArrayCreatedByUserModel:(UFMUserModel *)userModel
                                                            orderBy:(NSString *)orderBy
                                                 isOrderByAscending:(BOOL)isOrderByAscending
                                                               page:(NSInteger)page
                                                          pageCount:(NSInteger)pageCount
                                                              error:(NSError **)error {
    if ([userModel.metaData isKindOfClass:[PFUser class]]) {
        PFUser *user = (PFUser *)userModel.metaData;
        NSArray<UFPFTopic *> *metaDataArray = [UFPFService findTopicsCreatedByUser:user orderBy:orderBy isOrderByAscending:isOrderByAscending page:page pageCount:pageCount error:error];
        if (*error) {
            return nil;
        } else {
            return [UFMService _buildTopicModelArrayFromMetaDataArray:metaDataArray error:error];
        }
    }
    
    return nil;
}

// 4 根据关注，一般用来展示用户关注的内容
+ (NSArray<UFMTopicModel *> *)findTopicModelArrayFollowedByUserModel:(UFMUserModel *)userModel
                                                             orderBy:(NSString *)orderBy
                                                  isOrderByAscending:(BOOL)isOrderByAscending
                                                                page:(NSInteger)page
                                                           pageCount:(NSInteger)pageCount
                                                               error:(NSError **)error {
    if ([userModel.metaData isKindOfClass:[PFUser class]]) {
        PFUser *user = (PFUser *)userModel.metaData;
        NSArray<UFPFTopic *> *metaDataArray = [UFPFService findTopicsFollowedByUser:user orderBy:orderBy isOrderByAscending:isOrderByAscending page:page pageCount:pageCount error:error];
        if (*error) {
            return nil;
        } else {
            return [UFMService _buildTopicModelArrayFromMetaDataArray:metaDataArray error:error];
        }
    }
    
    return nil;
}

+ (NSArray<UFMTopicModel *> *)_buildTopicModelArrayFromMetaDataArray:(NSArray *)metaDataArray error:(NSError **)error {
    NSMutableArray *topicMutableArray = [[NSMutableArray alloc] initWithCapacity:metaDataArray.count];
    
    for (NSInteger i = 0; i < metaDataArray.count; i++) {
        UFMTopicModel *topic = [[UFMTopicModel alloc] initWithMetaData:metaDataArray[i] error:error];
        if(*error) {
            return nil;
        } else {
            [topicMutableArray addObject:topic];
        }
    }
    
    return [topicMutableArray copy];
}

@end
