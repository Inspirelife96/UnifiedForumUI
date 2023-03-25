//
//  UFPFTopic.h
//  UFPFParse
//
//  Created by XueFeng Chen on 2021/6/22.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@class UFPFCategory;
@class UFPFTag;

@interface UFPFTopic : PFObject <PFSubclassing>

// 标记：
@property (nonatomic, assign) BOOL isLocked; // 锁定，作者可锁定，锁定之后，Topic可以展示，但不能回贴
@property (nonatomic, assign) BOOL isDeleted; // 软删除，作者可删除
@property (nonatomic, assign) BOOL isPrivate; // 是否私有，作者可标记
@property (nonatomic, assign) BOOL isApproved; // 是否许可，管理员可批准
@property (nonatomic, assign) BOOL isPopular; // 是否置顶，管理员可置顶

// 核心字段：
@property (nonatomic, copy) NSString *title; // 标题
@property (nonatomic, copy) NSString *content; // 内容
@property (nonatomic, strong) NSArray<PFFileObject *> *mediaFileObjects; // 图片/音频/视频文件/或者HTML/MD文件
@property (nonatomic, strong) NSString *mediaFileType; // image/audio/video/html/md/mixed?
@property (nonatomic, strong) PFUser *fromUser; // 发布者

// 统计字段：
@property (nonatomic, strong) NSNumber *postCount; // 回帖次数
@property (nonatomic, strong) NSNumber *likeCount; // 点赞次数
@property (nonatomic, strong) NSNumber *shareCount; // 分享次数

// 板块/话题：
@property (nonatomic, strong) NSString *category; // 板块
@property (nonatomic, strong) NSArray<NSString *> *tags; // 标签

@end

NS_ASSUME_NONNULL_END
