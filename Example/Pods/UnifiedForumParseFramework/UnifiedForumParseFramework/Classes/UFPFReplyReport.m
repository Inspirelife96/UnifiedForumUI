//
//  UFPFReplyReport.m
//  UFPFParse
//
//  Created by XueFeng Chen on 2022/5/5.
//

#import "UFPFReplyReport.h"

#import "UFPFDefines.h"

@implementation UFPFReplyReport

@dynamic fromUser;
@dynamic toReply;
@dynamic reason;

+ (NSString *)parseClassName {
    return UFPFReplyReportKeyClass;
}

@end
