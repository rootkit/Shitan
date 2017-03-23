//
//  TimeUtil.h
//  Shitan
//
//  Created by 刘敏 on 14-9-13.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeUtil : NSObject


+ (NSString *)getTimeStr1:(NSString *)time;

+ (NSString *)getTimeStrStyle1:(NSString *)time;
+ (NSString *)getTimeStr1Short:(NSString *)time;

+ (NSString *)getTimeStrStyle2:(NSString *)time;

+ (int)dayCountForMonth:(int)month andYear:(int)year;

+ (BOOL)isLeapYear:(int)year;



/**
 *  计算时间差值(当前时间与特定时间的差值)
 *
 *  @param compareDate 特定时间
 *
 *  @return
 */
+ (NSString *)compareCurrentBeginTime:(NSDate *)compareDate;

+ (NSString *)compareCurrentEndTime:(NSDate *)compareDate;



//日期转换(NSString 转 NSDate)
+ (NSDate *)dateFromString:(NSString*)uiDate;

@end
