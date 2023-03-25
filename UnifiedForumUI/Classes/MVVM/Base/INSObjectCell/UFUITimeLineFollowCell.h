//
//  UFUITimeLineFollowCell.h
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2023/2/20.
//

#import "UFUITimeLineCell.h"

NS_ASSUME_NONNULL_BEGIN

@class UFUITimeLineFollowCell;
@class UFUITimeLineHeaderView;

@protocol UFUITimeLineFollowCellDelegate <NSObject>

- (void)clickFromUserAvatarButtonInCell:(UFUITimeLineFollowCell *)timeLineFollowCell;
- (void)clickFromUserNameButtonInCell:(UFUITimeLineFollowCell *)timeLineFollowCell;
- (void)clickToUserAvatarButtonInCell:(UFUITimeLineFollowCell *)timeLineFollowCell;
- (void)clickToUserNameButtonInCell:(UFUITimeLineFollowCell *)timeLineFollowCell;
- (void)clickFollowButtonInCell:(UFUITimeLineFollowCell *)timeLineFollowCell;

@end

@interface UFUITimeLineFollowCell : UFUITimeLineCell

@property (nonatomic, strong) UFUITimeLineHeaderView *timeLineHeaderView;

@property (nonatomic, strong) UIImageView *followedUserAvatarImageView;
@property (nonatomic, strong) UILabel *followedUserNameLabel;
@property (nonatomic, strong) UILabel *followedUserInfoLabel;
@property (nonatomic, strong) UILabel *followedUserBioLabel;

@property (nonatomic, strong) UIButton *followedUserButton;
@property (nonatomic, strong) UIButton *followStatusButton;

@end

NS_ASSUME_NONNULL_END
