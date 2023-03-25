//
//  UFPFStatisticsInfo.h
//  UFPFParse
//
//  Created by XueFeng Chen on 2021/6/26.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface UFPFStatisticsInfo : PFObject <PFSubclassing>

@property (nonatomic, strong) PFUser *user;

// 浏览次数
@property (nonatomic, strong) NSNumber *profileViews;

// 积分
@property (nonatomic, strong) NSNumber *reputation;

// 话题数
@property (nonatomic, strong) NSNumber *topicCount;

// 回复数
@property (nonatomic, strong) NSNumber *postCount;

// 粉丝数
@property (nonatomic, strong) NSNumber *followerCount;

// 关注数
@property (nonatomic, strong) NSNumber *followingCount;

// 收获的赞
@property (nonatomic, strong) NSNumber *likedCount;

@end

NS_ASSUME_NONNULL_END
