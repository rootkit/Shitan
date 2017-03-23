//
//  UIButton+BGImage.h
//  Shitan
//
//  Created by 刘敏 on 14-9-14.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (BGImage)

// 设置按钮的背景
- (void)setBackgroundImage:(NSString *) imageN setSelectedBackgroundImage:(NSString *) selImageN;

// 设置按钮的背景
- (void)setBackgroundImage:(NSString *) imageN setDisabledBackgroundImage:(NSString *) selImageN;

// 设置按钮的背景
- (void)setImage:(NSString *) imageN setSelectedImage:(NSString *) selImageN;
@end
