//
//  UFUIPostQueryFooterViewModel.h
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2022/12/12.
//

#import <Foundation/Foundation.h>

@class UFMTopicModel;

NS_ASSUME_NONNULL_BEGIN

@interface UFUIPostQueryFooterViewModel : NSObject

@property (nonatomic, strong) UFMTopicModel *topicModel;

@property (nonatomic, assign) BOOL isLikedByCurrentUser;
@property (nonatomic, copy) UIColor *likeButtonTintColor;

- (instancetype)initWithTopicModel:(UFMTopicModel *)topicModel;

// 点赞
- (void)likeTopicInBackgroundWithBlock:(void(^)(NSError *_Nullable error))block;

// 分享
- (void)shareTopicToPlatformInBackgound:(NSString *)toPlatform withBlock:(void(^)(NSError *_Nullable error))block;


@end

NS_ASSUME_NONNULL_END
