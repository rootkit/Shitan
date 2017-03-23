//
//  PulsingHaloLayer.h
//  Shitan
//  脉冲动画层
//
//  Created by 刘敏 on 14-10-18.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>


@interface PulsingHaloLayer : CALayer

@property (nonatomic, assign) CGFloat radius;                   // default:60pt
@property (nonatomic, assign) NSTimeInterval animationDuration; // default:3s
@property (nonatomic, assign) NSTimeInterval pulseInterval;     // default is 0s

@end
