//
//  UFPFPost.m
//  UFPFParse
//
//  Created by XueFeng Chen on 2021/6/22.
//

#import "UFPFPost.h"

#import <Parse/PFObject+Subclass.h>

#import "UFPFDefines.h"

@implementation UFPFPost

@dynamic isApproved;
@dynamic isDeleted;
@dynamic content;
@dynamic mediaFileObjects;
@dynamic mediaFileType;
@dynamic replies;
@dynamic replyCount;
@dynamic likeCount;
@dynamic fromUser;
@dynamic toTopic;

+ (NSString *)parseClassName {
    return UFPFPostKeyClass;
}

@end
