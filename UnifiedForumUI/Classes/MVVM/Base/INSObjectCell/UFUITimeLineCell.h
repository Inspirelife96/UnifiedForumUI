//
//  UFUITimeLineCell.h
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2023/3/21.
//

#import "UFUIObjectCell.h"

@class UFUITimeLineCell;

NS_ASSUME_NONNULL_BEGIN

@protocol UFUITimeLineCell <NSObject>

- (void)clickTopicButtonInCell:(UFUITimeLineCell *)timeLineCell;

- (void)clickFollowStatusButtonInCell:(UFUITimeLineCell *)timeLineCell;

- (void)clickUserButtonInCell:(UFUITimeLineCell *)timeLineCell;

@end

@interface UFUITimeLineCell : UFUIObjectCell

@end

NS_ASSUME_NONNULL_END
