//
//  UFUIBundle.m
//  UnifiedForumUI-INSParseUI
//
//  Created by XueFeng Chen on 2021/10/23.
//

#import "UFUIBundle.h"

@implementation UFUIBundle

+ (NSBundle *)resourceBundle {
    NSString *bundlePath = [[NSBundle bundleForClass:[self class]].resourcePath
                                stringByAppendingPathComponent:@"/UnifiedForumUI.bundle"];
    return [NSBundle bundleWithPath:bundlePath];
}

+ (UIImage *)imageNamed:(NSString *)name {
    if (@available(iOS 13.0, *)) {
        return [UIImage imageNamed:name inBundle:[UFUIBundle resourceBundle] withConfiguration:nil];
    } else {
        return [UIImage imageNamed:name inBundle:[UFUIBundle resourceBundle] compatibleWithTraitCollection:nil];
    }
}

@end
