//
//  UIColor+Extension.h
//  NationalOA
//
//  Created by 刘敏 on 14-9-20.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//


@interface UIColor (Extension)

+ (UIColor*) colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue;
+ (UIColor*) colorWithHex:(NSInteger)hexValue;
+ (NSString *) hexFromUIColor: (UIColor*) color;
+ (UIColor *)getColor:(NSString *)hexColor;

@end
