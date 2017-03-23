//
//  SettingModel.m
//  Shitan
//
//  Created by 刘敏 on 15/1/18.
//  Copyright (c) 2015年 深圳食探网络科技有限公司. All rights reserved.
//

#import "SettingModel.h"

@implementation SettingModel


//运行环境
+ (BOOL)runtimeEnvironment
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *runtimeN = [defaults objectForKey:@"environment_preference"];
    
    
#ifdef DEBUG
    if ([runtimeN isEqualToString:@"production"]) {
        return YES;
    }

#else
    
    if ([runtimeN isEqualToString:@"development"]) {
        return YES;
    }
    
#endif
    
    return NO;
}


+ (NSString *)runtimeStatus
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *runtimeN = [defaults objectForKey:@"environment_preference"];
    
#ifdef DEBUG
    if ([runtimeN isEqualToString:@"production"]) {
        return @"http://shitan.me";
    }
    
    return @"http://dongmai.me";
#else
    
    if ([runtimeN isEqualToString:@"development"]) {
        
        return @"http://dongmai.me";
    }
    
    return @"http://shitan.me";
#endif
}


//是否支持手机日志
+ (BOOL)isCollectLogs
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL isLog = [[defaults objectForKey:@"log_preference"] boolValue];
    
    return isLog;

}



+ (NSString *)AliyunAccessKey
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *runtimeN = [defaults objectForKey:@"environment_preference"];
    
    
#ifdef DEBUG
    if ([runtimeN isEqualToString:@"production"]) {
        //正式
        return @"7YfUoq4WJzRwOX90";
    }
    else
        return @"WgQGmQo4RsP3ewKP";
    
#else
    
    if ([runtimeN isEqualToString:@"development"]) {
        //测试
        return @"WgQGmQo4RsP3ewKP";
    }
    else
        return @"7YfUoq4WJzRwOX90";
    
#endif
    
}

+ (NSString *)AliyunSecretKey
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *runtimeN = [defaults objectForKey:@"environment_preference"];
    
    
#ifdef DEBUG
    if ([runtimeN isEqualToString:@"production"]) {
        //正式
        return @"5JF0upxoEC6mfJKg0ZPyUoLC3l47eR";
    }
    else
        return @"wWOb0wi36x13kDcAmUVGaceZAOEMzZ";
    
#else
    
    if ([runtimeN isEqualToString:@"development"]) {
        //测试
        return @"wWOb0wi36x13kDcAmUVGaceZAOEMzZ";
    }
    else
        return @"5JF0upxoEC6mfJKg0ZPyUoLC3l47eR";
    
#endif
}


+ (NSString *)AliyunBucket
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *runtimeN = [defaults objectForKey:@"environment_preference"];
    
#ifdef DEBUG
    if ([runtimeN isEqualToString:@"production"]) {
        //正式
        return @"ishare-file";
    }
    else
        return @"ishare-file-test";
    
#else
    
    if ([runtimeN isEqualToString:@"development"]) {
        //测试
        return @"ishare-file-test";
    }
    else
        return @"ishare-file";
    
#endif
}


+ (NSString *)AliyunOSSImageURL
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *runtimeN = [defaults objectForKey:@"environment_preference"];
    
#ifdef DEBUG
    if ([runtimeN isEqualToString:@"production"]) {
        //正式
        return @"http://image.shitan.me/";
    }
    else
        return @"http://image-test.dongmai.me/";
    
#else
    
    if ([runtimeN isEqualToString:@"development"]) {
        //测试
        return @"http://image-test.dongmai.me/";
    }
    else
        return @"http://image.shitan.me/";
    
#endif
}


@end
