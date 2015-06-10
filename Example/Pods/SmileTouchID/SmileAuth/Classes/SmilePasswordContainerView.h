//
//  SmilePasswordContainerView.h
//  TouchID
//
//  Created by yuchen liu on 5/27/15.
//  Copyright (c) 2015 rain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SmilePasswordView.h"


@protocol SmileContainerLayoutDelegate;

//IB_DESIGNABLE

@interface SmilePasswordContainerView : UIView
//IBInspectable
@property (nonatomic, strong) UIColor *mainColor;
@property (nonatomic, strong) SmilePasswordView *smilePasswordView;
@property (nonatomic, weak) id <SmileContainerLayoutDelegate> delegate;

@end

@protocol SmileContainerLayoutDelegate <NSObject>
@required
-(void)smileContainerLayoutSubview;
@end
