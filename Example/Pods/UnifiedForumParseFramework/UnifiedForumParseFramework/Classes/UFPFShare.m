//
//  UFPFShare.m
//  UFPFParse
//
//  Created by XueFeng Chen on 2021/6/22.
//

#import "UFPFShare.h"

#import <Parse/PFObject+Subclass.h>

#import "UFPFDefines.h"

@implementation UFPFShare

@dynamic topic;
@dynamic fromUser;
@dynamic toPlatform;

+ (NSString *)parseClassName {
    return UFPFShareKeyClass;
}

@end
