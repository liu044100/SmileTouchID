//
//  SmileAuthenticator.m
//  TouchID
//
//  Created by ryu-ushin on 5/25/15.
//  Copyright (c) 2015 rain. All rights reserved.
//

#import "SmileAuthenticator.h"

#define kPasswordLength 4
#define kTouchIDIcon @"smile_Touch_ID"

static NSString *kStoryBoardName = @"SmileSettingVC";

#define SmileTouchID_DispatchMainThread(block, ...) if(block) dispatch_async(dispatch_get_main_queue(), ^{ block(__VA_ARGS__); })

@interface SmileAuthenticator()

@property (nonatomic, assign) LAPolicy policy;
@property (nonatomic, strong) LAContext * context;
@property (nonatomic, readwrite) BOOL isShowingAuthVC;
@property (nonatomic, readwrite) BOOL isAuthenticated;

@end


@implementation SmileAuthenticator{
    BOOL _didReturnFromBackground;
}

#pragma mark -getter

-(void)setPasscodeDigit:(NSInteger)passcodeDigit{
    NSInteger buffer = [self lengthOfPassword];
    if (buffer > 0) {
        _passcodeDigit = buffer;
    } else if (!passcodeDigit || passcodeDigit < 0) {
        _passcodeDigit = kPasswordLength;
    } else if (_passcodeDigit != passcodeDigit) {
        _passcodeDigit = passcodeDigit;
    }
}

-(NSString *)touchIDIconName{
    if (!_touchIDIconName.length) {
        return kTouchIDIcon;
    } else {
        return _touchIDIconName;
    }
}

#pragma mark - dealloc

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - for Delegate

-(void)touchID_OR_PasswordAuthSuccess{
    if ([self.delegate respondsToSelector:@selector(userSuccessAuthentication)]) {
        [self.delegate userSuccessAuthentication];
    }
}

-(void)touchID_OR_PasswordAuthFail:(NSInteger)failCount{
    if ([self.delegate respondsToSelector:@selector(userFailAuthenticationWithCount:)]) {
        [self.delegate userFailAuthenticationWithCount:failCount];
    }
}

-(void)touchID_OR_PasswordTurnOff{
    if ([self.delegate respondsToSelector:@selector(userTurnPasswordOff)]) {
        [self.delegate userTurnPasswordOff];
    }
}

-(void)touchID_OR_PasswordTurnOn{
    if ([self.delegate respondsToSelector:@selector(userTurnPasswordOn)]) {
        [self.delegate userTurnPasswordOn];
    }
}

-(void)touchID_OR_PasswordChange{
    if ([self.delegate respondsToSelector:@selector(userChangePassword)]) {
        [self.delegate userChangePassword];
    }
}

-(void)presentAuthViewControllerAnimated:(BOOL)animated{
    
    if (self.securityType != INPUT_TOUCHID) {
        _isAuthenticated = NO;
    }
    
    if (!_isAuthenticated) {
        
        //dimiss all presentedViewController, for example, if user is editing password
        if (self.rootVC.presentedViewController) {
            [self.rootVC.presentedViewController dismissViewControllerAnimated:NO completion:nil];
        }
        
        if ([self.delegate respondsToSelector:@selector(AuthViewControllerPresented)]) {
            [self.delegate AuthViewControllerPresented];
        }
        
        self.isShowingAuthVC = YES;
        
        NSBundle *bundle = [NSBundle bundleForClass: self.class];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:kStoryBoardName bundle: bundle];
        
        UINavigationController *naviVC = [storyboard instantiateInitialViewController];
        
        [self.rootVC presentViewController:naviVC animated:animated completion:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:SmileTouchID_Presented_AuthVC_Notification object:nil];
        }];
    }
}

-(void)authViewControllerDismissed{
    if ([self.delegate respondsToSelector:@selector(AuthViewControllerDismssed)]) {
        [self.delegate AuthViewControllerDismssed];
    }
    _isAuthenticated = true;
    self.isShowingAuthVC = NO;
}

#pragma mark - NSNotificationCenter

-(void)configureNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
}

-(void)appDidEnterBackground:(NSNotification*)notification{
    if (_isAuthenticated) {
        _didReturnFromBackground = YES;
        _isAuthenticated = NO;
    }
}

-(void)appWillEnterForeground:(NSNotification*)notification{  
    if (_didReturnFromBackground && !self.isShowingAuthVC) {
        if ([SmileAuthenticator hasPassword]) {
            //show login vc
            self.securityType = INPUT_TOUCHID;
            [self presentAuthViewControllerAnimated:false];
        }
    }
}

#pragma mark - init

+(SmileAuthenticator *)sharedInstance{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}


-(instancetype)init{
    if (self = [super init]) {
        self.context = [[LAContext alloc] init];
        self.policy = LAPolicyDeviceOwnerAuthenticationWithBiometrics;
        self.localizedReason = NSLocalizedString(@"SMILE_REASON", nil);
        self.keychainWrapper = [[SmileKeychainWrapper alloc] init];
        self.securityType = INPUT_TWICE;
        self.parallaxMode = YES;
        self.passcodeDigit = kPasswordLength;
        
        [self configureNotification];
    }
    return self;
}

#pragma mark - TouchID

+ (BOOL) canAuthenticateWithError:(NSError **) error
{
    if ([NSClassFromString(@"LAContext") class]) {
        if ([[SmileAuthenticator sharedInstance].context canEvaluatePolicy:[SmileAuthenticator sharedInstance].policy error:error]) {
            return YES;
        }
        return NO;
    }
    return NO;
}

-(void)authenticateWithSuccess:(AuthCompletionBlock)authSuccessBlock andFailure:(AuthErrorBlock)failureBlock{
    
    NSError *authError = nil;
    
    self.context = [[LAContext alloc] init];
    
    if ([SmileAuthenticator canAuthenticateWithError:&authError]) {
        [self.context evaluatePolicy:self.policy localizedReason:self.localizedReason reply:^(BOOL success, NSError *error) {
            if (success) {
                SmileTouchID_DispatchMainThread(^(){
                    authSuccessBlock();
                });
            }
            
            else {
                switch (error.code) {
                    case LAErrorAuthenticationFailed:
                        
                        NSLog(@"LAErrorAuthenticationFailed");
                        
                        break;
                        
                    case LAErrorUserCancel:
                        
                        NSLog(@"LAErrorUserCancel");
                        
                        break;
                        
                    case LAErrorUserFallback:
                        
                        NSLog(@"LAErrorUserFallback");
                        
                        break;
                        
                    case LAErrorSystemCancel:
                        
                        NSLog(@"LAErrorSystemCancel");
                        
                        break;
                        
                    case LAErrorPasscodeNotSet:
                        
                        NSLog(@"LAErrorPasscodeNotSet");
                        
                        break;
                        
                    case LAErrorTouchIDNotAvailable:
                        
                        NSLog(@"LAErrorTouchIDNotAvailable");
                        
                        break;
                        
                    case LAErrorTouchIDNotEnrolled:
                        
                        NSLog(@"LAErrorTouchIDNotEnrolled");
                        
                        break;
                        
                    default:
                        break;
                }
                
                SmileTouchID_DispatchMainThread(^(){
                    failureBlock((LAError) error.code);
                });
            }
        }];
    }
    
    else {
        failureBlock((LAError) authError.code);
    }
}

#pragma mark - Utility

+(BOOL)hasPassword {
    
    if ([(NSString*)[[SmileAuthenticator sharedInstance].keychainWrapper myObjectForKey:(__bridge id)(kSecValueData)] length] > 0) {
        return YES;
    }
    
    return NO;
}

-(NSInteger)lengthOfPassword{
    return [[self.keychainWrapper myObjectForKey:(__bridge id)(kSecValueData)] length];
}

+(BOOL)isSamePassword:(NSString *)userInput{
    //use this line to log password, if you forgot it.
    //NSLog(@"the password -> %@", [[SmileAuthenticator sharedInstance].keychainWrapper myObjectForKey:(__bridge id)(kSecValueData)]);
    if ([userInput isEqualToString:[[SmileAuthenticator sharedInstance].keychainWrapper myObjectForKey:(__bridge id)(kSecValueData)]]) {
        return YES;
    }
    
    return NO;
}

-(void)userSetPassword:(NSString*)newPassword{
    [self.keychainWrapper mySetObject:newPassword forKey:(__bridge id)(kSecValueData)];
    [self.keychainWrapper writeToKeychain];
}

+(void)clearPassword{
    [[SmileAuthenticator sharedInstance].keychainWrapper resetKeychainItem];
    [[SmileAuthenticator sharedInstance].keychainWrapper writeToKeychain];
}

-(void)changeAuthentication:(BOOL)newAuth {
    _isAuthenticated = newAuth;
}
@end
