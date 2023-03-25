//
//  UFPFService+Message.m
//  UFPFParse
//
//  Created by XueFeng Chen on 2022/7/28.
//

#import "UFPFService+Message.h"

#import "UFPFDefines.h"

#import "UFPFMessage.h"

@implementation UFPFService (Message)

+ (NSArray<UFPFMessage *> *)findMessagesFromUser:(PFUser *)fromUser
                                         toUser:(PFUser *)toUser
                                           page:(NSInteger)page
                                      pageCount:(NSInteger)pageCount
                                          error:(NSError **)error {
    PFQuery *query = [PFQuery queryWithClassName:UFPFMessageKeyClass];
    [query whereKey:UFPFMessageKeyFromUser equalTo:fromUser];
    [query whereKey:UFPFMessageKeyToUser equalTo:toUser];
    
    [query orderByDescending:UFPFKeyCreatedAt];
    
    [query setSkip:pageCount * page];
    [query setLimit:pageCount];
    
    return [query findObjects:error];
}

+ (UFPFMessage *)addMessageFromUser:(PFUser *)fromUser toUser:(PFUser *)toUser content:(NSString *)content error:(NSError **)error {
    UFPFMessage *message = [[UFPFMessage alloc] init];
    message.fromUser = fromUser;
    message.toUser = toUser;
    message.content = content;
    
    BOOL succeeded = [message save:error];
    if (succeeded) {
        return message;
    } else {
        return nil;
    }
}

@end
