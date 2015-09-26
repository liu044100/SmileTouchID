//
//  SmilePasswordView.m
//  TouchID
//
//  Created by yuchen liu on 5/27/15.
//  Copyright (c) 2015 rain. All rights reserved.
//

#import "SmilePasswordView.h"

#define SmileTouchID_DispatchMainThread(block, ...) if(block) dispatch_async(dispatch_get_main_queue(), ^{ block(__VA_ARGS__); })

static CGFloat kLineWidthConst = 12.0;
static CGFloat kDotRadiusConst = 5.0;
static CGFloat kMAX_RadiusConst = 32.0;

@interface SmilePasswordView()

@property (nonatomic) NSInteger count;
@property (nonatomic) CGFloat radius;
@property (nonatomic) CGFloat spacing;

@end

@implementation SmilePasswordView{
    BOOL _direction;
    NSInteger _shakeCount;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if (!self.posiArray) {
        self.posiArray = [NSMutableArray new];
    } else {
        [self.posiArray removeAllObjects];
    }
    
    CGFloat centerX = CGRectGetMidX(self.bounds);
    CGFloat centerY = CGRectGetMidY(self.bounds);
    
    [self.circleColor setFill];
//    CGContextFillRect(UIGraphicsGetCurrentContext(), rect);
    [self.circleColor setStroke];
    
    CGFloat lineWidth = self.radius/kLineWidthConst;
    CGFloat outLineRadius = self.radius - lineWidth;
    
    BOOL isOdd = self.count%2;
    
    if (isOdd) {
        //3
        int middle = (int)(self.count + 1)/2;
        
        
        for (int i = 1; i <= self.count; i++) {
            int ii = middle - i;
            
            CGFloat theXPosi = centerX - (self.radius * 2 + self.spacing) * ii;
            
            NSNumber *theNumber = [NSNumber numberWithFloat:theXPosi];
            
            [self.posiArray addObject:theNumber];
        }
        
    } else {
        //4
        int middle = (int)(self.count)/2;
        
        
        for (int i = 1; i <= self.count; i++) {
            int ii = middle - i;
            
            CGFloat theXPosi = centerX - (self.radius * 2 + self.spacing) * ii - self.radius - self.spacing/2;
            
            NSNumber *theNumber = [NSNumber numberWithFloat:theXPosi];
            
            [self.posiArray addObject:theNumber];
        }
    }
    
    for (int i = 0; i < self.posiArray.count;  i++) {
        NSNumber *xNumber = self.posiArray[i];
        
        CGPoint thePosi = CGPointMake(xNumber.floatValue, centerY);
        
        UIBezierPath *thePath = [self pathWithCenter:thePosi radius:outLineRadius lineWidth:lineWidth];
        [thePath stroke];
        
        CGFloat dotRadius = self.radius/kDotRadiusConst;
        
        if (i + 1 <= self.dotCount) {
            UIBezierPath *dotPath = [UIBezierPath bezierPathWithArcCenter:thePosi radius:dotRadius startAngle:0 endAngle:2 * M_PI clockwise:false];
            [dotPath fill];
        } else {
            
        }
        
    }
}

-(UIBezierPath*)pathWithCenter:(CGPoint)center radius:(CGFloat)radius lineWidth:(CGFloat)lineWidth{
    UIBezierPath *outLinePath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:0 endAngle:2 * M_PI clockwise:false];
    outLinePath.lineWidth = lineWidth;
    
    return outLinePath;
}

-(instancetype)initWithCircleColor:(UIColor*)circleColor circleCount:(NSInteger)count frame:(CGRect)frame{
    
    self = [[SmilePasswordView alloc] initWithFrame:frame];
    
    self.backgroundColor = [UIColor clearColor];
    self.circleColor = circleColor;
    self.count = count;
    self.radius = [self getCircleRadius];
    
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        
    }
    
    return self;
}

#pragma mark - setter
-(void)setDotCount:(NSInteger)dotCount{
    _dotCount = dotCount;
    
    [self setNeedsDisplay];
}

#pragma mark - getter

-(CGFloat)spacing{
    
    return self.radius/(self.count/2);
}

#pragma mark - set up

-(CGFloat)getCircleRadius{
    CGFloat myRadius;
    
    CGFloat height = CGRectGetHeight(self.bounds);
    CGFloat width = CGRectGetWidth(self.bounds);

    if (self.count * height + (self.count - 1) * height/4 > width) {
        myRadius = floor((width/(2*self.count + (self.count - 1)/2)));
    } else {
        myRadius = floor(height/2);
    }
    
    if (myRadius > kMAX_RadiusConst) {
        myRadius = kMAX_RadiusConst;
    }
    
    return myRadius;
}


#pragma mark - animation

-(void)shakeAnimationWithCompletion:(dispatch_block_t)completion{
    
    NSInteger maxShakeCount = 5;
    
    CGFloat centerX = CGRectGetMidX(self.bounds);
    CGFloat centerY = CGRectGetMidY(self.bounds);
    
    NSTimeInterval duration = 0.15;
    NSInteger moveX = 3;
    
    if (_shakeCount == 0 || _shakeCount == maxShakeCount) {
        duration = duration/2;
        moveX = moveX;
    } else {
        duration = duration;
        moveX = 2 * moveX;
    }
    
    [UIView animateWithDuration:duration delay:0.0 usingSpringWithDamping:0.01 initialSpringVelocity:0.35 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        if (!_direction) {
            self.center = CGPointMake(centerX + moveX, centerY);
        } else {
            self.center = CGPointMake(centerX - moveX, centerY);
        }
    } completion:^(BOOL finished) {
        
        if (_shakeCount >= maxShakeCount) {
            [UIView animateWithDuration:duration delay:0.0 usingSpringWithDamping:0.01 initialSpringVelocity:0.35  options:UIViewAnimationOptionCurveEaseInOut animations:^{
                CGFloat realCenterX = CGRectGetMidX(self.superview.bounds);
                self.center = CGPointMake(realCenterX, centerY);
            } completion:^(BOOL finished) {
                _direction = 0;
                _shakeCount = 0;
                
                SmileTouchID_DispatchMainThread(^(){
                    completion();
                });
            }];
            return;
        }
        
        _shakeCount++;
        
        if (!_direction) {
            _direction = 1;
        } else {
            _direction = 0;
        }
        
        [self shakeAnimationWithCompletion:completion];
        
    }];
}

-(void)slideToLeftAnimationWithCompletion:(dispatch_block_t)completion{
    
    CGFloat centerX = CGRectGetMidX(self.bounds);
    CGFloat centerY = CGRectGetMidY(self.bounds);
    
    [UIView animateWithDuration:0.4 delay:0.0 usingSpringWithDamping:0.9 initialSpringVelocity:5.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        if (!_direction) {
            self.center = CGPointMake(-centerX, centerY);
        } else {
            self.center = CGPointMake(centerX, centerY);
        }
    } completion:^(BOOL finished) {
        if (!_direction) {
            _direction = 1;
            self.center = CGPointMake(3 * centerX, centerY);
            [self slideToLeftAnimationWithCompletion:completion];
        } else {
            _direction = 0;
            
            SmileTouchID_DispatchMainThread(^(){
                completion();
            });
        }
    }];
}

@end
