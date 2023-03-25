//
//  UFUITimeLineLikeTopicCellViewModel.h
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2023/3/21.
//

#import "UFUITimeLineCellViewModel.h"

@class UFMTimeLineModel;

NS_ASSUME_NONNULL_BEGIN

@interface UFUITimeLineLikeTopicCellViewModel : UFUITimeLineCellViewModel

// 用户头像
@property (nonatomic, copy, nullable) NSString *fromUserAvatarUrlString;
// 用户名
@property (nonatomic, copy) NSString *title;
// 发布时间
@property (nonatomic, copy) NSString *timeInfo;

@property (nonatomic, copy) NSString *topicTitle;
@property (nonatomic, copy) NSString *topicContent;
@property (nonatomic, copy) NSString *topicFromUserName;
@property (nonatomic, copy) NSString *topicPostInfo;
@property (nonatomic, copy) NSString *topicLikeInfo;

@property (nonatomic, strong) UFMTimeLineModel *timeLineModel;


@end

NS_ASSUME_NONNULL_END
