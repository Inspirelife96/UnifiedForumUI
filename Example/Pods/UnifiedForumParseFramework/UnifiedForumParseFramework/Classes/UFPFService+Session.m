//
//  UFPFService+Session.m
//  UFPFParse
//
//  Created by XueFeng Chen on 2022/7/1.
//

#import "UFPFService+Session.h"

@implementation UFPFService (Session)

+ (BOOL)removeInvalidSessions:(NSError **)error {
    if ([PFUser currentUser]) {
        PFQuery *querySession = [PFQuery queryWithClassName:@"_Session"];
        [querySession whereKey:@"user" equalTo:[PFUser currentUser]];
        [querySession whereKey:@"sessionToken" notEqualTo:[PFUser currentUser].sessionToken];
        
        NSArray *sessionArray = [querySession findObjects:error];
        
        if (*error) {
            return NO;
        } else {
            for (NSInteger i = 0; i < sessionArray.count; i++) {
                PFSession *sessionObject = sessionArray[i];
                [sessionObject delete:error];
                
                if (*error) {
                    return NO;
                }
            }
            
            return YES;
        }
    }
    
    return YES;
}

@end
