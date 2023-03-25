//
//  UFPFService+Block.h
//  UFPFParse
//
//  Created by XueFeng Chen on 2022/7/21.
//

#import "UFPFService.h"

NS_ASSUME_NONNULL_BEGIN

@class UFPFBlock;

@interface UFPFService (Block)

+ (UFPFBlock *)addBlockFromUser:(PFUser *)fromUser toUser:(PFUser *)toUser error:(NSError **)error;

+ (PFQuery *)buildBlockQueryWhereFromUserIs:(PFUser *)user;

@end

NS_ASSUME_NONNULL_END
