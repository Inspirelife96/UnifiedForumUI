//
//  UFPFReplyLike.m
//  UFPFParse
//
//  Created by XueFeng Chen on 2022/5/3.
//

#import "UFPFReplyLike.h"

#import "UFPFDefines.h"

@implementation UFPFReplyLike

@dynamic fromUser;
@dynamic toReply;
@dynamic isDeleted;

+ (NSString *)parseClassName {
    return UFPFReplyLikeKeyClass;
}

@end
