//
//  UFUIPostQueryAddReplyToPostViewModel.m
//  INSParseUI
//
//  Created by XueFeng Chen on 2022/1/27.
//

#import "UFUIPostQueryAddReplyToPostViewModel.h"

#import "UFUIPostCellViewModel.h"
#import "UFMPostModel.h"

@interface UFUIPostQueryAddReplyToPostViewModel ()

@end

@implementation UFUIPostQueryAddReplyToPostViewModel

- (instancetype)initWithPostCellViewModel:(UFUIPostCellViewModel *)postCellVM {
    if (self = [super init]) {
        self.postCellVM = postCellVM;
        self.toPostModel = postCellVM.postModel;
        self.toReplyModel = nil;
        self.toLabelText = [NSString stringWithFormat:KUFUILocalization(@"addReplyView.toLabel.text"), self.toPostModel.content];
        self.content = @"";
    }
    
    return self;
}

- (instancetype)initWithPostModel:(UFMPostModel *)toPostModel {
    return [self initWithPostModel:toPostModel replyModel:nil];
}

- (instancetype)initWithPostModel:(UFMPostModel *)toPostModel replyModel:(UFMReplyModel *)toReplyModel {
    if (self = [super init]) {
        self.postCellVM = nil;
        self.toPostModel = toPostModel;
        self.toReplyModel = toReplyModel;
        if (toReplyModel) {
            self.toLabelText = [NSString stringWithFormat:KUFUILocalization(@"addReplyView.toLabel.text"), self.toReplyModel.content];
        } else {
            self.toLabelText = [NSString stringWithFormat:KUFUILocalization(@"addReplyView.toLabel.text"), self.toPostModel.content];
        }

        self.content = @"";
    }
    
    return self;
}

//- (instancetype)initWithPostModel:(UFMPostModel *)toPostModel {
//    if (self = [super init]) {
//        self.toPostModel = toPostModel;
//        self.toReplyModel = nil;
//        self.content = @"";
//    }
//    
//    return self;
//}
//
//- (instancetype)initWithPostModel:(UFMPostModel *)toPostModel replyModel:(UFMReplyModel *)toReplyModel; {
//    if (self = [super init]) {
//        self.toPostModel = toPostModel;
//        self.toReplyModel = toReplyModel;
//        self.content = @"";
//    }
//    
//    return self;
//}

//- (void)reset {
//    _content = @"";
//}

//- (BOOL)isAbleToPublish:(NSString **)errorMessage {
//    if (![self.content isEqualToString:@""]) {
//        return YES;
//    } else {
//        return NO;
//    }
//}

// 添加回复
- (void)addReplyInBackground:(void(^)(NSError *error))block {
    WEAKSELF
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        STRONGSELF
        NSError *error = nil;
        
        UFMReplyModel *replyModel = [[UFMReplyModel alloc] initWithContent:strongSelf.content fromUserModel:[UFMService currentUserModel] toPostModel:strongSelf.toPostModel toReplyModel:strongSelf.toReplyModel error:&error];

        // 添加成功后的调整
        // 首先，所有的回复预览排序都是按时间Asending
        // 因此，评论>=5条，那么新添加的就不会进入预览，仅总数+1即可
        // 如果评论<5条，那么将新评论添加到replyModelArray的末尾，总数+1.
        if (replyModel) {
            if (strongSelf.toPostModel.replyCount < 5) {
                NSMutableArray *replyModelMutableArray = [strongSelf.toPostModel.replyModelArray mutableCopy];
                [replyModelMutableArray addObject:replyModel];
                strongSelf.toPostModel.replyModelArray = [replyModelMutableArray copy];
            }
            
            strongSelf.toPostModel.replyCount++;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            block(error);
        });
    });
}

@end
