//
//  UFUILogInViewController.h
//  UFUIParseUI
//
//  Created by XueFeng Chen on 2021/6/30.
//

#import <UIKit/UIKit.h>


@class UFUILogInViewModel;

NS_ASSUME_NONNULL_BEGIN

@interface UFUILogInViewController : UIViewController

- (instancetype)initWithLogInViewModel:(UFUILogInViewModel *)logInVM;

@end

NS_ASSUME_NONNULL_END
