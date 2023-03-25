//
//  UFUIUFMServiceErrorHandler.m
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2021/6/27.
//

#import "UFUIUFMServiceErrorHandler.h"

#import "UFUIConstants.h"

#import "SCLAlertView+ShowOnMostTopViewController.h"

@implementation UFUIUFMServiceErrorHandler

+ (void)handleUFMServiceError:(NSError *)error {
//    // 不是Parse的错误，就别管了
//    if (![error.domain isEqualToString:PFParseErrorDomain]) {
//        return;
//    }
//
//    // 登录过期的处理是特殊的，所以需要单独写，其他的错误都是直接弹出错误提示用户即可。
//    switch (error.code) {
//        case kPFErrorInvalidSessionToken: {
//            [self _handleInvalidSessionTokenError];
//            break;
//        }
//
//        default: {
//            [self _handleError:error];
//        }
//    }
}

+ (void)_handleInvalidSessionTokenError {
//    // 首先要退出登录状态
//
//    // 这边默认 logout肯定比后面的login先执行，理论上登录/登出如果能放到一个串行队列那就更好了。
//    // 这里没有传递UI的刷新操作，而选择发送UFUIUserLogoutNotification通知，这就要求所有UI针对登录/登出通知进行重新刷新。
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [INSNetworkManager logout];
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [[NSNotificationCenter defaultCenter] postNotificationName:UFUIUserLogoutNotification object:nil];
//        });
//    });
//
//    // 显示错误提示框，要求重新登录/也可以等等再登录
//    SCLAlertView *alertView = [[SCLAlertView alloc] init];
//    [alertView addButton:@"去登录" actionBlock:^{
////        KQLoginViewController *loginVC = [[KQLoginViewController alloc] init];
////        loginVC.modalPresentationStyle = UIModalPresentationFullScreen;
////        [topMostVC presentViewController:loginVC animated:YES completion:nil];
//    }];
//
//    [alertView ins_showNoticeOnMostTopViewControllerWithTitle:@"登录已过期" subTitle:@"请重新登录" closeButtonTitle:@"先逛逛" duration:0.0];
}

+ (void)_handleError:(NSError *)error {
//    SCLAlertView *alertView = [[SCLAlertView alloc] init];
//
//    [alertView ins_showErrorOnMostTopViewControllerWithTitle:@"出错啦" subTitle:[UFUIUFMServiceErrorHandler errorMessage:error.code] closeButtonTitle:@"好的" duration:0.0];
}

+ (NSString *)errorMessage:(NSInteger)errorCode {
    NSString *errorMessage = @"未知错误，请重试";
    
//    switch (errorCode) {
//        case kPFErrorInternalServer:
//            errorMessage = @"服务器内部错误，请联系管理员";
//            break;
//
//        case kPFErrorConnectionFailed:
//            errorMessage = @"服务器连接错误，请确认网络连接是否正常或联系管理员";
//            break;
//
//        case kPFErrorObjectNotFound:
//            errorMessage = @"没有找到相应的内容";
//            break;
//            
//        case kPFErrorInvalidQuery:
//            errorMessage = @"非法查询，请联系管理员";
//            break;
//            
//        case kPFErrorInvalidClassName:
//            errorMessage = @"无效的表名，请联系管理员";
//            break;
//            
//        case kPFErrorMissingObjectId:
//            errorMessage = @"没有对象ID，请联系管理员";
//            break;
//            
//        case kPFErrorInvalidKeyName:
//            errorMessage = @"无效的字段名，请联系管理员";
//            break;
//            
//        case kPFErrorInvalidPointer:
//            errorMessage = @"非法指针，请联系管理员";
//            break;
//            
//        case kPFErrorInvalidJSON:
//            errorMessage = @"非法的JSON对象，请联系管理员";
//            break;
//            
//        case kPFErrorCommandUnavailable:
//            errorMessage = @"非法的命令，请联系管理员";
//            break;
//
//        case kPFErrorIncorrectType:
//            errorMessage = @"字段类型错误，请联系管理员";
//            break;
//            
//        case kPFErrorInvalidChannelName:
//            errorMessage = @"非法的频道名，请联系管理员";
//            break;
//            
//        case kPFErrorInvalidDeviceToken:
//            errorMessage = @"非法的设备令牌，请联系管理员";
//            break;
//            
//        case kPFErrorPushMisconfigured:
//            errorMessage = @"推送配置错误，请联系管理员";
//            break;
//            
//        case kPFErrorObjectTooLarge:
//            errorMessage = @"对象内容超过上限，有可能是图片/文字等内容过大，请适当的缩小";
//            break;
//            
//        case kPFErrorOperationForbidden:
//            errorMessage = @"不允许客户端使用的操作，请联系管理员";
//            break;
//            
//        case kPFErrorCacheMiss:
//            errorMessage = @"没有在缓存中找到相应的内容";
//            break;
//            
//        case kPFErrorInvalidNestedKey:
//            errorMessage = @"无效的嵌套的关键字，请联系管理员";
//            break;
//            
//        case kPFErrorInvalidFileName:
//            errorMessage = @"无效的字段名，请联系管理员";
//            break;
//            
//        case kPFErrorInvalidACL:
//            errorMessage = @"无效的ACL，请联系管理员";
//            break;
//            
//        case kPFErrorTimeout:
//            errorMessage = @"请求超时，请稍后再试";
//            break;
//            
//        case kPFErrorInvalidEmailAddress:
//            errorMessage = @"您的邮件格式不正确，请重新输入";
//            break;
//            
//        case kPFErrorDuplicateValue:
//            errorMessage = @"该值已经存在";
//            break;
//            
//        case kPFErrorInvalidRoleName:
//            errorMessage = @"无效的角色名字，请联系管理员";
//            break;
//            
//        case kPFErrorExceededQuota:
//            errorMessage = @"超过系统配额，请联系管理员";
//            break;
//            
//        case kPFScriptError:
//            errorMessage = @"云代码错误，请联系管理员。";
//            break;
//            
//        case kPFValidationError:
//            errorMessage = @"云代码审核错误，请联系管理员";
//            break;
//            
//        case kPFErrorReceiptMissing:
//            errorMessage = @"产品购买收据丢失，请联系管理员";
//            break;
//            
//        case kPFErrorInvalidPurchaseReceipt:
//            errorMessage = @"无效的产品购买收据，请联系管理员";
//            break;
//            
//        case kPFErrorPaymentDisabled:
//            errorMessage = @"当前设备禁止购买，请打开后购买";
//            break;
//            
//        case kPFErrorInvalidProductIdentifier:
//            errorMessage = @"无效的产品ID，请联系管理员";
//            break;
//            
//        case kPFErrorProductNotFoundInAppStore:
//            errorMessage = @"在Apple Store中没有找到该产品";
//            break;
//            
//        case kPFErrorInvalidServerResponse:
//            errorMessage = @"Apple Server返回的内容无效，请联系管理员";
//            break;
//            
//        case kPFErrorProductDownloadFileSystemFailure:
//            errorMessage = @"产品内容下载失败，请联系管理员";
//            break;
//            
//        case kPFErrorInvalidImageData:
//            errorMessage = @"无法讲数据转化成图片，请联系管理员";
//            break;
//            
//        case kPFErrorUnsavedFile:
//            errorMessage = @"文件无法保存，请联系管理员";
//            break;
//            
//        case kPFErrorFileDeleteFailure:
//            errorMessage = @"文件无法删除，请联系管理员";
//            break;
//            
//        case kPFErrorRequestLimitExceeded:
//            errorMessage = @"超过请求上线，请稍后再试";
//            break;
//            
//        case kPFErrorInvalidEventName:
//            errorMessage = @"无效的事件名称，请稍后再试";
//            break;
//            
//        case kPFErrorUsernameMissing:
//            errorMessage = @"请输入用户名";
//            break;
//            
//        case kPFErrorUserPasswordMissing:
//            errorMessage = @"请输入密码";
//            break;
//            
//        case kPFErrorUsernameTaken:
//            errorMessage = @"用户名已存在，请换一个试试";
//            break;
//            
//        case kPFErrorUserEmailTaken:
//            errorMessage = @"该邮箱已经被使用，请换一个试试";
//            break;
//            
//        case kPFErrorUserEmailMissing:
//            errorMessage = @"请输入正确的邮箱地址";
//            break;
//            
//        case kPFErrorUserWithEmailNotFound:
//            errorMessage = @"没有找到和这个邮箱关联的用户";
//            break;
//            
//        case kPFErrorUserCannotBeAlteredWithoutSession:
//            errorMessage = @"当前Session无效，无法修改用户，请联系管理员";
//            break;
//            
//        case kPFErrorUserCanOnlyBeCreatedThroughSignUp:
//            errorMessage = @"用户只能在注册的时候创建";
//            break;
//            
//        case kPFErrorFacebookAccountAlreadyLinked: // or kPFErrorAccountAlreadyLinked
//            errorMessage = @"该账户已经和另一个账号关联了";
//            break;
//            
//
//        case kPFErrorInvalidSessionToken: // or kPFErrorUserIdMismatch
//            errorMessage = @"Session已经过期，请重新登录";
//            break;
//            
//        case kPFErrorFacebookIdMissing: // or kPFErrorLinkedIdMissing
//            errorMessage = @"缺少Facebook/Linked ID";
//            break;
//            
//        case kPFErrorFacebookInvalidSession: // or kPFErrorInvalidLinkedSession
//            errorMessage = @"无效的 Facebook/Linked Session，请重新登录";
//            break;
//
//        default:
//            break;
//    }
    

    return errorMessage;
}
@end
