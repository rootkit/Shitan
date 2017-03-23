//
//  STMenuButton.h
//  Shitan
//
//  Created by Richard Liu 15/6/29.
//  Copyright (c) 2015年 深圳食探网络科技有限公司. All rights reserved.
//  干掉系统的setHighlighted方法

#import <UIKit/UIKit.h>

@interface STMenuButton : UIButton

- (instancetype)initWithFrame:(CGRect)frame setTitle:(NSString *)tit normalImage:(NSString *)imageN selectedImage:(NSString *)imageS;



@end
