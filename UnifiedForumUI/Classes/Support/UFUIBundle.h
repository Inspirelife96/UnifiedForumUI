//
//  UFUIBundle.h
//  UnifiedForumUI-INSParseUI
//
//  Created by XueFeng Chen on 2021/10/23.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UFUIBundle : NSObject

+ (NSBundle *)resourceBundle;

+ (UIImage *)imageNamed:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
