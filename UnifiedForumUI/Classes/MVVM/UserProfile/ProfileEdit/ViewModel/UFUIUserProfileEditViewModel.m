//
//  UFUIUserProfileEditViewModel.m
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2021/10/26.
//

#import "UFUIUserProfileEditViewModel.h"

#import "UFMUserModel.h"

#import "UFUIUFMServiceErrorHandler.h"

@interface UFUIUserProfileEditViewModel ()

@end

@implementation UFUIUserProfileEditViewModel

- (instancetype)initWithUserViewModel:(UFMUserModel *)userModel {
    if (self = [super init]) {
        _userModel = userModel;
        _userId = userModel.userId;
        
        _userName = userModel.username;
        _bio = userModel.bio;
        
        if (userModel.avatarImageModel) {
            _avatarImageUrlString = userModel.avatarImageModel.url;
        } else {
            _avatarImageUrlString = nil;
        }
        
        if (userModel.backgroundImageModel) {
            _backgroundImageUrlString = userModel.backgroundImageModel.url;
        } else {
            _backgroundImageUrlString = nil;
        }

        _isAvatarImageChanged = NO;
        _isBackgroundImageChanged = NO;
        _isBioChanged = NO;

        _selectedAvatarImage = nil;
        _selectedBackgroundImage = nil;
        
        _isAnonymousUser = userModel.isAnonymousUser;
        _upgradeUserName = nil;
        _upgradePassword = nil;
        _upgradeEmail = nil;
        _isAccountUpgraded = NO;
    }
    
    return self;
}

- (void)upgradeAccountInBackgroundWithBlock:(void(^)(NSError *error))refreshUIBlock {
    NSAssert(self.upgradeUserName && self.upgradePassword && self.upgradeEmail, @"必须提供用户名，密码，邮箱");
    
    WEAKSELF
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        STRONGSELF

        NSError *error = nil;
        [UFMService upgradeAnonymousUserWithUsername:strongSelf.upgradeUserName password:strongSelf.upgradePassword email:strongSelf.upgradeEmail error:&error];
                
        dispatch_async(dispatch_get_main_queue(), ^{
            refreshUIBlock(error);
        });
    });
}

- (void)saveUserProfileInfoInBackgroundWithBlock:(void(^)(NSError *error))refreshUIBlock {
    NSAssert(self.isBioChanged || self.isAvatarImageChanged || self.isBackgroundImageChanged, @"没有修改，不应该进入这个函数");
    
    WEAKSELF
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        STRONGSELF
        NSError *error = nil;
        [strongSelf.userModel upgradeBio:strongSelf.bio avatarImage:strongSelf.selectedAvatarImage backgroundImage:strongSelf.selectedBackgroundImage error:&error];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            refreshUIBlock(error);
        });
    });
}

- (BOOL)isProfileInfoChanged {
    return self.isBioChanged || self.isAvatarImageChanged || self.isBackgroundImageChanged;
}

@end
