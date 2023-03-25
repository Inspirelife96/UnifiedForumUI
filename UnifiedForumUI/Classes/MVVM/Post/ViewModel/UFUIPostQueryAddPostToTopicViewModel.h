//
//  UFUIPostQueryAddPostToTopicViewModel.h
//  INSParseUI
//
//  Created by XueFeng Chen on 2022/1/22.
//

#import <Foundation/Foundation.h>

#import "UFUIConstants.h"

@class UFMTopicModel;
@class UFUIImagePickerModel;

NS_ASSUME_NONNULL_BEGIN

@interface UFUIPostQueryAddPostToTopicViewModel : NSObject

// 针对某一个Topic发表的Post
@property (nonatomic, strong) UFMTopicModel *toTopicModel;

// 顶部的title内容，一般是回复：xxx
@property (nonatomic, copy) NSString *toLabelText;

// 内容
@property (nonatomic, copy) NSString *content;

// 图片
@property (nonatomic, strong) UFUIImagePickerModel *imagePickerModel;

// 固定值
@property (nonatomic, assign) CGFloat selectedPhotoCollectionViewViewItemSpacing;

// 固定值
@property (nonatomic, assign) CGFloat selectedPhotoCollectionViewViewLineSpacing;


- (instancetype)init NS_UNAVAILABLE;

// 必须以这个API进行初始化
- (instancetype)initWithTopicModel:(UFMTopicModel *)topicModel NS_DESIGNATED_INITIALIZER;

// 每个图片的展示的cell的大小
- (CGSize)pickedPhotoCellSize;

// 承载所有图片的CollectionView的大小
- (CGSize)pickedPhotoCollectionViewSize;

// 是否可以发布
- (BOOL)isAbleToPublish:(NSString * _Nullable *_Nonnull)errorMessage;

// 清空内容和图片
- (void)clear;

// 添加评论
- (void)addPostInBackground:(void(^)(NSError *error))block;

@end

NS_ASSUME_NONNULL_END
