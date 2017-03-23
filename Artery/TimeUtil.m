//
//  TimeUtil.m
//  Shitan
//
//  Created by 刘敏 on 14-9-13.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "TimeUtil.h"

@implementation TimeUtil


//将日期转成秒
+ (long long)getTimeWithDate:(NSString *)dateS
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *destDate= [dateFormatter dateFromString:dateS];
    
    NSTimeInterval interv = [destDate timeIntervalSince1970];
    
    return interv;
}


+ (NSString*)getTimeStr:(long) createdAt
{
    // 计算距离时间的字符串
    //
    NSString *timestamp;
    time_t now;
    time(&now);
    
    int distance = (int)difftime(now, createdAt);
    if (distance < 0) distance = 0;
    
    if (distance < 60) {
        timestamp = [NSString stringWithFormat:@"%d %s", distance, (distance == 1) ? "second ago" : "seconds ago"];
    }
    else if (distance < 60 * 60) {
        distance = distance / 60;
        timestamp = [NSString stringWithFormat:@"%d %s", distance, (distance == 1) ? "minute ago" : "minutes ago"];
    }
    else if (distance < 60 * 60 * 24) {
        distance = distance / 60 / 60;
        timestamp = [NSString stringWithFormat:@"%d %s", distance, (distance == 1) ? "hour ago" : "hours ago"];
    }
    else if (distance < 60 * 60 * 24 * 7) {
        distance = distance / 60 / 60 / 24;
        timestamp = [NSString stringWithFormat:@"%d %s", distance, (distance == 1) ? "day ago" : "days ago"];
    }
    else if (distance < 60 * 60 * 24 * 7 * 4) {
        distance = distance / 60 / 60 / 24 / 7;
        timestamp = [NSString stringWithFormat:@"%d %s", distance, (distance == 1) ? "week ago" : "weeks ago"];
    }
    else {
        static NSDateFormatter *dateFormatter = nil;
        if (dateFormatter == nil) {
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateStyle:NSDateFormatterShortStyle];
            [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        }
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:createdAt]; 
        timestamp = [dateFormatter stringFromDate:date];
    }
    return timestamp;
}

+ (NSString*)getTimeStr1:(NSString *)time
{
    
    NSTimeInterval interv = [self getTimeWithDate:time];
    
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:interv];
    NSCalendar * calendar=[[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSMonthCalendarUnit | NSDayCalendarUnit|NSYearCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit;
    NSDateComponents * component=[calendar components:unitFlags fromDate:date];
    NSString * string=[NSString stringWithFormat:@"%04d-%02d-%02d %02d:%02d",[component year],[component month],[component day],[component hour],[component minute]];
    
    return string;
}

+ (NSString*)getTimeStr1Short:(NSString *)time
{
    NSTimeInterval interv = [self getTimeWithDate:time];
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:interv];
    NSCalendar * calendar=[[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSMonthCalendarUnit | NSDayCalendarUnit|NSYearCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit;
    NSDateComponents * component=[calendar components:unitFlags fromDate:date];
    NSString * string=[NSString stringWithFormat:@"%04d-%02d-%02d",[component year],[component month],[component day]];
    return string;
}

+ (NSString*)getMDStr:(long long)time
{
    
    NSDate * date=[NSDate dateWithTimeIntervalSince1970:time];
    NSCalendar * calendar=[[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSMonthCalendarUnit | NSDayCalendarUnit|NSYearCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit;
    NSDateComponents * component=[calendar components:unitFlags fromDate:date];
    NSString * string=[NSString stringWithFormat:@"%d月%d日",[component month],[component day]];
    return string;
}

+(NSDateComponents*) getComponent:(long long)time
{
    NSDate * date=[NSDate dateWithTimeIntervalSince1970:time];
    NSCalendar * calendar=[[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSMonthCalendarUnit | NSDayCalendarUnit|NSYearCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit;
    NSDateComponents * component=[calendar components:unitFlags fromDate:date];
    return component;
}


+(NSString*) getTimeStrStyle1:(NSString *)time
{
    NSTimeInterval interv = [self getTimeWithDate:time];
    
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:interv];
    NSCalendar * calendar=[[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSMonthCalendarUnit | NSDayCalendarUnit|NSYearCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit;
    NSDateComponents * component=[calendar components:unitFlags fromDate:date];

    int year=[component year];
    int month=[component month];
    int day=[component day];
    
    int hour=[component hour];
    int minute=[component minute];
    
    NSDate * today=[NSDate date];
    component=[calendar components:unitFlags fromDate:today];
    
    int t_year=[component year];
    
    NSString*string=nil;
    
    long long now=[today timeIntervalSince1970];
    
    long distance = now-interv;
    if(distance<60)
        string=@"刚刚";
    else if(distance<60*60)
        string=[NSString stringWithFormat:@"%ld分钟前",distance/60];
    else if(distance<60*60*24)
        string=[NSString stringWithFormat:@"%ld小时前",distance/60/60];
    else if(distance<60*60*24*7)
        string=[NSString stringWithFormat:@"%ld天前",distance/60/60/24];
    else if(year==t_year)
        string=[NSString stringWithFormat:@"%02d-%02d %d:%02d",month,day,hour,minute];
    else
        string=[NSString stringWithFormat:@"%d-%d-%d",year,month,day];
    
    return string;   
    
}


+ (NSString*) getTimeStrStyle2:(NSString *)time
{
    NSTimeInterval interv = [self getTimeWithDate:time];
    
    NSDate * date=[NSDate dateWithTimeIntervalSince1970:interv];
    NSCalendar * calendar=[[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSMonthCalendarUnit | NSDayCalendarUnit|NSYearCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit;
    
    NSDateComponents * component=[calendar components:unitFlags fromDate:date];
    
    int year = [component year];
    int month = [component month];
    int day = [component day];
    int hour = [component hour];
    int minute = [component minute];
    int week = [component week];
    int weekday = [component weekday];
    
    NSDate * today = [NSDate date];
    component = [calendar components:unitFlags fromDate:today];
    
    int t_year = [component year];
    int t_month = [component month];
    int t_day = [component day];
    int t_week = [component week];
    
    NSString *string = nil;
    if(year == t_year && month == t_month && day == t_day)
    {
        if(hour < 6 && hour >= 0)
        {
            string = [NSString stringWithFormat:@"凌晨 %d:%02d", hour,minute];
        }
        else if(hour >= 6 && hour < 12)
        {
            string = [NSString stringWithFormat:@"上午 %d:%02d",hour,minute];
        }
        else if(hour >= 12 && hour < 18)
        {
            string = [NSString stringWithFormat:@"下午 %d:%02d",hour,minute];
        }
        else
        {
            string = [NSString stringWithFormat:@"晚上 %d:%02d",hour,minute];
        }
    }
    else if(year==t_year&&week==t_week)
    {
        NSString * daystr=nil;
        switch (weekday) {
            case 1:
                daystr=@"日";
                break;
            case 2:
                daystr=@"一";
                break;
            case 3:
                daystr=@"二";
                break;
            case 4:
                daystr=@"三";
                break;
            case 5:
                daystr=@"四";
                break;
            case 6:
                daystr=@"五";
                break;
            case 7:
                daystr=@"六";
                break;
            default:
                break;
        }
        string=[NSString stringWithFormat:@"周%@ %d:%02d",daystr,hour,minute];
    }
    else if(year==t_year)
        string=[NSString stringWithFormat:@"%d月%d日",month,day];
    else
        string=[NSString stringWithFormat:@"%d年%d月%d日",year,month,day];
    
    return string;
}


/**
 *  得到某个月的天数
 *
 *  @param month 月份
 *  @param year  年份
 *
 *  @return 返回该月的天数
 */
+ (int)dayCountForMonth:(int)month andYear:(int)year
{
    if (month==1||month==3||month==5||month==7||month==8||month==10||month==12) {
        return 31;
    }
    else if(month==4||month==6||month==9||month==11){
        return 30;
    }
    else if([self isLeapYear:year]){
        return 29;
    }
    else{
        return 28;
    }
}


/**
 *  是否为闰年
 *
 *  @param year 年份
 *
 *  @return 是否为闰年
 */
+ (BOOL)isLeapYear:(int)year
{
    if (year%400 == 0) {
        return YES;
    }
    else{
        if (year%4 == 0 && year%100 != 0) {
            return YES;
        }
        else{
            return NO;
        }
    }
}



+ (NSString *)compareCurrentBeginTime:(NSDate *)compareDate
{
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
    timeInterval = -(timeInterval - 60*60*8);

    NSString *result;
    
    if (timeInterval < 0) {
        result = [NSString stringWithFormat:@"活动未开始"];
    }
    
    return result;
}



+ (NSString *)compareCurrentEndTime:(NSDate *)compareDate
{
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
    //timeInterval = -(timeInterval - 60*60*8);
    
    long temp = 0;
    NSString *result;
    
    
    if (timeInterval >= 0) {
        result = @"活动已结束";
    }
    else
    {
        NSTimeInterval  timeS = -timeInterval;
        
        if (timeS < 60 && timeS >= 0) {
            result = [NSString stringWithFormat:@"活动已结束"];
        }
        else if((temp = timeS/60) <60){
            result = [NSString stringWithFormat:@"还有%ld分钟结束",temp];
        }
        else if((temp = temp/60) <24){
            result = [NSString stringWithFormat:@"还有%ld小时结束",temp];
        }
        else if((temp = temp/24) <30){
            result = [NSString stringWithFormat:@"还有%ld天结束",temp];
        }
        else if((temp = temp/30) <12){
            result = [NSString stringWithFormat:@"还有%ld月结束",temp];
        }
        else{
            temp = temp/12;
            result = [NSString stringWithFormat:@"还有%ld年结束",temp];
        }
    }
    
    return  result;
    
}


//日期转换(NSString 转 NSDate)
+ (NSDate *)dateFromString:(NSString*)uiDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:uiDate];
    
    
    //转化到当前时区
    NSTimeZone *nowTimeZone = [NSTimeZone localTimeZone];
    
    NSInteger timeOffset = [nowTimeZone secondsFromGMTForDate:date];
    
    NSDate *newDate = [date dateByAddingTimeInterval:timeOffset];
    
    return newDate;
}

@end
