//
//  UFPFAppInfo.m
//  UnifiedForumParseFramework
//
//  Created by XueFeng Chen on 2022/11/8.
//

#import "UFPFAppInfo.h"

#import <Parse/PFObject+Subclass.h>

#import "UFPFDefines.h"

@implementation UFPFAppInfo

@dynamic version;

+ (NSString *)parseClassName {
    return UFPFAppInfoKeyClass;
}

@end
