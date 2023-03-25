//
//  UFUIPostQueryHeaderViewModel.h
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2022/12/12.
//

#import <Foundation/Foundation.h>

@class UFMTopicModel;
@class UFUIImageFileCellViewModel;

NS_ASSUME_NONNULL_BEGIN

@interface UFUIPostQueryHeaderViewModel : NSObject

@property (nonatomic, strong) UFMTopicModel *topicModel;

// Topic的标题
@property (nonatomic, copy) NSString *title;

// 发布者信息/发布时间
@property (nonatomic, copy, nullable) NSString *fromUserAvatarUrlString;
@property (nonatomic, copy) NSString *fromUserName;
@property (nonatomic, copy) NSString *postTimeInfo;

// 关注状态
@property (nonatomic, assign) BOOL isFollowedByCurrentUser;
@property (nonatomic, assign) BOOL isFollowStatusButtonHidden;
@property (nonatomic, copy) NSString *followStatusButtonTitle;
@property (nonatomic, strong) UIColor *follwStatusButtonBackgroundColor;
@property (nonatomic, strong) UIColor *followStatusButtonTitleColor;

// 内容
@property (nonatomic, copy) NSString *content;

// 附件图片
@property (nonatomic, strong) NSArray<UFUIImageFileCellViewModel *> *fileCellVMArray;
@property (nonatomic, assign) CGSize fileContentCollectionViewSize;
@property (nonatomic, strong) NSArray<YBIBImageData *> *imageDataArray;

- (instancetype)initWithTopicModel:(UFMTopicModel *)topicModel;

- (void)changeIsFollowedByCurrentUserInbackgroundWithBlock:(void(^)(NSError *_Nullable error))block;

@end

NS_ASSUME_NONNULL_END
