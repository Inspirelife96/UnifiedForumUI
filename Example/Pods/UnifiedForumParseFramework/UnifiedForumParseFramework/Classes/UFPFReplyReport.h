//
//  UFPFReplyReport.h
//  UFPFParse
//
//  Created by XueFeng Chen on 2022/5/5.
//

#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@class UFPFReply;

@interface UFPFReplyReport : PFObject <PFSubclassing>

@property (nonatomic, strong) PFUser *fromUser;
@property (nonatomic, strong) UFPFReply *toReply;
@property (nonatomic, strong) NSNumber *reason;

@end

NS_ASSUME_NONNULL_END
