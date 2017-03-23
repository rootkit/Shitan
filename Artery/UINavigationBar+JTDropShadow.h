//
//  UINavigationBar+JTDropShadow.h
//  YiChang
//
//  Created by 敏 刘 on 13-11-15.
//  Copyright (c) 2013年 刘 敏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface UINavigationBar (JTDropShadow)

- (void)dropShadowWithOffset:(CGSize)offset
                      radius:(CGFloat)radius
                       color:(UIColor *)color
                     opacity:(CGFloat)opacity;


@end
