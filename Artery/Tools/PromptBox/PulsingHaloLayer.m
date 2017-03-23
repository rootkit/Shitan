//
//  PulsingHaloLayer.m
//  Shitan
//
//  Created by 刘敏 on 14-10-18.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "PulsingHaloLayer.h"


@interface PulsingHaloLayer ()
@property (nonatomic, strong) CAAnimationGroup *animationGroup;
@end


@implementation PulsingHaloLayer

- (id)init {
    self = [super init];
    if (self) {
        
        self.contentsScale = [UIScreen mainScreen].scale;
        //透明
        self.opacity = 0.0;
        
        // 半径
        self.radius = 14;
        // 振幅
        self.animationDuration = 1.5;
        // 脉冲间隔
        self.pulseInterval = 0;
        
        self.backgroundColor = [[UIColor colorWithRed:0.000 green:0.0 blue:0.000 alpha:1.0] CGColor];

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
            
            [self setupAnimationGroup];

            if(self.pulseInterval != INFINITY) {
                
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    
                    [self addAnimation:self.animationGroup forKey:@"pulse"];
                });
            }
        });
    }
    return self;
}

- (void)setRadius:(CGFloat)radius {

    _radius = radius;
    
    CGPoint tempPos = self.position;

    CGFloat diameter = self.radius * 2;

    self.bounds = CGRectMake(0, 0, diameter, diameter);
    self.cornerRadius = self.radius;
    self.position = tempPos;
}

- (void)setupAnimationGroup {
    
    CAMediaTimingFunction *defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    
    self.animationGroup = [CAAnimationGroup animation];
    self.animationGroup.duration = self.animationDuration + self.pulseInterval;
    self.animationGroup.repeatCount = INFINITY;
    self.animationGroup.removedOnCompletion = NO;
    self.animationGroup.timingFunction = defaultCurve;
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
    scaleAnimation.fromValue = @0.0;
    scaleAnimation.toValue = @1.0;
    scaleAnimation.duration = self.animationDuration;
    
    CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.duration = self.animationDuration;
    opacityAnimation.values = @[@0.5, @0.9, @0.0];
    opacityAnimation.keyTimes = @[@0, @0.2, @1];
    opacityAnimation.removedOnCompletion = NO;
    
    NSArray *animations = @[scaleAnimation, opacityAnimation];
    
    self.animationGroup.animations = animations;
}

@end
