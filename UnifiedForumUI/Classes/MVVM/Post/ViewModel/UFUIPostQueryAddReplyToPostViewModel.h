//
//  UFUIPostQueryAddReplyToPostViewModel.h
//  INSParseUI
//
//  Created by XueFeng Chen on 2022/1/27.
//

#import <Foundation/Foundation.h>

#import "UFUIConstants.h"

NS_ASSUME_NONNULL_BEGIN

@class UFMPostModel;
@class UFUIPostCellViewModel;

@interface UFUIPostQueryAddReplyToPostViewModel : NSObject

// 对应UFUIPostQueryAddReplyToPostView titleLabel的内容
@property (nonatomic, copy) NSString *toLabelText;

// 对应UFUIPostQueryAddReplyToPostView replyTextView的内容
@property (nonatomic, copy) NSString *content;

// 对哪个Post进行回复
@property (nonatomic, strong) UFMPostModel *toPostModel;

// 对哪个Reply进行回复。当为对Post的回复时，设置为nil
@property (nonatomic, strong, nullable) UFMReplyModel *toReplyModel;

@property (nonatomic, strong, nullable) UFUIPostCellViewModel *postCellVM;

- (instancetype)initWithPostCellViewModel:(UFUIPostCellViewModel *)postCellVM;

- (instancetype)initWithPostModel:(UFMPostModel *)toPostModel;
- (instancetype)initWithPostModel:(UFMPostModel *)toPostModel replyModel:(UFMReplyModel  * _Nullable)toReplyModel;

//- (BOOL)isAbleToPublish:(NSString **)errorMessage;

//- (void)reset;

- (void)addReplyInBackground:(void(^)(NSError *error))block;

@end

NS_ASSUME_NONNULL_END
