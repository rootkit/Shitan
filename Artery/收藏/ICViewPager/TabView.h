//
//  TabView.h
//  Shitan
//
//  Created by Richard Liu on 15/8/5.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabView : UIView

@property (nonatomic, getter = isSelected) BOOL selected;
@property (nonatomic) UIColor *indicatorColor;

@end
