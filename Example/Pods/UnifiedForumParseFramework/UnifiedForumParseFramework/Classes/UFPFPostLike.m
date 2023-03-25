//
//  UFPFPostLike.m
//  UFPFParse
//
//  Created by XueFeng Chen on 2022/5/2.
//

#import "UFPFPostLike.h"

#import "UFPFDefines.h"

@implementation UFPFPostLike

@dynamic fromUser;
@dynamic toPost;
@dynamic isDeleted;

+ (NSString *)parseClassName {
    return UFPFPostLikeKeyClass;
}

@end
