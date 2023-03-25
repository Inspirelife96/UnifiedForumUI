//
//  UFPFTopicLike.m
//  UFPFParse
//
//  Created by XueFeng Chen on 2022/5/2.
//

#import "UFPFTopicLike.h"

#import "UFPFDefines.h"

@implementation UFPFTopicLike

@dynamic fromUser;
@dynamic toTopic;
@dynamic isDeleted;

+ (NSString *)parseClassName {
    return UFPFTopicLikeKeyClass;
}

@end
