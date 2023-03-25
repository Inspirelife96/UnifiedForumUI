//
//  UFPFTimeLine.m
//  UnifiedForumParseFramework
//
//  Created by XueFeng Chen on 2023/2/19.
//

#import "UFPFTimeLine.h"

#import <Parse/PFObject+Subclass.h>

#import "UFPFDefines.h"

@implementation UFPFTimeLine

@dynamic fromUser;
@dynamic toUser;
@dynamic type;
@dynamic topic;
@dynamic post;
@dynamic reply;
@dynamic isDeleted;

+ (NSString *)parseClassName {
    return UFPFTimeLineKeyClass;
}

@end
