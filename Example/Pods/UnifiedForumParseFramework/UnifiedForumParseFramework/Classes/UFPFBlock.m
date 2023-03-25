//
//  UFPFBlock.m
//  UFPFParse
//
//  Created by XueFeng Chen on 2021/9/7.
//

#import "UFPFBlock.h"

#import <Parse/PFObject+Subclass.h>

#import "UFPFDefines.h"

@implementation UFPFBlock

@dynamic fromUser;
@dynamic toUser;

+ (NSString *)parseClassName {
    return UFPFBlockKeyClass;
}

@end
