//
//  UFUILogInView.h
//  Bolts
//
//  Created by XueFeng Chen on 2021/6/30.
//

#import <UIKit/UIKit.h>

@class UFUILogInViewModel;

@protocol UFUILogInViewDelegate <NSObject>

- (void)login;
- (void)signUp;
- (void)resetPassword;
- (void)loginWithAppleID;
- (void)loginWithAnonymous;

@end

NS_ASSUME_NONNULL_BEGIN

@interface UFUILogInView : UIView

@property (nonatomic, strong) UFUILogInViewModel *logInVM;

@property (nonatomic, weak) id<UFUILogInViewDelegate> delegate;

- (instancetype)initWithLoginViewModel:(UFUILogInViewModel *)logInVM;

@end

NS_ASSUME_NONNULL_END
