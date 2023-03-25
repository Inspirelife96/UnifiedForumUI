//
//  UFPFCategory.m
//  UFPFParse
//
//  Created by XueFeng Chen on 2022/4/19.
//

#import "UFPFCategory.h"

#import "UFPFDefines.h"

@implementation UFPFCategory

@dynamic name;
@dynamic summary;
@dynamic iconImageFileObject;
@dynamic backgroundImageFileObject;

+ (NSString *)parseClassName {
    return UFPFCategoryKeyClass;
}

@end
