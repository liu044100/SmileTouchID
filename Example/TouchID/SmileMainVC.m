//
//  MainVC.m
//  TouchID
//
//  Created by ryu-ushin on 5/25/15.
//  Copyright (c) 2015 rain. All rights reserved.
//

#import "SmileMainVC.h"
#import "SmileAuthenticator.h"

@interface SmileMainVC () <SmileAuthenticatorDelegate>
@property (weak, nonatomic) IBOutlet UISwitch *mySwitch;
@property (weak, nonatomic) IBOutlet UIButton *changePasswordButton;

@end

@implementation SmileMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [SmileAuthenticator sharedInstance].delegate = self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([SmileAuthenticator hasPassword]) {
        self.mySwitch.on = YES;
        self.changePasswordButton.hidden = NO;
    } else {
        self.mySwitch.on = NO;
        self.changePasswordButton.hidden = YES;
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if ([SmileAuthenticator hasPassword]) {
        [SmileAuthenticator sharedInstance].securityType = INPUT_TOUCHID;
        [[SmileAuthenticator sharedInstance] presentAuthViewControllerAnimated:NO];
    }
}

- (IBAction)changePassword:(id)sender {
    [SmileAuthenticator sharedInstance].securityType = INPUT_THREE;
    [[SmileAuthenticator sharedInstance] presentAuthViewControllerAnimated:TRUE];
}

- (IBAction)passwordSwitch:(UISwitch*)passwordSwitch {
    if (passwordSwitch.on) {
        [SmileAuthenticator sharedInstance].securityType = INPUT_TWICE;
    } else {
        [SmileAuthenticator sharedInstance].securityType = INPUT_ONCE;
    }
    
    [[SmileAuthenticator sharedInstance] presentAuthViewControllerAnimated:TRUE];
}

#pragma mark - AuthenticatorDelegate

-(void)userFailAuthenticationWithCount:(NSInteger)failCount{
    NSLog(@"userFailAuthenticationWithCount: %ld", (long)failCount);
}

-(void)userSuccessAuthentication{
    NSLog(@"userSuccessAuthentication");
}

-(void)userTurnPasswordOn{
    NSLog(@"userTurnPasswordOn");
}

-(void)userTurnPasswordOff{
    NSLog(@"userTurnPasswordOff");
}

-(void)userChangePassword{
    NSLog(@"userChangePassword");
}

-(void)AuthViewControllerPresented{
    NSLog(@"presentAuthViewController");
}

-(void)AuthViewControllerDismissed:(UIViewController*)previousPresentedVC{
    NSLog(@"dismissAuthViewController, previousPresentedVC: %@", previousPresentedVC);
    if (previousPresentedVC) {
        [self presentViewController:previousPresentedVC animated:YES completion:nil];
    }
}

@end
