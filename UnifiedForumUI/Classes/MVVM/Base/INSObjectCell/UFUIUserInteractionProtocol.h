//
//  UFUIUserInteractionProtocol.h
//  INSParseUI
//
//  Created by XueFeng Chen on 2021/7/5.
//

#import <Foundation/Foundation.h>

@class UFMUserModel;
@class UFMTopicModel;
@class UFMPostModel;
@class YBIBImageData;

NS_ASSUME_NONNULL_BEGIN

@protocol UFUIUserInteractionProtocol <NSObject>

- (void)browseUserProfile:(UFMUserModel *)userModel;

- (void)postTopic:(UFMTopicModel *)topicModel;

- (void)likeTopic:(UFMTopicModel *)topicModel;

- (void)tagTopic:(UFMTopicModel *)topicModel;

- (void)shareTopic:(UFMTopicModel *)topicModel;

- (void)reviewTopic:(UFMTopicModel *)topicModel;

- (void)reportTopic:(UFMTopicModel *)topicModel;

- (void)followUser:(UFMUserModel *)userModel;

- (void)unFollowUser:(UFMUserModel *)userModel;

- (void)replyPost:(UFMPostModel *)postModel;

- (void)showMoreReples:(UFMPostModel *)postModel;

- (void)deletePost:(UFMPostModel *)postModel;

- (void)likePost:(UFMPostModel *)postModel;

- (void)reportPost:(UFMPostModel *)postModel;

- (void)popTopic:(UFMTopicModel *)topicModel;

- (void)browserImageDataArray:(NSArray<YBIBImageData *> *)imageDataArray currentPage:(NSInteger)currentPage;

@end

NS_ASSUME_NONNULL_END
