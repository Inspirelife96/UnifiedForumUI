//
//  UFPFPost.h
//  UFPFParse
//
//  Created by XueFeng Chen on 2021/6/22.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@class UFPFTopic;
@class UFPFReply;

@interface UFPFPost : PFObject <PFSubclassing>

// 标记
@property (nonatomic, assign) BOOL isApproved; // 是否许可，管理员可批准
@property (nonatomic, assign) BOOL isDeleted; // 软删除，作者可删除

// 核心内容
@property (nonatomic, copy) NSString *content; // 内容
@property (nonatomic, strong) NSArray<PFFileObject *> *mediaFileObjects; // 图片/音频/视频文件
@property (nonatomic, strong) NSString *mediaFileType; // image/audio/video/html/md/mixed?
@property (nonatomic, strong) NSArray <UFPFReply *> *replies; // 最近的5条

// 统计字段：
@property (nonatomic, strong) NSNumber *replyCount; //总数
@property (nonatomic, strong) NSNumber *likeCount;

// 关系
@property (nonatomic, strong) PFUser *fromUser;
@property (nonatomic, strong) UFPFTopic *toTopic;

@end

NS_ASSUME_NONNULL_END
