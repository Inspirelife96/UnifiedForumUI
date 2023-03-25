//
//  UFPFStatisticsInfo.m
//  UFPFParse
//
//  Created by XueFeng Chen on 2021/6/26.
//

#import "UFPFStatisticsInfo.h"

#import "UFPFDefines.h"

@implementation UFPFStatisticsInfo

@dynamic user;
@dynamic profileViews;
@dynamic reputation;
@dynamic topicCount;
@dynamic postCount;
@dynamic followerCount;
@dynamic followingCount;
@dynamic likedCount;

+ (NSString *)parseClassName {
    return UFPFStatisticsInfoKeyClass;
}

@end
