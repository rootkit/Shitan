//
//  ResetFrame.h
//  Shitan
//
//  Created by Richard Liu on 15/8/22.
//  Copyright (c) 2015年 深圳食探网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResetFrame : NSObject

// 是否4英寸屏幕
+ (BOOL)is4InchScreen;

// label设置最小字体大小
+ (void)label:(UILabel *)label setMinFontSize:(CGFloat)minSize numberOfLines:(NSInteger)lines;

// 清除PerformRequests和notification
+ (void)cancelPerformRequestAndNotification:(UIViewController *)viewController;

// 重设scroll view的内容区域和滚动条区域
+ (void)resetScrollView:(UIScrollView *)scrollView contentInsetWithNaviBar:(BOOL)hasNaviBar tabBar:(BOOL)hasTabBar;

+ (void)resetScrollView:(UIScrollView *)scrollView contentInsetWithNaviBar:(BOOL)hasNaviBar tabBar:(BOOL)hasTabBar iOS7ContentInsetStatusBarHeight:(NSInteger)iContentMulti inidcatorInsetStatusBarHeight:(NSInteger)iIndicatorMulti;




@end
