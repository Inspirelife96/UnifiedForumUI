//
//  UFPFService+Block.m
//  UFPFParse
//
//  Created by XueFeng Chen on 2022/7/21.
//

#import "UFPFService+Block.h"

#import "UFPFDefines.h"

#import "UFPFBlock.h"

@implementation UFPFService (Block)

+ (UFPFBlock *)addBlockFromUser:(PFUser *)fromUser toUser:(PFUser *)toUser error:(NSError **)error {
    UFPFBlock *block = [[UFPFBlock alloc] init];
    block.fromUser = fromUser;
    block.toUser = toUser;
    
    BOOL succeeded = [block save:error];
    
    if (succeeded) {
        return block;
    } else {
        return nil;
    }
}

+ (PFQuery *)buildBlockQueryWhereFromUserIs:(PFUser *)user {
    PFQuery *query = [PFQuery queryWithClassName:UFPFBlockKeyClass];
    [query whereKey:UFPFBlockKeyFromUser equalTo:user];
    return query;
}

@end
