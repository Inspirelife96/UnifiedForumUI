//
//  UFUIUserProfileViewModel.h
//  Bolts
//
//  Created by XueFeng Chen on 2022/11/12.
//

#import <Foundation/Foundation.h>

@class UFMUserModel;

NS_ASSUME_NONNULL_BEGIN

@interface UFUIUserProfileViewModel : NSObject

// 所有的ViewModel的成员，目的就是为了View的展示，因此尽量保证准备的内容可以直接在控件上展示

@property (nonatomic, copy) UFMUserModel *userModel;

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *bio;

@property (nonatomic, assign) BOOL isEditButtonEnabled;
@property (nonatomic, assign) BOOL isFollowButtonEnabled;
@property (nonatomic, assign) BOOL isLoginButtonEnabled;

@property (nonatomic, copy) NSString *editButtonTitle;
@property (nonatomic, copy) NSString *followButtonTitle;
@property (nonatomic, copy) NSString *loginButtonTitle;

@property (nonatomic, copy) NSString *profileImageUrlString;
@property (nonatomic, copy) NSString *backgroundImageUrlString;

@property (nonatomic, copy) NSAttributedString *followCountAttributedString;
@property (nonatomic, copy) NSAttributedString *followedCountAttributedString;
@property (nonatomic, copy) NSAttributedString *topicCountAttributedString;
@property (nonatomic, copy) NSAttributedString *likedCountAttributedString;

- (instancetype)initWithUserModel:(UFMUserModel *)userModel;

@end

NS_ASSUME_NONNULL_END
