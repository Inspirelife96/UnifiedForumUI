//
//  UFPFTopicReport.m
//  UFPFParse
//
//  Created by XueFeng Chen on 2022/5/5.
//

#import "UFPFTopicReport.h"

#import "UFPFDefines.h"

@implementation UFPFTopicReport

@dynamic fromUser;
@dynamic toTopic;
@dynamic reason;

+ (NSString *)parseClassName {
    return UFPFTopicReportKeyClass;
}

@end
