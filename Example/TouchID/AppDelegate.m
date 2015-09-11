//
//  AppDelegate.m
//  TouchID
//
//  Created by ryu-ushin on 5/25/15.
//  Copyright (c) 2015 rain. All rights reserved.
//

#import "AppDelegate.h"
#import "SmileAuthenticator.h"

@interface AppDelegate ()

@end

@implementation AppDelegate{
    UIImageView *_coverImageView;
    BOOL _isFirstLaunch;
}

#define kBG_Image @"backgroundImage"

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //add observer UIWindowDidBecomeKeyNotification for the first launch add the cover image for protecting the user's data.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(windowDidBecomeVisible:)
                                                 name:UIWindowDidBecomeKeyNotification
                                               object:nil];
    
    [SmileAuthenticator sharedInstance].rootVC = self.window.rootViewController;
    
    //customize
    [SmileAuthenticator sharedInstance].passcodeDigit = 4;
    [SmileAuthenticator sharedInstance].tintColor = [UIColor purpleColor];
    [SmileAuthenticator sharedInstance].touchIDIconName = @"my_Touch_ID";
    [SmileAuthenticator sharedInstance].appLogoName = @"my_Logo";
    [SmileAuthenticator sharedInstance].navibarTranslucent = YES;
    [SmileAuthenticator sharedInstance].backgroundImage = [UIImage imageNamed:kBG_Image];
    
    return YES;
}

-(void)windowDidBecomeVisible:(NSNotification*)notif{
    if (_isFirstLaunch) {
        return;
    }
    if ([SmileAuthenticator hasPassword]) {
        //iOS automatically snapshot screen, so if has password, use the _coverImageView cover the UIWindow for protecting user data.
        [self addCoverImageView];
        _isFirstLaunch = YES;
    }
}

-(void)addCoverImageView{
    _coverImageView = [[UIImageView alloc]initWithFrame:[self.window bounds]];
    _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    UIImage *image = [UIImage imageNamed:kBG_Image];
    [_coverImageView setImage:image];
    _coverImageView.alpha = 1.0;
    [self.window addSubview:_coverImageView];
}

-(void)showCoverImageView{
    if (!_coverImageView) {
        [self addCoverImageView];
    }
    [UIView animateWithDuration:0.2 animations:^{
        _coverImageView.alpha = 1.0;
    }];
}

-(void)hideCoverImageView{
    if (_coverImageView) {
        [UIView animateWithDuration:0.2 animations:^{
            _coverImageView.alpha = 0.0;
        } completion:^(BOOL finished) {
            [_coverImageView removeFromSuperview];
            _coverImageView = nil;
        }];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    if ([SmileAuthenticator hasPassword] && [SmileAuthenticator sharedInstance].isShowingAuthVC == NO) {
        [self showCoverImageView];
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    if ([SmileAuthenticator hasPassword]) {
        [self performSelector:@selector(hideCoverImageView) withObject:nil afterDelay:0.2];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)SMILE_testHelperMethod{
    BOOL isCustomize = YES;
    
    if (isCustomize) {
        
        BOOL nightMode = NO;
        
        if (!nightMode) {
            //customize
            [SmileAuthenticator sharedInstance].passcodeDigit = 6;
            [SmileAuthenticator sharedInstance].tintColor = [UIColor purpleColor];
            [SmileAuthenticator sharedInstance].touchIDIconName = @"my_Touch_ID";
            [SmileAuthenticator sharedInstance].appLogoName = @"my_Logo";
            [SmileAuthenticator sharedInstance].navibarTranslucent = YES;
            [SmileAuthenticator sharedInstance].backgroundImage = [UIImage imageNamed:@"backgroundImage"];
        } else {
            [SmileAuthenticator sharedInstance].passcodeDigit = 6;
            [SmileAuthenticator sharedInstance].tintColor = [UIColor purpleColor];
            [SmileAuthenticator sharedInstance].touchIDIconName = @"my_Touch_ID";
            [SmileAuthenticator sharedInstance].appLogoName = @"my_Logo";
            [SmileAuthenticator sharedInstance].navibarTranslucent = NO;
            [SmileAuthenticator sharedInstance].nightMode = YES;
            [SmileAuthenticator sharedInstance].backgroundImage = [UIImage imageNamed:@"nightMode_BG"];
        }
    }
}

@end
