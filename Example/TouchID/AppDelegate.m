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
}

#define kBG_Image @"backgroundImage"

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self configureForFirstLaunchAddCoverImage];
    
    [SmileAuthenticator sharedInstance].rootVC = self.window.rootViewController;
    
    //customize
    [SmileAuthenticator sharedInstance].passcodeDigit = 4;
    [SmileAuthenticator sharedInstance].tintColor = [UIColor purpleColor];
    [SmileAuthenticator sharedInstance].touchIDIconName = @"my_Touch_ID";
    [SmileAuthenticator sharedInstance].appLogoName = @"my_Logo";
    [SmileAuthenticator sharedInstance].navibarTranslucent = YES;
    [SmileAuthenticator sharedInstance].backgroundImage = [UIImage imageNamed:kBG_Image];
    //[SmileAuthenticator sharedInstance].timeoutInterval = 10;
    
    return YES;
}

-(void)configureForFirstLaunchAddCoverImage{
    //add observer UIWindowDidBecomeKeyNotification for the first launch add the cover image for protecting the user's data.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(windowDidBecomeVisible:)
                                                 name:UIWindowDidBecomeKeyNotification
                                               object:nil];
    //add observer SmileTouchID_Presented_AuthVC_Notification for only remove cover image when the the AuthVC has been presented.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeCoverImageView) name:SmileTouchID_Presented_AuthVC_Notification object:nil];
}

-(void)windowDidBecomeVisible:(NSNotification*)notif{
    if ([SmileAuthenticator hasPassword]) {
        //iOS automatically snapshot screen, so if has password, use the _coverImageView cover the UIWindow for protecting user data.
        [self addCoverImageView];
        //remove the observer, because we just need it for the app first launch.
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIWindowDidBecomeKeyNotification object:nil];
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
    [UIView animateWithDuration:0.1 animations:^{
        _coverImageView.alpha = 1.0;
    }];
}

-(void)removeCoverImageView{
    if (_coverImageView) {
        [UIView animateWithDuration:0.1 animations:^{
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

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    if ([SmileAuthenticator hasPassword]) {
        //if now is authenticated, remove the cover image.
        if([SmileAuthenticator sharedInstance].isAuthenticated){
            [self removeCoverImageView];
        }
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
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
