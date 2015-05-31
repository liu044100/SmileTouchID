# SmileTouchID
A library for integrate Touch ID &amp; Passcode to iOS App conveniently.

![](https://raw.githubusercontent.com/liu044100/SmileTouchID/master/demo_gif/promo.png)

#What can it do for you?


##### 1. Handle all complicated things about Touch ID & Passcode. You just need to write a few simple code to integrate Touch ID & Passcode to your app.
For example, 
handle the device that not support Touch ID, 

handle the whole process about securing the app (the user change passcode or turn passcode off),


```
if ([SmileAuthenticator hasPassword]) {
        [SmileAuthenticator sharedInstance].securityType = INPUT_TOUCHID;
        [[SmileAuthenticator sharedInstance] presentAuthViewController];
    }
```



##### 2. Get elegant animation automatically and adaptive UI.


![](https://raw.githubusercontent.com/liu044100/SmileTouchID/master/demo_gif/demo1.gif)
![](https://raw.githubusercontent.com/liu044100/SmileTouchID/master/demo_gif/demo2.gif)
![](https://raw.githubusercontent.com/liu044100/SmileTouchID/master/demo_gif/rotate.gif)



##### 3. Can use storyboard customize the color to fit your app.


![](https://raw.githubusercontent.com/liu044100/SmileTouchID/master/demo_gif/demo44.png)




##### 4. Can customize passcode digit to 4 digit, 7 digit passcode or any digit, and automatically configure for you.



![](https://raw.githubusercontent.com/liu044100/SmileTouchID/master/demo_gif/demo66.png)


#Theoretical Introduction

The main class is the `SmileAuthenticator`. It has a property `SecurityType` that has four types： `INPUT_ONCE`, `INPUT_TWICE`, `INPUT_THREE`, `INPUT_TOUCHID`. The reason for this name is that show the user input times.


**`INPUT_ONCE`:** For the user turn the passcode switch off, user need input their passcode only one time for turn the password off.


**`INPUT_TWICE`:** For the user turn the password switch on, user need input their password once and re-enter their password one more time for confirm it to match each other.


**`INPUT_THREE`:** For the user change the password, user need input their old passcode one time, then input their new passcode one time and re-enter one time for confirm, a total of three times.


**`INPUT_TOUCHID`:** For the user open the app, user can use touch ID or input passcode to unlock.


Use `[[SmileAuthenticator sharedInstance] presentAuthViewController]` to present view for authentication.


#How to use it for your project?

**Step 1.** Drop the fold `SmileAuth` to your project.

![](https://raw.githubusercontent.com/liu044100/SmileTouchID/master/demo_gif/step1.png)

**Step 2.** Import `SmileAuthenticator.h` to your `AppDelegate.m`, and add below line to `didFinishLaunchingWithOptions`.

```
[SmileAuthenticator sharedInstance].rootVC = self.window.rootViewController;
```

![](https://raw.githubusercontent.com/liu044100/SmileTouchID/master/demo_gif/step2.png)

**Step 3.** In your project root view controller,  add below line to `viewDidAppear:`.

```
if ([SmileAuthenticator hasPassword]) {
        [SmileAuthenticator sharedInstance].securityType = INPUT_TOUCHID;
        [[SmileAuthenticator sharedInstance] presentAuthViewController];
    }
```


![](https://raw.githubusercontent.com/liu044100/SmileTouchID/master/demo_gif/step3.png)

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

![](https://raw.githubusercontent.com/liu044100/SmileTouchID/master/demo_gif/step4.png)


**Step 5.** Build your project, very simple :)

#About Customization & Delegate callback

Open `SmileSettingVC.storyboard` customize the color.

Open `SmileAuthenticator.h` , change `kPasswordLength` to customize passcode digit.

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

# Contact

* If you have some advice or find some issue, please contact me.
* Email [me](liu044100@gmail.com)

# Thanks
Thanks for raywenderlich's tutorial about [securing iOS User Data](http://www.raywenderlich.com/92667/securing-ios-data-keychain-touch-id-1password), I am inspired by this tutorial.

# License

SmileTouchID is available under the MIT license. See the LICENSE file for more info.
