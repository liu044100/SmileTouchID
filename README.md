# SmileTouchID
A library for integrate Touch ID &amp; Passcode to iOS App conveniently.

![](https://raw.githubusercontent.com/liu044100/SmileTouchID/master/Example/demo_gif/promo_banner_s.png)

#What can it do for you?


##### 1. Handle all complicated things about Touch ID & Passcode. You just need to write a few simple code to integrate Touch ID & Passcode to your app.


For example, handle the device that not support Touch ID, instead of Touch ID, use Passcode for authentication.

handle the whole process about securing the app (the user change passcode or turn passcode off),


```
if ([SmileAuthenticator hasPassword]) {
        [SmileAuthenticator sharedInstance].securityType = INPUT_TOUCHID;
        [[SmileAuthenticator sharedInstance] presentAuthViewController];
    }
```



##### 2. Get elegant animation and adaptive UI automatically.


![](https://raw.githubusercontent.com/liu044100/SmileTouchID/master/Example/demo_gif/demo1.gif)
![](https://raw.githubusercontent.com/liu044100/SmileTouchID/master/Example/demo_gif/demo2.gif)
![](https://raw.githubusercontent.com/liu044100/SmileTouchID/master/Example/demo_gif/rotate.gif)



##### 3. Can customize the color，touch id icon and background image to fit your app style. For example, you can customize like the below image.

```
[SmileAuthenticator sharedInstance].tintColor = [UIColor purpleColor];
[SmileAuthenticator sharedInstance].touchIDIconName = @"my_Touch_ID";
[SmileAuthenticator sharedInstance].appLogoName = @"my_Logo";
[SmileAuthenticator sharedInstance].navibarTranslucent = YES;
[SmileAuthenticator sharedInstance].backgroundImage = [UIImage imageNamed:@"backgroundImage"];

```

![](https://raw.githubusercontent.com/liu044100/SmileTouchID/master/Example/demo_gif/customize1.png)


##### 4. Can customize the passcode digit to 6 or 10, or any number, automatically handle other things for you.

```
[SmileAuthenticator sharedInstance].passcodeDigit = 6;
```

![](https://raw.githubusercontent.com/liu044100/SmileTouchID/master/Example/demo_gif/passlength.png)


##### 5. Support iOS7 and later. 

In iOS7, because Apple had not given the TouchID API to developers, only use Passcode for authentication. 

**For the project that deployment target is iOS7, you should add `LocalAuthentication.framework` to your project and change status to `Optional`.**

![](https://raw.githubusercontent.com/liu044100/SmileTouchID/master/Example/demo_gif/ios7.png)


#Theoretical Introduction

The main class is the `SmileAuthenticator`. It has a property `SecurityType` that has four types： `INPUT_ONCE`, `INPUT_TWICE`, `INPUT_THREE`, `INPUT_TOUCHID`. The reason for this name is that show the user input times.


**`INPUT_ONCE`:** For the user turn the passcode switch off, user need input their passcode only one time for turn the password off.


**`INPUT_TWICE`:** For the user turn the password switch on, user need input their password once and re-enter their password one more time for confirm it to match each other.


**`INPUT_THREE`:** For the user change the password, user need input their old passcode one time, then input their new passcode one time and re-enter one time for confirm, a total of three times.


**`INPUT_TOUCHID`:** For the user open the app, user can use touch ID or input passcode to unlock.


Use `[[SmileAuthenticator sharedInstance] presentAuthViewController]` to present view for authentication.


#How to use it for your project?

**Step 1.** SmileTouchID is available through use Pods. To install
it, simply add the following line to your Podfile:

```
pod 'SmileTouchID', :git => 'https://github.com/liu044100/SmileTouchID.git'

```


**Step 2.** Import `SmileAuthenticator.h` to your `AppDelegate.m`, and add below line to `didFinishLaunchingWithOptions`.

```
[SmileAuthenticator sharedInstance].rootVC = self.window.rootViewController;
```

![](https://raw.githubusercontent.com/liu044100/SmileTouchID/master/Example/demo_gif/step2.png)

**Step 3.** In your project root view controller,  add below line to `viewDidAppear:`.

```
if ([SmileAuthenticator hasPassword]) {
        [SmileAuthenticator sharedInstance].securityType = INPUT_TOUCHID;
        [[SmileAuthenticator sharedInstance] presentAuthViewController];
    }
```


![](https://raw.githubusercontent.com/liu044100/SmileTouchID/master/Example/demo_gif/step3.png)

**Step 4.** Configure with your interactive UI parts,  set appropriate `securityType`, then call `presentAuthViewController`. 

For example below image show a switch to turn the passcode on/off, when the switch turn on, the `securityType` is `INPUT_TWICE`, when turn off, the `securityType` is `INPUT_ONCE`. A button for change passcode, the `securityType` is `INPUT_THREE`.

```
- (IBAction)changePassword:(id)sender {
    [SmileAuthenticator sharedInstance].securityType = INPUT_THREE;
    [[SmileAuthenticator sharedInstance] presentAuthViewController];
}

- (IBAction)passwordSwitch:(UISwitch*)passwordSwitch {
    if (passwordSwitch.on) {
        [SmileAuthenticator sharedInstance].securityType = INPUT_TWICE;
    } else {
        [SmileAuthenticator sharedInstance].securityType = INPUT_ONCE;
    }
    
    [[SmileAuthenticator sharedInstance] presentAuthViewController];
}

```

![](https://raw.githubusercontent.com/liu044100/SmileTouchID/master/Example/demo_gif/step4.png)


Update your interactive UI parts in `viewWillAppear`.

For example, below code show update the switch and button based on `[SmileAuthenticator hasPassword]`.

```
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
```


**Step 5.** Build your project, very simple :)

#About Delegate callback

`SmileAuthenticator` has a delegate that can get more information about the process of authentication.

The delegate name is `AuthenticatorDelegate`. It has four optional method.

```
@protocol AuthenticatorDelegate <NSObject>
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
@end
```
# Localization
Sorry about it, but you have to do it yourself. Add below line to your `Localizable.strings`. For detail please see the example demo app.

```
/*
 UNIVERSAL PARTS
 */
"SMILE_REASON" = "Are you device owner?";
"SMILE_INPUT_FAILED" = "%ld Failed Passcode Attempt. Try again.";
"SMILE_INPUT_DESCRIPTION" = "Enter %ld digit passcode";
"SMILE_INPUT_NOT_MATCH" = "Passcode not match. Try again.";
"SMILE_INPUT_RE-ENTER" = "Re-enter your %ld digit Passcode";

/*
 INPUT_TOUCHID
 */
"SMILE_INPUT_TOUCHID_TITLE" = "Enter Passcode";


/*
 INPUT_ONCE
 */
"SMILE_INPUT_ONCE_TITLE" = "Turn off Passcode";


/*
 INPUT_TWICE
 */
"SMILE_INPUT_TWICE_TITLE" = "Set Passcode";


/*
 INPUT_THREE
 */
"SMILE_INPUT_THREE_TITLE" = "Change Passcode";
"SMILE_INPUT_THREE_STEP_1" = "Enter your new %ld digit Passcode";
"SMILE_INPUT_THREE_STEP_2" = "Enter your old %ld digit Passcode";

```

# Contributions

* Warmly welcome to submit a pull request.

# Contact

* If you have some advice or find some issue, please contact me.
* Email [me](liu044100@gmail.com)

# Thanks
Thanks for raywenderlich's tutorial about [securing iOS User Data](http://www.raywenderlich.com/92667/securing-ios-data-keychain-touch-id-1password), I am inspired by this tutorial.

# License

SmileTouchID is available under the MIT license. See the LICENSE file for more info.
