//
//  SmilePasswordView.h
//  TouchID
//
//  Created by yuchen liu on 5/27/15.
//  Copyright (c) 2015 rain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SmilePasswordView : UIView

@property (nonatomic) UIColor *circleColor;

@property (nonatomic, strong) NSMutableArray *posiArray;

@property (nonatomic) NSInteger dotCount;

-(instancetype)initWithCircleColor:(UIColor*)circleColor circleCount:(NSInteger)count frame:(CGRect)frame;

-(void)shakeAnimationWithCompletion:(dispatch_block_t)completion;
-(void)slideToLeftAnimationWithCompletion:(dispatch_block_t)completion;


@end
