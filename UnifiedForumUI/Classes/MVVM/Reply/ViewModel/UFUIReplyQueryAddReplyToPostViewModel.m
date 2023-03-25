//
//  UFUIReplyQueryAddReplyToPostViewModel.m
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2023/2/22.
//

#import "UFUIReplyQueryAddReplyToPostViewModel.h"

#import "UFUIConstants.h"

@implementation UFUIReplyQueryAddReplyToPostViewModel

- (instancetype)initWithPostModel:(UFMPostModel *)toPostModel {
    if (self = [super init]) {
        self.toPostModel = toPostModel;
        self.toLabelText = [NSString stringWithFormat:KUFUILocalization(@"UFUIReplyQueryViewController.replyQueryAddReplyToPostView.toLabel.text"), self.toPostModel.content];

        self.content = @"";
    }
    
    return self;
}

- (void)addReplyToPostInBackground:(void(^)(NSError *error))block {
    WEAKSELF
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        STRONGSELF
        NSError *error = nil;
        
        // 调用UFMReplyModel的API上传
        UFMReplyModel *replyModel = [[UFMReplyModel alloc] initWithContent:strongSelf.content fromUserModel:[UFMService currentUserModel] toPostModel:strongSelf.toPostModel toReplyModel:nil error:&error];

        // 上传成功之后
        if (replyModel) {
            // 发送消息通知
            [[NSNotificationCenter defaultCenter] postNotificationName:UFUIReplyAddedNotification object:replyModel];

            // 注意：toPostModel需要更新
            // 只管当前视图，其他视图的更新不管
            self.toPostModel.replyCount++;

            // 初始
            self.content = @"";
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            block(error);
        });
    });
}

@end
