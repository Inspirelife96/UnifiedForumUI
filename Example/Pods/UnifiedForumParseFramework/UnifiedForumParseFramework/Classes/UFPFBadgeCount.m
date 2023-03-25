//
//  UFPFBadgeCount.m
//  UFPFParse
//
//  Created by XueFeng Chen on 2022/5/29.
//

#import "UFPFBadgeCount.h"

#import <Parse/PFObject+Subclass.h>

#import "UFPFDefines.h"

@implementation UFPFBadgeCount

@dynamic user;
@dynamic totalCount;
@dynamic commentCount;
@dynamic likeCount;
@dynamic followCount;
@dynamic messageCount;
@dynamic otherCount;

+ (NSString *)parseClassName {
    return UFPFBadgeCountKeyClass;
}

@end
