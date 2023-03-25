//
//  UFPFService+TopicReport.m
//  UFPFParse
//
//  Created by XueFeng Chen on 2022/5/20.
//

#import "UFPFService+TopicReport.h"

#import "UFPFTopicReport.h"

@implementation UFPFService (TopicReport)

+ (UFPFTopicReport *)addTopicReportFromUser:(PFUser *)fromUser toTopic:(UFPFTopic *)toTopic forReason:(UFPFParseReportReason)reason error:(NSError **)error {
    UFPFTopicReport *topicReport = [[UFPFTopicReport alloc] init];
    
    topicReport.fromUser = fromUser;
    topicReport.toTopic = toTopic;
    topicReport.reason = @(reason);
    
    BOOL succeeded = [topicReport save:error];
    
    if (succeeded) {
        return topicReport;
    } else {
        return nil;
    }
}

@end
