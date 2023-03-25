//
//  NSString+UFUIInputFieldCheck.m
//  INSParseUI
//
//  Created by XueFeng Chen on 2021/11/8.
//

#import "NSString+UFUIInputFieldCheck.h"

#import "UFUIConstants.h"

@implementation NSString (UFUIInputFieldCheck)

- (BOOL)ufui_checkUserName:(NSString **)errorMessage {
    if ([self isEqualToString:@""]) {
        *errorMessage = KUFUILocalization(@"checkUserName.invalid");
        return NO;
    } else {
        return YES;
    }
}

- (BOOL)ufui_checkPassword:(NSString **)errorMessage {
    if ([self isEqualToString:@""]) {
        *errorMessage = KUFUILocalization(@"checkPassword.invalid");
        return NO;
    } else {
        return YES;
    }
}

- (BOOL)ufui_checkEmail:(NSString **)errorMessage {
    if ([self jk_isEmailAddress]) {
        return YES;
    } else {
        *errorMessage = KUFUILocalization(@"checkEmail.invalid");
        return NO;
    }
}

@end
