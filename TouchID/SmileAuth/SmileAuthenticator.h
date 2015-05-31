//
//  SmileAuthenticator.h
//  TouchID
//
//  Created by ryu-ushin on 5/25/15.
//  Copyright (c) 2015 rain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LocalAuthentication/LocalAuthentication.h>
#import "KeychainWrapper.h"
#import "SmileSettingVC.h"

#define kPasswordLength 4

#define DispatchMainThread(block, ...) if(block) dispatch_async(dispatch_get_main_queue(), ^{ block(__VA_ARGS__); })
typedef void(^AuthCompletionBlock)();
typedef void(^AuthErrorBlock)(LAError);

/*!
 @typedef SecurityType
 
 @brief  A struct about the SecurityType.
 
 @discussion
 There are four types, pass the SecurtiyType to destination View Controller for appropriate security interface.
 */
typedef NS_ENUM(int, SecurityType) {
    /*! For the user turn off the password switch, user need input their password once for turn the password off. */
    INPUT_ONCE,
    /*! For the user turn on the password switch, user need input their password twice to confirm their password match each other. */
    INPUT_TWICE,
    /*! For the user change the password, user need input their password three times for change to new password. */
    INPUT_THREE,
    /*! For the user open app, user can use touch ID or input password. */
    INPUT_TOUCHID,
};

@protocol AuthenticatorDelegate;

@interface SmileAuthenticator : NSObject

@property (nonatomic, copy) NSString * localizedReason;
@property (nonatomic, strong) KeychainWrapper *keychainWrapper;
@property (nonatomic, assign) SecurityType securityType;
@property (nonatomic, strong) UIViewController *rootVC;

@property (nonatomic, weak) id <AuthenticatorDelegate> delegate;

+(SmileAuthenticator*)sharedInstance;

+ (BOOL)canAuthenticateWithError:(NSError **) error;

-(void)authenticateWithSuccess:(AuthCompletionBlock) authSuccessBlock andFailure:(AuthErrorBlock) failureBlock;

+(BOOL)hasPassword;

+(BOOL)isSamePassword:(NSString *)userInput;

-(void)userSetPassword:(NSString*)newPassword;

+(void)clearPassword;

-(void)presentAuthViewController;

-(void)authViewControllerDismissed;

-(void)touchID_OR_PasswordAuthSuccess;
-(void)touchID_OR_PasswordAuthFail:(NSInteger)failCount;
@end

@protocol AuthenticatorDelegate <NSObject>
@optional
-(void)AuthenticatorPresent;
@optional
-(void)AuthenticatorDimssed;
@optional
-(void)userSuccessAuthentication;
@optional
-(void)userFailAuthenticationWithCount:(NSInteger)failCount;
@end
