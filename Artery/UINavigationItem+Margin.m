//
//  UINavigationItem+Margin.m
//  YiChang
//
//  Created by 刘敏 on 13-12-2.
//  Copyright (c) 2013年 刘 敏. All rights reserved.
//  修正ios7偏移量

#import "UINavigationItem+Margin.h"

@implementation UINavigationItem (Margin)


- (void)setLeftBarButtonItem:(UIBarButtonItem *)_leftBarButtonItem
{
    UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    
    if (isIOS7) {
        spaceButtonItem.width = -10;
    }
    
    
    if (_leftBarButtonItem)
    {
        [self setLeftBarButtonItems:@[spaceButtonItem, _leftBarButtonItem]];
    }
    else
    {
        [self setLeftBarButtonItems:@[spaceButtonItem]];
    }
}


- (void)setRightBarButtonItem:(UIBarButtonItem *)_rightBarButtonItem
{
    UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    if (isIOS7) {
        spaceButtonItem.width = -10;
    }
    
    if (_rightBarButtonItem)
    {
        [self setRightBarButtonItems:@[spaceButtonItem, _rightBarButtonItem]];
    }
    else
    {
        [self setRightBarButtonItems:@[spaceButtonItem]];
    }
}

@end
