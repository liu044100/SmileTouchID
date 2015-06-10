//
//  SmilePasswordContainerView.m
//  TouchID
//
//  Created by yuchen liu on 5/27/15.
//  Copyright (c) 2015 rain. All rights reserved.
//

#import "SmilePasswordContainerView.h"
#import "SmileAuthenticator.h"

@interface SmilePasswordContainerView()

@end

@implementation SmilePasswordContainerView {
    BOOL _flag;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)configureAndAddSmilePasswordView{
    
    if (self.smilePasswordView) {
        [self.smilePasswordView removeFromSuperview];
        self.smilePasswordView = nil;
    }
    
    self.backgroundColor = [UIColor clearColor];
    
    NSInteger count = kPasswordLength;
    
    self.smilePasswordView = [[SmilePasswordView alloc] initWithCircleColor:self.mainColor circleCount:count frame:self.bounds];
    
    [self addSubview:self.smilePasswordView];
}

#if TARGET_INTERFACE_BUILDER

-(void)willMoveToSuperview:(UIView *)newSuperview{
    [self configureAndAddSmilePasswordView];
}

#else
-(void)awakeFromNib{
    [super awakeFromNib];
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
     [self configureAndAddSmilePasswordView];
}

#endif

@end
