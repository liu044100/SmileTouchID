//
//  SmilePasswordContainerView.h
//  TouchID
//
//  Created by yuchen liu on 5/27/15.
//  Copyright (c) 2015 rain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SmilePasswordView.h"

IB_DESIGNABLE

@interface SmilePasswordContainerView : UIView

@property (nonatomic, strong) IBInspectable UIColor *mainColor;
@property (nonatomic, strong) SmilePasswordView *smilePasswordView;

@end
