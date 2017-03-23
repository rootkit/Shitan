//
//  UIImage+Original.m
//  Shitan
//
//  Created by Avalon on 15/5/4.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "UIImage+Original.h"

@implementation UIImage (Original)

+ (UIImage *)imageWithOriginalNamed:(NSString *)imageName{
    
    UIImage *image = [UIImage imageNamed:imageName];
    // 始终绘制图片原始状态，不使用Tint Color。
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
}


@end

