//
//  UFMService+UserModel.m
//  UFMParseImpl
//
//  Created by XueFeng Chen on 2022/11/8.
//

#import "UFMService+UserModel.h"

#import "UFMUserModel.h"

static UFMUserModel *currentUserModel_ = nil;

@implementation UFMService (User)

+ (UFMUserModel *)currentUserModel {
    if (![PFUser currentUser]) {
        return nil;
    } else {
        if (currentUserModel_) {
            return currentUserModel_;
        } else {
            currentUserModel_ = [[UFMUserModel alloc] initWithMetaData:[PFUser currentUser]];
            return currentUserModel_;
        }
    }
}

+ (void)logInWithUsername:(NSString *)userName password:(NSString *)password error:(NSError **)error {
    [UFPFService logInWithUsername:userName password:password error:error];
    
    if ([PFUser currentUser]) {
        currentUserModel_ = [[UFMUserModel alloc] initWithMetaData:[PFUser currentUser]];
    }
}

+ (BOOL)loginWithAppleAuthType:(NSString *)authType authData:(NSDictionary<NSString *, NSString *> *)authData error:(NSError **)error {
    BOOL isCompleted = [UFPFService loginWithAppleAuthType:authType authData:authData error:error];
    
    if ([PFUser currentUser]) {
        currentUserModel_ = [[UFMUserModel alloc] initWithMetaData:[PFUser currentUser]];
    }
    
    return isCompleted;
}

+ (void)logInWithAnonymous:(NSError **)error {
    [UFPFService logInWithAnonymous:error];
    
    if ([PFUser currentUser]) {
        currentUserModel_ = [[UFMUserModel alloc] initWithMetaData:[PFUser currentUser]];
    }
}

+ (void)upgradeAnonymousUserWithUsername:(NSString *)userName password:(NSString *)password email:(NSString *)email error:(NSError **)error {
    [UFPFService upgradeCurrentAnonymousUserWithUsername:userName password:password email:email error:error];
    
    if ([PFUser currentUser] && !*error) {
        currentUserModel_.username = userName;
        currentUserModel_.isAnonymousUser = NO;
    }
}

+ (void)signUpWithUsername:(NSString *)userName password:(NSString *)password email:(NSString *)email error:(NSError **)error {
    [UFPFService signUpWithUsername:userName password:password email:email error:error];
}

+ (void)logOut {
    [UFPFService logOut];
    currentUserModel_ = nil;
}

+ (void)requestPasswordResetForEmail:(NSString *)email error:(NSError **)error {
    [UFPFService requestPasswordResetForEmail:email error:error];
}

+ (void)unsubscribe:(NSError **)error {
    [UFPFService unsubscribe:error];
    currentUserModel_ = nil;
}

@end
