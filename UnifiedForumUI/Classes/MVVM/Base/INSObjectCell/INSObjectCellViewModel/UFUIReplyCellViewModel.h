//
//  UFUIReplyCellViewModel.h
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2023/2/19.
//

#import "UFUIObjectCellViewModel.h"

#import "UFUIConstants.h"

@class UFMReplyModel;

NS_ASSUME_NONNULL_BEGIN

@interface UFUIReplyCellViewModel : UFUIObjectCellViewModel

// 用户头像
@property (nonatomic, copy, nullable) NSString *fromUserAvatarUrlString;
// 用户名
@property (nonatomic, copy) NSString *fromUserName;
// 发布时间
@property (nonatomic, copy) NSString *postTimeInfo;

// 点赞按钮的标题，如果0赞，则显示赞字，如果超过0赞，那么直接显示数字
@property (nonatomic, assign) BOOL isLikedByCurrentUser;
@property (nonatomic, copy) NSString *likeButtonTitle;
@property (nonatomic, copy) UIColor *likeButtonTintColor;
@property (nonatomic, copy) UIColor *likeButtonTitleColor;

// Reply的内容
@property (nonatomic, copy) NSString *content;

// 持有数据模型
@property (nonatomic, strong) UFMReplyModel *replyModel;

// 点赞
- (void)likeReplyInBackgroundWithBlock:(UFUIBooleanResultBlock)block;

- (void)reportReplyInBackgroundWithBlock:(UFUIBooleanResultBlock)block;

@end

NS_ASSUME_NONNULL_END
