//
//  ShopButton.h
//  Shitan
//
//  Created by Richard Liu on 15/6/29.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopButton : UIView

@property (nonatomic, strong) NSString *title;

- (instancetype)initWithFrame:(CGRect)frame imageName:(NSString *)imageName;

// Target-Action回调
- (void)addTarget:target action:(SEL)action;

@end
