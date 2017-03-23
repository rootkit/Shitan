//
//  Units.m
//  Shitan
//
//  Created by 刘敏 on 14-9-13.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "Units.h"
#import "MD5Hash.h"
#import "AccountInfo.h"
#import "METoast.h"

/***********************************  C Function ********************************************/
void MET_MIDDLE(NSString *showString)
{
    METoastAttribute *attri = [[METoastAttribute alloc] init];
    attri.location = METoastLocationMiddle;
    [METoast setToastAttribute:attri];
    [METoast toastWithMessage:showString];
}



void AlertWithTitleAndMessage(NSString* title, NSString* message)
{
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title
													message:message
												   delegate:nil
										  cancelButtonTitle:@"确定"
										  otherButtonTitles:nil];
	
	[alert show];
}

void AlertWithTitleAndMessageToTag(NSString* title, NSString* message, id delegate, NSInteger tag)
{
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title
													message:message
												   delegate:delegate
										  cancelButtonTitle:@"确定"
										  otherButtonTitles: nil];
    alert.tag = tag;
	
	[alert show];
}


void AlertWithTitleAndMessageAndUnits(NSString* title, NSString* message, id delegate,
									  NSString* button1, NSString* button2)
{
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title
													message:message
												   delegate:delegate
										  cancelButtonTitle:@"取消"
										  otherButtonTitles:button1, button2, nil];
	
	[alert show];
}

void AlertWithTitleAndMessageAndUnitsToTag(NSString* title, NSString* message, id delegate,
                                           NSString* button1, NSString* button2, NSInteger tag)
{
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title
													message:message
												   delegate:delegate
										  cancelButtonTitle:@"取消"
										  otherButtonTitles:button1, button2, nil];
    alert.tag = tag;
	
	[alert show];
}

void AlertWithTitleAndMessageAndUnitsAndOnlyOneBtn(NSString* title, NSString* message, id delegate,
                                                   NSString* button1, NSString* button2)
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title
													message:message
												   delegate:delegate
										  cancelButtonTitle:nil
										  otherButtonTitles:button1, button2, nil];
	
	[alert show];
}

void ActionSheetWithParams(NSString* title, id<UIActionSheetDelegate> delegate, UIView* containView,
						   NSString *button1, NSString *button2, NSString* button3)
{
	UIActionSheet* action = [[UIActionSheet alloc] initWithTitle:title delegate:delegate
                                               cancelButtonTitle:@"取消" destructiveButtonTitle:nil
                                               otherButtonTitles:button1, button2, button3, nil];
	[action showInView:containView];
}

UIImage* ImageWithImageSimple(UIImage *imageA, CGSize newSize){
    UIGraphicsBeginImageContext(newSize);
    
    [imageA drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
    
}

@implementation Units

// 将时间格式化作为文件的名字
+ (NSString *)formatTimeAsFileName
{
    //获取Taday
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy_MM_dd_hh_mm_ss"];
    NSString *currentDateStr = [formater stringFromDate:[NSDate date]];
    currentDateStr = [currentDateStr stringByReplacingOccurrencesOfString:@"_" withString:@""];
    //删除空格
    currentDateStr = [currentDateStr stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    //MD5
    currentDateStr = [MD5Hash getMd5_32Bit_String:currentDateStr];
    
    
    return currentDateStr;
}


// URL编码
+ (NSString *)encodeToPercentEscapeString: (NSString *) input
{
    // Encode all the reserved characters, per RFC 3986
    NSString *outputStr = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)input,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    return outputStr;
}



//图像旋转
+ (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation
{
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    return newPic;
}


//获取当前时间（本地）
+ (NSString *)getNowTime
{
    NSDate *senddate = [NSDate date];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString * timeS = [dateformatter stringFromDate:senddate];
    
    return timeS;
}

//日期转换(NSString 转 NSDate)
+ (NSDate *)convertDateFromString:(NSString*)uiDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [formatter dateFromString:uiDate];
    

    //转化到当前时区
    NSTimeZone *nowTimeZone = [NSTimeZone localTimeZone];
    
    NSInteger timeOffset = [nowTimeZone secondsFromGMTForDate:date];
    
    NSDate *newDate = [date dateByAddingTimeInterval:timeOffset];
    
    return newDate;
}

//日期转换(NSDate 转 NSString)
+ (NSString *)convertStringFromDate:(NSDate*)uiDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *destDateString = [dateFormatter stringFromDate:uiDate];
    
    return destDateString;
}


//图片合成添加水印
+ (UIImage *)addImage:(UIImage *)image1
            withImage:(UIImage *)image2
                rect1:(CGRect)rect1
                rect2:(CGRect)rect2
{
    CGSize size = CGSizeMake(rect1.size.width, rect1.size.height);
    
    UIGraphicsBeginImageContext(size);
    
    [image1 drawInRect:rect1];
    [image2 drawInRect:rect2];

    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    resultingImage = [Units addText:resultingImage];
    
    
    return resultingImage;
}


//图片上添加文字
+ (UIImage *)addText:(UIImage *)img
{
    
    NSString *signature = [NSString stringWithFormat:@"食探·%@", [AccountInfo sharedAccountInfo].nickname];
    
    CGSize size = CGSizeMake(MAINSCREEN.size.width*2, MAINSCREEN.size.width*2);                      //设置上下文（画布）大小
    UIGraphicsBeginImageContext(size);                       //创建一个基于位图的上下文(context)，并将其设置为当前上下文
    CGContextRef contextRef = UIGraphicsGetCurrentContext(); //获取当前上下文
    CGContextTranslateCTM(contextRef, 0, img.size.height);   //画布的高度
    CGContextScaleCTM(contextRef, 1.0, -1.0);                //画布翻转
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, img.size.width, img.size.height), [img CGImage]);  //在上下文种画当前图片
    
//    [[UIColor colorWithRed:224.0/255.0 green:57.0/255.0 blue:65.0/255.0 alpha:0.4] set];           //上下文种的文字属性
//    [[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.4] set];           //上下文种的文字属性
    
    CGContextTranslateCTM(contextRef, 0, img.size.height);
    CGContextScaleCTM(contextRef, 1.0, -1.0);
    UIFont *font = [UIFont systemFontOfSize:20];
    
    
    NSDictionary* dictonary = [NSDictionary
                              dictionaryWithObjectsAndKeys:
                              [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.4], NSForegroundColorAttributeName,
                              font, NSFontAttributeName,
                              nil];
    
    [signature drawInRect:CGRectMake(68, MAINSCREEN.size.width*2-44, 200, 80) withAttributes:dictonary];
    UIImage *targetimg =UIGraphicsGetImageFromCurrentImageContext();        //从当前上下文种获取图片
    UIGraphicsEndImageContext();                                            //移除栈顶的基于当前位图的图形上下文。
    
    
    return targetimg;
}


//拼接头像缩略图地址
+ (NSString *)headImageThumbnails:(NSString *)urls
{
    if (urls == nil || (NSNull *)urls == [NSNull null])
    {
        return nil;
    }
    
    NSRange range1 = [urls rangeOfString:@"dongmai.me"];
    NSRange range2 = [urls rangeOfString:@"shitan.me"];
    NSString *headUrl = nil;
    
    if(range1.location == NSNotFound || range2.location == NSNotFound)
    {
        headUrl = urls;
    }
    else
    {
        headUrl = [NSString stringWithFormat:@"%@%@", urls, IMAGE_160_160_FOOD];
    }
    
    return headUrl;
}


//拼接美食缩略图地址
+ (NSString *)foodImage200Thumbnails:(NSString *)urls
{
    if (urls == nil || (NSNull *)urls == [NSNull null])
    {
        return nil;
    }
    
    NSString *foodUrl = [NSString stringWithFormat:@"%@%@", urls, IMAGE_200_200_FOOD];
    
    return foodUrl;
}


//拼接美食缩略图地址
+ (NSString *)foodImage320Thumbnails:(NSString *)urls
{
    if (urls == nil || (NSNull *)urls == [NSNull null])
    {
        return nil;
    }
    
    NSString *foodUrl = [NSString stringWithFormat:@"%@%@", urls, IMAGE_320_320_FOOD];
    
    return foodUrl;
}



//拼接美食缩略图地址
+ (NSString *)foodImage480Thumbnails:(NSString *)urls
{
    if (urls == nil || (NSNull *)urls == [NSNull null])
    {
        return nil;
    }
    
    NSString *foodUrl = [NSString stringWithFormat:@"%@%@", urls, IMAGE_480_480_FOOD];
    
    return foodUrl;
}



+ (UIButton*) navigationItemBtnInitWithNormalImageNamed:(NSString*)normalImageName andHighlightedImageNamed:(NSString*)highlighedImageName target:(id)target action:(SEL)actMethod {
    UIButton* itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:normalImageName];
    itemBtn.frame = CGRectMake(0.0f, 0.0f, image.size.width, image.size.height);
    [itemBtn setBackgroundImage:[UIImage imageNamed:normalImageName] forState:UIControlStateNormal];
    [itemBtn setBackgroundImage:[UIImage imageNamed:highlighedImageName] forState:UIControlStateHighlighted];
    [itemBtn addTarget:target action:actMethod forControlEvents:UIControlEventTouchUpInside];
    return itemBtn;
}


//四舍五入保留小数（类私有方法）
+ (NSString *)notRounding:(float)price afterPoint:(int)position{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [NSString stringWithFormat:@"%@",roundedOunces];
}


//距离换算
+ (NSString *)getDistanceByLatitude:(NSString *)dis
{
    CGFloat s = [dis floatValue]/1000.0;

    if (s < 1.000000000)
    {
        //少于1km
        NSString *sv = [self notRounding:s*1000 afterPoint:0];
        return [NSString stringWithFormat:@"%@m", sv];
    }
    else if (s >= 1.000000000 && s < 10.000000000)
    {
        //大于1km 少于10km
        NSString *sv = [self notRounding:s afterPoint:1];
        return [NSString stringWithFormat:@"%@km", sv];
    }
    else{
        //大于10km
        NSString *sv = [self notRounding:s afterPoint:0];
        return [NSString stringWithFormat:@"%@km", sv];
    }

}

/*0--1 : lerp( CGFloat percent, CGFloat x, CGFloat y ){ return x + ( percent * ( y - x ) ); };*/
+ (CGFloat)lerp:(CGFloat)percent min:(CGFloat)nMin max:(CGFloat)nMax
{
    CGFloat result = nMin;
    
    result = nMin + percent * (nMax - nMin);
    
    return result;
}


//计算两个日期之间的天数
+ (NSInteger) calcDaysFromBegin:(NSDate *)inBegin end:(NSDate *)inEnd
{
    NSInteger unitFlags = NSDayCalendarUnit| NSMonthCalendarUnit | NSYearCalendarUnit;
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [cal components:unitFlags fromDate:inBegin];
    NSDate *newBegin  = [cal dateFromComponents:comps];
    
    NSCalendar *cal2 = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps2 = [cal2 components:unitFlags fromDate:inEnd];
    NSDate *newEnd  = [cal2 dateFromComponents:comps2];
    
    NSTimeInterval interval = [newEnd timeIntervalSinceDate:newBegin];
    NSInteger beginDays=((NSInteger)interval)/(3600*24);
    
    return beginDays;
}


+ (NSString *)dateTimeConversion:(NSString *)dateS
{
    //字符串截取
    NSString *tempS = [dateS substringWithRange:NSMakeRange(5, 8)];
    
    NSArray *tempA = [tempS componentsSeparatedByString:@" "];
    
    NSUInteger monthS = [[[[tempA objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:0] integerValue];
    NSUInteger date = [[[[tempA objectAtIndex:0] componentsSeparatedByString:@"-"] objectAtIndex:1] integerValue];
    NSUInteger timeS = [[tempA objectAtIndex:1] integerValue];
    
    return [NSString stringWithFormat:@"%lu月%lu日 %lu点",(unsigned long)monthS, (unsigned long)date, (unsigned long)timeS];
}



@end
