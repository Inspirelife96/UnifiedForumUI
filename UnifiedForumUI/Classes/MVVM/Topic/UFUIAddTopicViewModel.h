//
//  UFUIAddTopicViewModel.h
//  INSParseUI
//
//  Created by XueFeng Chen on 2021/7/2.
//

#import <Foundation/Foundation.h>

#import "UFUIConstants.h"

@class UFUIImagePickerModel;
@class UFUITextViewCellViewModel;

NS_ASSUME_NONNULL_BEGIN

@interface UFUIAddTopicViewModel : NSObject

// 板块信息
@property (nonatomic, copy) NSString *category;

// 标题
@property (nonatomic, copy) NSString *title;

// 文本内容
@property (nonatomic, copy) NSString *content;

// 选择图片
@property (nonatomic, strong) UFUIImagePickerModel *imagePickerModel;

// 选择的标签
@property (nonatomic, copy) NSArray<NSString *> *selectedTags;

// 固定值
@property (nonatomic, assign) CGFloat selectedPhotoCollectionViewViewItemSpacing;

// 固定值
@property (nonatomic, assign) CGFloat selectedPhotoCollectionViewViewLineSpacing;

// 每个图片的展示的cell的大小
- (CGSize)pickedPhotoCellSize;

// 承载所有图片的CollectionView的大小
- (CGSize)pickedPhotoCollectionViewSize;

// 标签栏的高度
- (CGFloat)heightForSelectedTagsView;

- (BOOL)isAbleToPublish:(NSString **)errorMessage;

- (BOOL)needWarningWhenCancel;

- (void)clear;

- (void)addTopicInBackground:(void(^)(NSError *error))block;

@end

NS_ASSUME_NONNULL_END
