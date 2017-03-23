//
//  UIDevice+Resolutions.h
//  BabyQQ
//
//  Created by 刘 敏 on 13-10-5.
//  Copyright (c) 2013年 刘 敏. All rights reserved.
//

#import <UIKit/UIKit.h>


enum {
    // iPhone 1,3,3GS 标准分辨率(320x480px)
    UIDevice_iPhoneStandardRes      = 1,
    
    // iPhone 4,4S 高清分辨率(640x960px)
    UIDevice_iPhoneHiRes            = 2,           //@2x
    
    // iPhone 5 高清分辨率(640x1136px)
    UIDevice_iPhone5TallerHiRes      = 3,          //568h@2x
    
    // iPhone 6 高清分辨率(750x1334px)
    UIDevice_iPhone6TallerHiRes      = 4,          //568h@2x
    
    // iPhone6 Plus 高清分辨率(1080x1920px)
    UIDevice_iPhone6PlusTallerHiRes  = 5,          //@3x
    
    // iPad 1,2 标准分辨率(1024x768px)
    UIDevice_iPadStandardRes        = 6,
    
    // iPad 3 High Resolution(2048x1536px)
    UIDevice_iPadHiRes              = 7
    
};
typedef NSUInteger UIDeviceResolution;



@interface UIDevice (Resolutions){
    
}

/******************************************************************************
 函数名称 : + (UIDeviceResolution) currentResolution
 函数描述 : 获取当前分辨率
 输入参数 : N/A
 输出参数 : N/A
 返回参数 : N/A
 备注信息 :
 ******************************************************************************/
+ (UIDeviceResolution) currentResolution;


+ (BOOL)isRunningOniPhone4;


/******************************************************************************
 函数名称 : + (UIDeviceResolution) currentResolution
 函数描述 : 当前是否运行在iPhone5端
 输入参数 : N/A
 输出参数 : N/A
 返回参数 : N/A
 备注信息 :
 ******************************************************************************/
+ (BOOL)isRunningOniPhone5;

/******************************************************************************
 函数名称 : + (BOOL)isRunningOniPhone
 函数描述 : 当前是否运行在iPhone端
 输入参数 : N/A
 输出参数 : N/A
 返回参数 : N/A
 备注信息 :
 ******************************************************************************/
+ (BOOL)isRunningOniPhone;




@end
