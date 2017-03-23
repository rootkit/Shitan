//
//  WNXPromptView.h
//  Shitan
//
//  Created by Richard Liu 15/7/12.
//  Copyright (c) 2015年 深圳食探网络科技有限公司. All rights reserved.
//  提醒用的View

#import <UIKit/UIKit.h>

@interface WNXPromptView : UIView

- (void)showPromptViewToView:(UIView *)superView;

- (void)hidePromptViewToView;

+ (instancetype)promptView;

@end
