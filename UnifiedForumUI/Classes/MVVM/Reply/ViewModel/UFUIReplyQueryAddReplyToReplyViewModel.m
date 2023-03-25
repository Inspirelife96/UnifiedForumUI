//
//  UFUIReplyQueryAddReplyToReplyViewModel.m
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2023/2/22.
//

#import "UFUIReplyQueryAddReplyToReplyViewModel.h"

#import "UFUIConstants.h"

@implementation UFUIReplyQueryAddReplyToReplyViewModel

- (instancetype)initWithPostModel:(UFMPostModel *)toPostModel replyModel:(UFMReplyModel *)toReplyModel {
    if (self = [super init]) {
        self.toPostModel = toPostModel;
        self.toReplyModel = toReplyModel;
        self.toLabelText = [NSString stringWithFormat:KUFUILocalization(@"UFUIReplyQueryViewController.replyQueryAddReplyToReplyView.toLabel.text"), self.toReplyModel.content];

        self.content = @"";
    }
    
    return self;
}

- (void)addReplyToReplyInBackground:(void(^)(NSError *error))block {
    WEAKSELF
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        STRONGSELF
        NSError *error = nil;
        
        UFMReplyModel *replyModel = [[UFMReplyModel alloc] initWithContent:strongSelf.content fromUserModel:[UFMService currentUserModel] toPostModel:strongSelf.toPostModel toReplyModel:strongSelf.toReplyModel error:&error];

        if (replyModel) {
            [[NSNotificationCenter defaultCenter] postNotificationName:UFUIReplyAddedNotification object:replyModel];
            self.toPostModel.replyCount++;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            block(error);
        });
    });
}

@end
