//
//  UFUIReplyQueryHeaderViewModel.h
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2023/2/19.
//

#import <Foundation/Foundation.h>

#import "UFUIConstants.h"

@class UFMPostModel;
@class UFUIImageFileCellViewModel;
@class YBIBImageData;

NS_ASSUME_NONNULL_BEGIN

@interface UFUIReplyQueryHeaderViewModel : NSObject

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

// Post的内容
@property (nonatomic, copy) NSString *content;

// Post附加的图片
@property (nonatomic, strong) NSArray <UFUIImageFileCellViewModel *> *fileCellVMArray;
// 所有图片布局到CollectionView后，CollectionView的大小
@property (nonatomic, assign) CGSize fileCollectionViewSize;

// 图片集，使用YBIBImageBrowse时需要的数据源
@property (nonatomic, strong) NSArray <YBIBImageData *> *imageDataArray;

// 持有数据模型
@property (nonatomic, strong) UFMPostModel *postModel;

- (void)sizeFileCollectionView;

- (instancetype)initWithPostModel:(UFMPostModel *)postModel;

// 点赞
- (void)likePostInBackgroundWithBlock:(UFUIBooleanResultBlock)block;

@end

NS_ASSUME_NONNULL_END
