//
//  UFPFPostLike.h
//  UFPFParse
//
//  Created by XueFeng Chen on 2022/5/2.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@class UFPFPost;

@interface UFPFPostLike : PFObject <PFSubclassing>

@property (nonatomic, strong) PFUser *fromUser;
@property (nonatomic, strong) UFPFPost *toPost;
@property (nonatomic, assign) BOOL isDeleted;

@end

NS_ASSUME_NONNULL_END
