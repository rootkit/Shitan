//
//  UIButton+BGImage.m
//  Shitan
//
//  Created by 刘敏 on 14-9-14.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "UIButton+BGImage.h"

@implementation UIButton (BGImage)


// 设置按钮的背景
- (void)setBackgroundImage:(NSString *) imageN setSelectedBackgroundImage:(NSString *) selImageN
{
    // 常规状态下背景
    UIImage *image1 = [UIImage imageNamed:imageN];
    image1 = [image1 stretchableImageWithLeftCapWidth:4 topCapHeight:4];
    [self setBackgroundImage:image1 forState:UIControlStateNormal];
    
    // 选中（按下）效果背景
    UIImage *image2 = [UIImage imageNamed:selImageN];
    image2 = [image2 stretchableImageWithLeftCapWidth:4 topCapHeight:4];
    [self setBackgroundImage:image2 forState:UIControlStateSelected];
    [self setBackgroundImage:image2 forState:UIControlStateHighlighted];
}


- (void)setBackgroundImage:(NSString *) imageN setDisabledBackgroundImage:(NSString *) selImageN
{
    // 常规状态下背景
    UIImage *image1 = [UIImage imageNamed:imageN];
    image1 = [image1 stretchableImageWithLeftCapWidth:4 topCapHeight:4];
    [self setBackgroundImage:image1 forState:UIControlStateNormal];
    
    // 禁用效果背景
    UIImage *image2 = [UIImage imageNamed:selImageN];
    image2 = [image2 stretchableImageWithLeftCapWidth:4 topCapHeight:4];
    [self setBackgroundImage:image2 forState:UIControlStateDisabled];
}



// 设置按钮的背景
- (void)setImage:(NSString *) imageN setSelectedImage:(NSString *) selImageN
{
    // 常规状态下背景
    UIImage *image1 = [UIImage imageNamed:imageN];
    image1 = [image1 stretchableImageWithLeftCapWidth:4 topCapHeight:4];
    [self setImage:image1 forState:UIControlStateNormal];
    
    // 选中（按下）效果背景
    UIImage *image2 = [UIImage imageNamed:selImageN];
    image2 = [image2 stretchableImageWithLeftCapWidth:4 topCapHeight:4];
    [self setImage:image2 forState:UIControlStateSelected];
//    [self setImage:image2 forState:UIControlStateHighlighted];
}


@end
