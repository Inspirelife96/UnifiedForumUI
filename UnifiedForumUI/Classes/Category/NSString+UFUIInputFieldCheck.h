//
//  NSString+UFUIInputFieldCheck.h
//  INSParseUI
//
//  Created by XueFeng Chen on 2021/11/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (UFUIInputFieldCheck)

- (BOOL)ufui_checkUserName:(NSString **)errorMessage;

- (BOOL)ufui_checkPassword:(NSString **)errorMessage;

- (BOOL)ufui_checkEmail:(NSString **)errorMessage;

@end

NS_ASSUME_NONNULL_END
