//
//  UIDevice+Resolutions.m
//  BabyQQ
//
//  Created by 刘 敏 on 13-10-5.
//  Copyright (c) 2013年 刘 敏. All rights reserved.
//

#import "UIDevice+Resolutions.h"

@implementation UIDevice (Resolutions)

/******************************************************************************
 函数名称 : + (UIDeviceResolution) currentResolution
 函数描述 : 获取当前分辨率
 
 输入参数 : N/A
 输出参数 : N/A
 返回参数 : N/A
 备注信息 :
 ******************************************************************************/
+ (UIDeviceResolution) currentResolution {
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        if ([[UIScreen mainScreen] respondsToSelector: @selector(scale)]) {
            CGSize result = [[UIScreen mainScreen] bounds].size;
            result = CGSizeMake(result.width * [UIScreen mainScreen].scale, result.height * [UIScreen mainScreen].scale);
            if (result.height <= 480.0f)
                return UIDevice_iPhoneStandardRes;
            return (result.height > 960 ? UIDevice_iPhone5TallerHiRes : UIDevice_iPhoneHiRes);
        } else
            return UIDevice_iPhoneStandardRes;
    } else
        return (([[UIScreen mainScreen] respondsToSelector: @selector(scale)]) ? UIDevice_iPadHiRes : UIDevice_iPadStandardRes);
}



/******************************************************************************
 函数名称 : + (UIDeviceResolution) currentResolution
 函数描述 : 当前是否运行在iPhone4端
 输入参数 : N/A
 输出参数 : N/A
 返回参数 : N/A
 备注信息 : 包括iPhone4系列、iPod4系列
 ******************************************************************************/
+ (BOOL)isRunningOniPhone4
{
    if ([self currentResolution] == UIDevice_iPhoneHiRes) {
        return YES;
    }
    return NO;
}


/******************************************************************************
 函数名称 : + (UIDeviceResolution) currentResolution
 函数描述 : 当前是否运行在iPhone5端
 输入参数 : N/A
 输出参数 : N/A
 返回参数 : N/A
 备注信息 : 包括iPhone5系列、iPhone6系列
 ******************************************************************************/
+ (BOOL)isRunningOniPhone5{
    if ([self currentResolution] == UIDevice_iPhone5TallerHiRes) {
        return YES;
    }
    return NO;
}

/******************************************************************************
 函数名称 : + (BOOL)isRunningOniPhone
 函数描述 : 当前是否运行在iPhone端
 输入参数 : N/A
 输出参数 : N/A
 返回参数 : N/A
 备注信息 :
 ******************************************************************************/
+ (BOOL)isRunningOniPhone{
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone);
}


@end
