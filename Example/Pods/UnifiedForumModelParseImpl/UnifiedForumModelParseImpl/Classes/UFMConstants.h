//
//  UFMConstants.h
//  UnifiedForumModelParseImpl
//
//  Created by XueFeng Chen on 2022/11/10.
//

#import <Foundation/Foundation.h>

///--------------------------------------
#pragma mark - Errors
///--------------------------------------

/**
 Error domain used for all `NSError`s in the SDK.
 */
extern NSString *const _Nonnull UFMErrorDomain;

/**
 `UFMErrorCode` enum contains all custom error codes that are used as `code` for `NSError` for callbacks on all classes.

 These codes are used when `domain` of `NSError` that you receive is set to `UFMErrorDomain`.
 */
typedef NS_ENUM(NSInteger, UFMErrorCode) {
    /**
     Internal server error. No information available.
     */
    kUFMErrorInternalServer = 1,
    /**
     The connection to the Parse servers failed.
     */
    kUFMErrorConnectionFailed = 100,
    /**
     Object doesn't exist, or has an incorrect password.
     */
    kUFMErrorObjectNotFound = 101,
    /**
     You tried to find values matching a datatype that doesn't
     support exact database matching, like an array or a dictionary.
     */
    kUFMErrorInvalidQuery = 102,
    /**
     Missing or invalid classname. Classnames are case-sensitive.
     They must start with a letter, and `a-zA-Z0-9_` are the only valid characters.
     */
    kUFMErrorInvalidClassName = 103,
    /**
     Missing object id.
     */
    kUFMErrorMissingObjectId = 104,
    /**
     Invalid key name. Keys are case-sensitive.
     They must start with a letter, and `a-zA-Z0-9_` are the only valid characters.
     */
    kUFMErrorInvalidKeyName = 105,
    /**
     Malformed pointer. Pointers must be arrays of a classname and an object id.
     */
    kUFMErrorInvalidPointer = 106,
    /**
     Malformed json object. A json dictionary is expected.
     */
    kUFMErrorInvalidJSON = 107,
    /**
     Tried to access a feature only available internally.
     */
    kUFMErrorCommandUnavailable = 108,
    /**
     Field set to incorrect type.
     */
    kUFMErrorIncorrectType = 111,
    /**
     Invalid channel name. A channel name is either an empty string (the broadcast channel)
     or contains only `a-zA-Z0-9_` characters and starts with a letter.
     */
    kUFMErrorInvalidChannelName = 112,
    /**
     Invalid device token.
     */
    kUFMErrorInvalidDeviceToken = 114,
    /**
     Push is misconfigured. See details to find out how.
     */
    kUFMErrorPushMisconfigured = 115,
    /**
     The object is too large.
     */
    kUFMErrorObjectTooLarge = 116,
    /**
     That operation isn't allowed for clients.
     */
    kUFMErrorOperationForbidden = 119,
    /**
     The results were not found in the cache.
     */
    kUFMErrorCacheMiss = 120,
    /**
     Keys in `NSDictionary` values may not include `$` or `.`.
     */
    kUFMErrorInvalidNestedKey = 121,
    /**
     Invalid file name.
     A file name can contain only `a-zA-Z0-9_.` characters and should be between 1 and 36 characters.
     */
    kUFMErrorInvalidFileName = 122,
    /**
     Invalid ACL. An ACL with an invalid format was saved. This should not happen if you use `PFACL`.
     */
    kUFMErrorInvalidACL = 123,
    /**
     The request timed out on the server. Typically this indicates the request is too expensive.
     */
    kUFMErrorTimeout = 124,
    /**
     The email address was invalid.
     */
    kUFMErrorInvalidEmailAddress = 125,
    /**
     A unique field was given a value that is already taken.
     */
    kUFMErrorDuplicateValue = 137,
    /**
     Role's name is invalid.
     */
    kUFMErrorInvalidRoleName = 139,
    /**
     Exceeded an application quota. Upgrade to resolve.
     */
    kUFMErrorExceededQuota = 140,
    /**
     Cloud Code script had an error.
     */
    kUFMScriptError = 141,
    /**
     Cloud Code validation failed.
     */
    kUFMValidationError = 142,
    /**
     Product purchase receipt is missing.
     */
    kUFMErrorReceiptMissing = 143,
    /**
     Product purchase receipt is invalid.
     */
    kUFMErrorInvalidPurchaseReceipt = 144,
    /**
     Payment is disabled on this device.
     */
    kUFMErrorPaymentDisabled = 145,
    /**
     The product identifier is invalid.
     */
    kUFMErrorInvalidProductIdentifier = 146,
    /**
     The product is not found in the App Store.
     */
    kUFMErrorProductNotFoundInAppStore = 147,
    /**
     The Apple server response is not valid.
     */
    kUFMErrorInvalidServerResponse = 148,
    /**
     Product fails to download due to file system error.
     */
    kUFMErrorProductDownloadFileSystemFailure = 149,
    /**
     Fail to convert data to image.
     */
    kUFMErrorInvalidImageData = 150,
    /**
     Unsaved file.
     */
    kUFMErrorUnsavedFile = 151,
    /**
     Fail to delete file.
     */
    kUFMErrorFileDeleteFailure = 153,
    /**
     Application has exceeded its request limit.
     */
    kUFMErrorRequestLimitExceeded = 155,
    /**
     Invalid event name.
     */
    kUFMErrorInvalidEventName = 160,
    /**
     Username is missing or empty.
     */
    kUFMErrorUsernameMissing = 200,
    /**
     Password is missing or empty.
     */
    kUFMErrorUserPasswordMissing = 201,
    /**
     Username has already been taken.
     */
    kUFMErrorUsernameTaken = 202,
    /**
     Email has already been taken.
     */
    kUFMErrorUserEmailTaken = 203,
    /**
     The email is missing, and must be specified.
     */
    kUFMErrorUserEmailMissing = 204,
    /**
     A user with the specified email was not found.
     */
    kUFMErrorUserWithEmailNotFound = 205,
    /**
     The user cannot be altered by a client without the session.
     */
    kUFMErrorUserCannotBeAlteredWithoutSession = 206,
    /**
     Users can only be created through sign up.
     */
    kUFMErrorUserCanOnlyBeCreatedThroughSignUp = 207,
    /**
     An existing Facebook account already linked to another user.
     */
    kUFMErrorFacebookAccountAlreadyLinked = 208,
    /**
     An existing account already linked to another user.
     */
    kUFMErrorAccountAlreadyLinked = 208,
    /**
     Error code indicating that the current session token is invalid.
     */
    kUFMErrorInvalidSessionToken = 209,
    kUFMErrorUserIdMismatch = 209,
    /**
     Facebook id missing from request.
     */
    kUFMErrorFacebookIdMissing = 250,
    /**
     Linked id missing from request.
     */
    kUFMErrorLinkedIdMissing = 250,
    /**
     Invalid Facebook session.
     */
    kUFMErrorFacebookInvalidSession = 251,
    /**
     Invalid linked session.
     */
    kUFMErrorInvalidLinkedSession = 251,
};
