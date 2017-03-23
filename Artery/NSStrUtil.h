//
//  NSStrUtil.h
//  Shitan
//
//  Created by 刘敏 on 15/1/31.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSStrUtil : NSObject

// 判断字符串是否为空
+ (BOOL)isEmptyOrNull:(NSString*)string;

// 判断字符串是否为空
+ (BOOL)notEmptyOrNull:(NSString*)string;


+ (NSString*) makeNode:(NSString*)str;

+ (BOOL)isMobileNumber:(NSString *)mobileNum;

+ (NSString *)trimString:(NSString *)str;

//获取故事版的名字
+ (NSString *)getStoryNameByUrl:(NSString*)url;

@end
