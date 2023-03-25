//
//  UFPFReply.m
//  UFPFParse
//
//  Created by XueFeng Chen on 2021/12/28.
//

#import "UFPFReply.h"

#import <Parse/PFObject+Subclass.h>

#import "UFPFDefines.h"

@implementation UFPFReply

@dynamic isApproved;
@dynamic isDeleted;
@dynamic content;
@dynamic likeCount;
@dynamic fromUser;
@dynamic toPost;
@dynamic toReply;

+ (NSString *)parseClassName {
    return UFPFReplyKeyClass;
}

@end
