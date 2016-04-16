//
//  SmileAuthenticator.h
//  TouchID
//
//  Created by ryu-ushin on 5/25/15.
//  Copyright (c) 2015 rain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LocalAuthentication/LocalAuthentication.h>
#import "SmileKeychainWrapper.h"
#import "SmileSettingVC.h"

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

/*!@brief The notification is posted when the present AuthVC completion.*/
#define SmileTouchID_Presented_AuthVC_Notification @"SmileTouchID_Presented_AuthVC"

@protocol SmileAuthenticatorDelegate;

@interface SmileAuthenticator : NSObject

@property (nonatomic, copy) NSString * localizedReason;
@property (nonatomic, strong) SmileKeychainWrapper *keychainWrapper;
@property (nonatomic, assign) SecurityType securityType;
/*!@brief This property show whether the AuthVC is presenting or not.*/
@property (nonatomic, readonly) BOOL isShowingAuthVC;
/*!@brief This property show whether now is authenticated or not.*/
@property (nonatomic, readonly) BOOL isAuthenticated;
@property (nonatomic, strong) UIViewController *rootVC;
@property (nonatomic, weak) id <SmileAuthenticatorDelegate> delegate;
/*!@brief <b>For customization</b>, use this property to customize tint color. The default color is pink.*/
@property (nonatomic, strong) UIColor *tintColor;
/*!@brief <b>For customization</b>, use this property to customize description label text color. The default color is black, if nightMode on, the color is white.*/
@property (nonatomic, strong) UIColor *descriptionTextColor;
/*!@brief <b>For customization</b>, use this property to customize Touch ID icon. The default icon is the Apple official pink Touch ID icon.*/
@property (nonatomic, strong) NSString *touchIDIconName;
/*!@brief <b>For customization</b>, use this property to set the app logo to UI.*/
@property (nonatomic, strong) NSString *appLogoName;
/*!@brief <b>For customization</b>, use this property to set the backgroundImage.*/
@property (nonatomic, strong) UIImage *backgroundImage;
/*!@brief <b>For customization</b>, use this property to change passcode digit. The default digit is 4.*/
@property (nonatomic) NSInteger passcodeDigit;
/*!@brief <b>For customization</b>, if set it to Yes, change UINavigationBar to transparent, the default value is No.*/
@property (nonatomic) BOOL navibarTranslucent;
/*!@brief <b>For customization</b>, if set it to Yes, change to a black style UI, the default value is No.*/
@property (nonatomic) BOOL nightMode;
/*!@brief <b>For customization</b>, if set it to Yes, add parallax effect to password circle views, the default value is Yes.*/
@property (nonatomic) BOOL parallaxMode;

+(SmileAuthenticator*)sharedInstance;
+ (BOOL)canAuthenticateWithError:(NSError **) error;
+(BOOL)hasPassword;
+(BOOL)isSamePassword:(NSString *)userInput;
+(void)clearPassword;
/*!@brief Manually change authentication status, e.g., when your app has a payment view, you want to show authentication view when visit the payment view.*/
-(void)changeAuthentication:(BOOL)newAuth;


-(void)userSetPassword:(NSString*)newPassword;
-(void)authenticateWithSuccess:(AuthCompletionBlock) authSuccessBlock andFailure:(AuthErrorBlock) failureBlock;

-(void)presentAuthViewControllerAnimated:(BOOL)animated;
-(void)authViewControllerDismissed;
-(void)touchID_OR_PasswordAuthSuccess;
-(void)touchID_OR_PasswordAuthFail:(NSInteger)failCount;
-(void)touchID_OR_PasswordTurnOff;
-(void)touchID_OR_PasswordTurnOn;
-(void)touchID_OR_PasswordChange;
@end

@protocol SmileAuthenticatorDelegate <NSObject>
@optional
/*!The method is called when AuthViewController be presented*/
-(void)AuthViewControllerPresented;
@optional
/*!The method is called when AuthViewController be dismissed*/
-(void)AuthViewControllerDismssed;
@optional
/*!The method is called when user success authentication by using Touch ID & Passcode*/
-(void)userSuccessAuthentication;
@optional
/*!The method is called when authentication failed*/
-(void)userFailAuthenticationWithCount:(NSInteger)failCount;
@optional
/*!The method is called when user turn password on.*/
-(void)userTurnPasswordOn;
@optional
/*!The method is called when user turn password off.*/
-(void)userTurnPasswordOff;
@optional
/*!The method is called when user change password.*/
-(void)userChangePassword;
@end
