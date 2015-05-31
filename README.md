# SmileTouchID
A Library for integrate Touch ID &amp; passcode conveniently

#What can it do for you?


##### 1. Handle all complicated things about Touch ID & Input Passcode, you just need to write a few simple code to integrate Touch ID & Input Passcode for your app.

```
if ([SmileAuthenticator hasPassword]) {
        [SmileAuthenticator sharedInstance].securityType = INPUT_TOUCHID;
        [[SmileAuthenticator sharedInstance] presentAuthViewController];
    }
```

##### 2. Get elegant animation automatically.


![](https://raw.githubusercontent.com/liu044100/SmileTouchID/master/demo_gif/demo1.gif)
![](https://raw.githubusercontent.com/liu044100/SmileTouchID/master/demo_gif/demo2.gif)


##### 3. Use storyboard customize the color to fit your app.

![](https://raw.githubusercontent.com/liu044100/SmileTouchID/master/demo_gif/demo44.png)


##### 4. Can change to 4 digit, 7 digit passcode or any digit, and automatically configure for you.
![](https://raw.githubusercontent.com/liu044100/SmileTouchID/master/demo_gif/demo66.png)


#How to use it?
