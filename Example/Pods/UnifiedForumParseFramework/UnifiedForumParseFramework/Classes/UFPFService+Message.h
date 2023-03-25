//
//  UFPFService+Message.h
//  UFPFParse
//
//  Created by XueFeng Chen on 2022/7/28.
//

#import "UFPFService.h"

NS_ASSUME_NONNULL_BEGIN

@class UFPFMessage;

@interface UFPFService (Message)

+ (NSArray<UFPFMessage *> *)findMessagesFromUser:(PFUser *)fromUser
                                         toUser:(PFUser *)toUser
                                           page:(NSInteger)page
                                      pageCount:(NSInteger)pageCount
                                          error:(NSError **)error;

+ (UFPFMessage *)addMessageFromUser:(PFUser *)fromUser toUser:(PFUser *)toUser content:(NSString *)content error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
