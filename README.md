# SmileTouchID
A library for integrate Touch ID &amp; passcode conveniently

#What can it do for you?


##### 1. Handle all complicated things about Touch ID & Input Passcode. You just need to write a few simple code to integrate Touch ID & Input Passcode for your app.
For example, 
handle the device that not support Touch ID, 

handle the whole process about securing the app (the user change passcode or turn passcode off),


```
if ([SmileAuthenticator hasPassword]) {
        [SmileAuthenticator sharedInstance].securityType = INPUT_TOUCHID;
        [[SmileAuthenticator sharedInstance] presentAuthViewController];
    }
```

##### 2. Automatically handle the device that not support Touch ID.

##### 3. Get elegant animation automatically.


![](https://raw.githubusercontent.com/liu044100/SmileTouchID/master/demo_gif/demo1.gif)
![](https://raw.githubusercontent.com/liu044100/SmileTouchID/master/demo_gif/demo2.gif)


##### 4. Can use storyboard customize the color to fit your app.

![](https://raw.githubusercontent.com/liu044100/SmileTouchID/master/demo_gif/demo44.png)


##### 5. Can customize passcode digit to 4 digit, 7 digit passcode or any digit, and automatically configure for you.
![](https://raw.githubusercontent.com/liu044100/SmileTouchID/master/demo_gif/demo66.png)


#Theoretical Introduction

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
