//
//  UIImage+UFUIDefaultAvatar.m
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2022/12/5.
//

#import "UIImage+UFUIDefaultAvatar.h"

@implementation UIImage (UFUIDefaultAvatar)

+ (UIImage *)ufui_defaultAvatar {
    UIImageSymbolConfiguration *imageSymbolConfig = [UIImageSymbolConfiguration configurationWithPointSize:36.0f];
    return [UIImage systemImageNamed:@"person.crop.circle" withConfiguration:imageSymbolConfig];
}

@end
