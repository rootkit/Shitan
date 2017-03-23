//
//  UIImageView+JTDropShadow.h
//  Shitan
//
//  Created by 刘敏 on 14-10-9.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//
//  图像下方阴影

#import <UIKit/UIKit.h>

@interface UIImageView (JTDropShadow)

- (void)dropShadowWithOffset:(CGSize)offset
                      radius:(CGFloat)radius
                       color:(UIColor *)color
                     opacity:(CGFloat)opacity;



@end



@interface UIView (JTDropShadow)

- (void)dropShadowWithOffset:(CGSize)offset
                      radius:(CGFloat)radius
                       color:(UIColor *)color
                     opacity:(CGFloat)opacity;


@end
