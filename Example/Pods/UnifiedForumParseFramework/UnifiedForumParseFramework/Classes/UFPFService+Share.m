//
//  UFPFService+Share.m
//  UFPFParse
//
//  Created by XueFeng Chen on 2021/6/24.
//

#import "UFPFService+Share.h"

#import "UFPFDefines.h"
#import "UFPFShare.h"

@implementation UFPFService (Share)

+ (BOOL)addShareTopic:(UFPFTopic *)Topic
             fromUser:(PFUser *)fromUser
           toPlatform:(NSString *)toPlatform
                error:(NSError **)error {
    UFPFShare *share = [[UFPFShare alloc] init];

    share.fromUser = fromUser;
    share.topic = Topic;
    share.toPlatform = toPlatform;
    
    return [share save:error];
//
//    BOOL succeeded = [share save:error];
//
//    if (succeeded) {
//        return [UFPFService addShareActivity:share error:error];
//    } else {
//        return succeeded;
//    }
}

@end
