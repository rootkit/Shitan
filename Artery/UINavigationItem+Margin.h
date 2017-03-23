//
//  UINavigationItem+Margin.h
//  YiChang
//
//  Created by 刘敏 on 13-12-2.
//  Copyright (c) 2013年 刘 敏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationItem (Margin)

// 自定义导航栏左按钮
- (void)setLeftBarButtonItem:(UIBarButtonItem *)_leftBarButtonItem;

// 自定义导航栏右按钮
- (void)setRightBarButtonItem:(UIBarButtonItem *)_rightBarButtonItem;

@end
