//
//  UFUIReplyQueryAddReplyToPostViewModel.h
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2023/2/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UFUIReplyQueryAddReplyToPostViewModel : NSObject

// 对应UFUIPostQueryAddReplyToPostView titleLabel的内容
@property (nonatomic, copy) NSString *toLabelText;

// 对应UFUIPostQueryAddReplyToPostView replyTextView的内容
@property (nonatomic, copy) NSString *content;

// 对哪个Post进行回复
@property (nonatomic, strong) UFMPostModel *toPostModel;

// 有PostModel进行初始化
- (instancetype)initWithPostModel:(UFMPostModel *)toPostModel;

// 添加针对Post的回复
- (void)addReplyToPostInBackground:(void(^)(NSError *error))block;

@end

NS_ASSUME_NONNULL_END
