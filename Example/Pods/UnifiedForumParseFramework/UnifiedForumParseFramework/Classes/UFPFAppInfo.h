//
//  UFPFAppInfo.h
//  UnifiedForumParseFramework
//
//  Created by XueFeng Chen on 2022/11/8.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface UFPFAppInfo : PFObject <PFSubclassing>

@property (nonatomic, copy) NSString *version; // 版本号

@end

NS_ASSUME_NONNULL_END
