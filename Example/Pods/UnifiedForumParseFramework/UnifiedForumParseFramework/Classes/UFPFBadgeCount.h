//
//  UFPFBadgeCount.h
//  UFPFParse
//
//  Created by XueFeng Chen on 2022/5/29.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface UFPFBadgeCount : PFObject <PFSubclassing>

@property (nonatomic, strong) PFUser *user;
@property (nonatomic, strong) NSNumber *totalCount;
@property (nonatomic, strong) NSNumber *commentCount;
@property (nonatomic, strong) NSNumber *likeCount;
@property (nonatomic, strong) NSNumber *followCount;
@property (nonatomic, strong) NSNumber *messageCount;
@property (nonatomic, strong) NSNumber *otherCount;

@end

NS_ASSUME_NONNULL_END
