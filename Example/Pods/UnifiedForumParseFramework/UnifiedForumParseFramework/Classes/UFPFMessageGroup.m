//
//  UFPFMessageGroup.m
//  UFPFParse
//
//  Created by XueFeng Chen on 2022/5/28.
//

#import "UFPFMessageGroup.h"

#import <Parse/PFObject+Subclass.h>

#import "UFPFDefines.h"

@implementation UFPFMessageGroup

@dynamic fromUser;
@dynamic toUser;
@dynamic lastMessage;
@dynamic unreadMessageCount;

+ (NSString *)parseClassName {
    return UFPFMessageGroupKeyClass;
}

@end
