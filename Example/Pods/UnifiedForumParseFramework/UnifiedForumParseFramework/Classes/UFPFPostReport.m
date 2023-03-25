//
//  UFPFPostReport.m
//  UFPFParse
//
//  Created by XueFeng Chen on 2022/5/5.
//

#import "UFPFPostReport.h"

#import "UFPFDefines.h"

@implementation UFPFPostReport

@dynamic fromUser;
@dynamic toPost;
@dynamic reason;

+ (NSString *)parseClassName {
    return UFPFPostReportKeyClass;
}

@end
