//
//  UFUIUserProfileViewModel.m
//  Bolts
//
//  Created by XueFeng Chen on 2022/11/12.
//

#import "UFUIUserProfileViewModel.h"

#import "UFUIConstants.h"

@implementation UFUIUserProfileViewModel

- (instancetype)initWithUserModel:(UFMUserModel *)userModel {
    if (self = [super init]) {
        if (userModel) {
            _userModel = userModel;
            
            _userName = userModel.username;
            
            _isLoginButtonEnabled = NO;
            _isEditButtonEnabled = [userModel isEqualToUserModel:[UFMService currentUserModel]];
            _isFollowButtonEnabled = !_isEditButtonEnabled;
            
            _editButtonTitle = KUFUILocalization(@"userProfileView.editButton.title");
            _loginButtonTitle = KUFUILocalization(@"userProfileView.loginButton.title");
            
            if ([userModel isFollowedByUserModel:[UFMService currentUserModel]]) {
                _followButtonTitle = KUFUILocalization(@"userProfileView.followButton.title.followed");
            } else {
                _followButtonTitle = KUFUILocalization(@"userProfileView.followButton.title.unfollowed");
            }
            
            _bio = userModel.bio;
            
            if (_bio == nil || [_bio isEqualToString:@""]) {
                _bio = KUFUILocalization(@"userProfileView.bioLabel.text.default");
            }
            
            if (userModel.avatarImageModel) {
                _profileImageUrlString = userModel.avatarImageModel.url;
            } else {
                _profileImageUrlString = nil;
            }
            
            if (userModel.backgroundImageModel) {
                _backgroundImageUrlString = userModel.backgroundImageModel.url;
            } else {
                _backgroundImageUrlString = nil;
            }
            
            NSString *followCountString = [NSString stringWithFormat:@"%ld", userModel.followingCount];
            NSString *followedCountString = [NSString stringWithFormat:@"%ld", userModel.followerCount];
            NSString *topicCountString = [NSString stringWithFormat:@"%ld", userModel.topicCount];
            NSString *likedCountString = [NSString stringWithFormat:@"%ld", userModel.postCount];

            _followCountAttributedString = [self buildHighlightText:followCountString normalText:KUFUILocalization(@"userProfileView.followCountButton.title")];
            
            _followedCountAttributedString = [self buildHighlightText:followedCountString normalText:KUFUILocalization(@"userProfileView.followedCountButton.title")];
            
            _topicCountAttributedString = [self buildHighlightText:topicCountString normalText:KUFUILocalization(@"userProfileView.topicCountButton.title")];
            
            _likedCountAttributedString = [self buildHighlightText:likedCountString normalText:KUFUILocalization(@"userProfileView.likedCountButton.title")];
        } else {
            _userModel = nil;
            
            _userName = KUFUILocalization(@"userProfileView.userNameLabel.text.notLogIn");
            
            _isLoginButtonEnabled = YES;
            _isEditButtonEnabled = NO;
            _isFollowButtonEnabled = NO;
            
            _loginButtonTitle = KUFUILocalization(@"userProfileView.loginButton.title");
            

            _bio = KUFUILocalization(@"userProfileView.bioLabel.text.notLogIn");
            
            _profileImageUrlString = nil;

            _backgroundImageUrlString = nil;

            _followCountAttributedString = [self buildHighlightText:@"0" normalText:KUFUILocalization(@"userProfileView.followCountButton.title")];
            
            _followedCountAttributedString = [self buildHighlightText:@"0" normalText:KUFUILocalization(@"userProfileView.followedCountButton.title")];
            
            _topicCountAttributedString = [self buildHighlightText:@"0" normalText:KUFUILocalization(@"userProfileView.topicCountButton.title")];
            
            _likedCountAttributedString = [self buildHighlightText:@"0" normalText:KUFUILocalization(@"userProfileView.likedCountButton.title")];

        }
    }
    
    return self;
}

- (NSAttributedString *)buildHighlightText:(NSString *)highlightText normalText:(NSString *)normalText {
    NSString *fullText = [NSString stringWithFormat:@"%@    %@", highlightText, normalText];
    NSRange highlightRange = [fullText rangeOfString:highlightText];
    NSRange normalRange = [fullText rangeOfString:normalText];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:fullText];
    
    [attributedString yy_setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleFootnote] range:highlightRange];
    [attributedString yy_setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleFootnote] range:normalRange];
    
    [attributedString yy_setColor:[UIColor secondaryLabelColor] range:highlightRange];
    [attributedString yy_setColor:[UIColor tertiaryLabelColor] range:normalRange];
    
    return [attributedString copy];
}

@end
