//
//  UFMTopicModel.h
//  Bolts
//
//  Created by XueFeng Chen on 2022/10/22.
//

#import "UFMObjectModel.h"

@class UFMFileModel;
@class UFMUserModel;

NS_ASSUME_NONNULL_BEGIN

@interface UFMTopicModel : UFMObjectModel

// ID
@property (nonatomic, copy) NSString *topicId;

// 标题
@property (nonatomic, copy) NSString *title;

// 文本内容
@property (nonatomic, copy) NSString *content;

// 附加内容
@property (nonatomic, copy) NSArray<UFMFileModel *> *fileModelArray;

// 附加内容的类型
@property (nonatomic, copy) NSString *fileType;

// 发布者信息
@property (nonatomic, strong) UFMUserModel *fromUserModel;

// 评论数
@property (nonatomic, assign) NSInteger postCount;

// 点赞数
@property (nonatomic, assign) NSInteger likeCount;

// 分享数
@property (nonatomic, assign) NSInteger shareCount;

// 发布日期
@property (nonatomic, strong) NSDate *createdAt;

// 板块
@property (nonatomic, strong) NSString *category;

// 标签
@property (nonatomic, strong) NSArray<NSString *> *tags;

// 标记位：锁定
@property (nonatomic, assign) BOOL isLocked;

// 标记位：软删除
@property (nonatomic, assign) BOOL isDeleted;

// 标记位：是否私有
@property (nonatomic, assign) BOOL isPrivate;

// 标记位：是否可以展示
@property (nonatomic, assign) BOOL isApproved;

// 标记位：是否置顶
@property (nonatomic, assign) BOOL isPopular;

- (instancetype)initWithTitle:(NSString *)title
                      content:(NSString *)content
               fileModelArray:(NSArray<UFMFileModel *> * _Nullable)fileModelArray
                     fileType:(NSString *)fileType
                fromUserModel:(UFMUserModel *)fromUserModel
                     category:(NSString * _Nullable)category
                         tags:(NSArray<NSString *> * _Nullable)tags
                        error:(NSError **)error;

- (void)save:(NSError **)error;

- (BOOL)isLikedByUserModel:(UFMUserModel *)userModel error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
