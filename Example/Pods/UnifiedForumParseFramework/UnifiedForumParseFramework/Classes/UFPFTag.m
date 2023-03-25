//
//  UFPFTag.m
//  UFPFParse
//
//  Created by XueFeng Chen on 2022/4/19.
//

#import "UFPFTag.h"

#import "UFPFDefines.h"

@implementation UFPFTag

@dynamic name;

+ (NSString *)parseClassName {
    return UFPFTagKeyClass;
}

@end
