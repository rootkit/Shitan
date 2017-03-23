//
//  ResetFrame.m
//  Shitan
//
//  Created by Richard Liu on 15/8/22.
//  Copyright (c) 2015年 深圳食探网络科技有限公司. All rights reserved.
//

#import "ResetFrame.h"

@implementation ResetFrame

// 是否4英寸屏幕
+ (BOOL)is4InchScreen
{
    static BOOL is4Inch = NO;
    static BOOL isGetValue = NO;
    
    if (!isGetValue)
    {
        CGRect mainFrame = [UIScreen mainScreen].bounds;
        is4Inch = (mainFrame.size.height >= 568.0f);
        
        isGetValue = YES;
    }
    else{
        
    }
    
    return is4Inch;
}

// label设置最小字体大小
+ (void)label:(UILabel *)label setMinFontSize:(CGFloat)minSize numberOfLines:(NSInteger)lines
{
    if (label)
    {
        label.adjustsFontSizeToFitWidth = YES;
        label.minimumScaleFactor = minSize/label.font.pointSize;
        
        if ((lines != 1) && ([UIDevice currentDevice].systemVersion.floatValue < 7.0f))
        {
            label.adjustsLetterSpacingToFitWidth = YES;
        }

    }
}

// 清除PerformRequests和notification
+ (void)cancelPerformRequestAndNotification:(UIViewController *)viewController
{
    if (viewController)
    {
        [[viewController class] cancelPreviousPerformRequestsWithTarget:viewController];
        [[NSNotificationCenter defaultCenter] removeObserver:viewController];
    }
}

// 重设scroll view的内容区域和滚动条区域
+ (void)resetScrollView:(UIScrollView *)scrollView contentInsetWithNaviBar:(BOOL)hasNaviBar tabBar:(BOOL)hasTabBar
{
    [[self class] resetScrollView:scrollView contentInsetWithNaviBar:hasNaviBar tabBar:hasTabBar iOS7ContentInsetStatusBarHeight:0 inidcatorInsetStatusBarHeight:0];
}



+ (void)resetScrollView:(UIScrollView *)scrollView contentInsetWithNaviBar:(BOOL)hasNaviBar tabBar:(BOOL)hasTabBar iOS7ContentInsetStatusBarHeight:(NSInteger)iContentMulti inidcatorInsetStatusBarHeight:(NSInteger)iIndicatorMulti
{
    if (scrollView)
    {
        UIEdgeInsets inset = scrollView.contentInset;
        UIEdgeInsets insetIndicator = scrollView.scrollIndicatorInsets;
        
        CGPoint ptContentOffset = scrollView.contentOffset;
        CGFloat fTopInset = hasNaviBar ? NaviBarHeight : 0.0f;
        CGFloat fTopIndicatorInset = hasNaviBar ? NaviBarHeight : 0.0f;
        
        if ([UIDevice currentDevice].systemVersion.floatValue < 7.0 || [UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
            //iOS6跟iOS8为NO就可以了
            hasTabBar = NO;
        }
        
        
        CGFloat fBottomInset = hasTabBar ? TabBarHeight : 0.0f;
        
        fTopInset += StatusBarHeight;
        fTopIndicatorInset += StatusBarHeight;
        
        if (isIOS7)
        {
            fTopInset += iContentMulti * StatusBarHeight;
            fTopIndicatorInset += iIndicatorMulti * StatusBarHeight;
        }

        inset.top += fTopInset;
        inset.bottom += fBottomInset;
        [scrollView setContentInset:inset];
        
        insetIndicator.top += fTopIndicatorInset;
        insetIndicator.bottom += fBottomInset;
        [scrollView setScrollIndicatorInsets:insetIndicator];
        
        ptContentOffset.y -= fTopInset;
        [scrollView setContentOffset:ptContentOffset];
    }
}


@end
