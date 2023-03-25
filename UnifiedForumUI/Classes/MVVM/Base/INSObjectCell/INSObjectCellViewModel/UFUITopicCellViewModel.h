//
//  UFUITopicCellViewModel.h
//  INSParseUI
//
//  Created by XueFeng Chen on 2022/2/15.
//

#import "UFUIObjectCellViewModel.h"

#import "UFUIConstants.h"

NS_ASSUME_NONNULL_BEGIN

@class UFMTopicModel;
@class UFUIImageFileCellViewModel;

@interface UFUITopicCellViewModel : UFUIObjectCellViewModel

// 用户信息
@property (nonatomic, copy, nullable) NSString *fromUserAvatarUrlString;
@property (nonatomic, copy) NSString *fromUserName;
@property (nonatomic, copy) NSString *postTimeInfo;

// 核心数据： 标题，内容和图片
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;

@property (nonatomic, strong) NSArray<UFUIImageFileCellViewModel *> *fileCellVMArray;
@property (nonatomic, strong) NSArray<YBIBImageData *> *imageDataArray;
@property (nonatomic, assign) CGSize fileCollectionViewSize;

// 评论数
@property (nonatomic, copy) NSString *postButtonTitle;

// 点赞数
@property (nonatomic, assign) BOOL isLikedByCurrentUser;
@property (nonatomic, copy) NSString *likeButtonTitle;
@property (nonatomic, copy) UIColor *likeButtonTintColor;
@property (nonatomic, copy) UIColor *likeButtonTitleColor;

// 分享数
@property (nonatomic, copy) NSString *shareButtonTitle;

// 模型
@property (nonatomic, strong) UFMTopicModel *topicModel;

// 交互

// 点赞
- (void)likeTopicInBackgroundWithBlock:(UFUIBooleanResultBlock)block;

// 分享
- (void)shareTopicToPlatformInBackgound:(NSString *)toPlatform withBlock:(UFUIBooleanResultBlock)block;

@end

NS_ASSUME_NONNULL_END
