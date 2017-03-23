//
//  Units.h
//  Shitan
//
//  Created by 刘敏 on 14-9-13.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

void MET_MIDDLE(NSString *showString);

void AlertWithTitleAndMessage(NSString* title, NSString* message);

void AlertWithTitleAndMessageToTag(NSString* title, NSString* message, id delegate, NSInteger tag);

void AlertWithTitleAndMessageAndUnits(NSString* title, NSString* message, id delegate,
									  NSString* button1, NSString* button2);

void AlertWithTitleAndMessageAndUnitsToTag(NSString* title, NSString* message, id delegate,
                                           NSString* button1, NSString* button2,NSInteger tag);
void AlertWithTitleAndMessageAndUnitsAndOnlyOneBtn(NSString* title, NSString* message, id delegate,
                                                   NSString* button1, NSString* button2);

void ActionSheetWithParams(NSString* title, id<UIActionSheetDelegate> delegate, UIView* containView, NSString *button1, NSString *button2, NSString* button3);

UIImage* ImageWithImageSimple(UIImage *imageA, CGSize newSize);


@interface Units : NSObject


// 将时间格式化作为文件的名字
+ (NSString *)formatTimeAsFileName;

// URL编码
+ (NSString *)encodeToPercentEscapeString: (NSString *)input;

//图像旋转
+ (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation;


//获取当前时间（本地）
+ (NSString *)getNowTime;


//日期转换(NSString 转 NSDate)
+ (NSDate *)convertDateFromString:(NSString*)uiDate;

//日期转换(NSDate 转 NSString)
+ (NSString *)convertStringFromDate:(NSDate*)uiDate;

//图片合成
+ (UIImage *)addImage:(UIImage *)image1 withImage:(UIImage *)image2 rect1:(CGRect)rect1 rect2:(CGRect)rect2;

//图片上添加文字
+ (UIImage *)addText:(UIImage *)img;

//拼接头像缩略图地址
+ (NSString *)headImageThumbnails:(NSString *)urls;

//拼接美食缩略图地址
+ (NSString *)foodImage200Thumbnails:(NSString *)urls;
+ (NSString *)foodImage320Thumbnails:(NSString *)urls;
+ (NSString *)foodImage480Thumbnails:(NSString *)urls;

+ (UIButton*) navigationItemBtnInitWithNormalImageNamed:(NSString*)normalImageName andHighlightedImageNamed:(NSString*)highlighedImageName target:(id)target action:(SEL)actMethod;


//距离换算
+ (NSString *)getDistanceByLatitude:(NSString *)dis;

//根据比例（0...1）在min和max中取值
+ (CGFloat)lerp:(CGFloat)percent min:(CGFloat)nMin max:(CGFloat)nMax;


//计算两个日期之间的天数
+ (NSInteger) calcDaysFromBegin:(NSDate *)inBegin end:(NSDate *)inEnd;

+ (NSString *)dateTimeConversion:(NSString *)dateS;

@end
