//
//  SettingModel.h
//  Shitan
//
//  Created by 刘敏 on 15/1/18.
//  Copyright (c) 2015年 深圳食探网络科技有限公司. All rights reserved.
//  配置文件

#import <Foundation/Foundation.h>

@interface SettingModel : NSObject

//运行环境
+ (BOOL)runtimeEnvironment;

+ (NSString *)runtimeStatus;

//是否支持手机日志
+ (BOOL)isCollectLogs;

+ (NSString *)AliyunAccessKey;

+ (NSString *)AliyunSecretKey;

+ (NSString *)AliyunBucket;

// 图片存储地址
+ (NSString *)AliyunOSSImageURL;


@end
