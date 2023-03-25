//
//  UFPFBlock.h
//  UFPFParse
//
//  Created by XueFeng Chen on 2021/9/7.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface UFPFBlock : PFObject <PFSubclassing>

@property (nonatomic, strong) PFUser *fromUser;
@property (nonatomic, strong) PFUser *toUser;

@end

NS_ASSUME_NONNULL_END
