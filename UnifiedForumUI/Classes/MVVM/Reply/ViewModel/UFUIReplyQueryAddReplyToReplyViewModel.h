//
//  UFUIReplyQueryAddReplyToReplyViewModel.h
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2023/2/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UFUIReplyQueryAddReplyToReplyViewModel : NSObject

// 对应UFUIPostQueryAddReplyToPostView titleLabel的内容
@property (nonatomic, copy) NSString *toLabelText;

// 对应UFUIPostQueryAddReplyToPostView replyTextView的内容
@property (nonatomic, copy) NSString *content;

// 对哪个Post进行回复
@property (nonatomic, strong) UFMPostModel *toPostModel;

// 对哪个Reply进行回复
@property (nonatomic, strong) UFMReplyModel *toReplyModel;

// 用toPostModel和toReplyModel进行初始化，必须提供
- (instancetype)initWithPostModel:(UFMPostModel *)toPostModel replyModel:(UFMReplyModel  *)toReplyModel;

// 添加针对Reply的回复
- (void)addReplyToReplyInBackground:(void(^)(NSError *error))block;

@end

NS_ASSUME_NONNULL_END
