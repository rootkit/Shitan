//
//  STMenuButton.m
//  Shitan
//  Created by Richard Liu 15/6/29.
//  Copyright (c) 2015年 深圳食探网络科技有限公司. All rights reserved.
//  干掉系统的setHighlighted方法

#import "STMenuButton.h"

@implementation STMenuButton

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame setTitle:(NSString *)tit normalImage:(NSString *)imageN selectedImage:(NSString *)imageS
{
    if (self = [super initWithFrame:frame]) {
        // 标题
        [self setTitle:[NSString stringWithFormat:@"   %@", tit] forState:UIControlStateNormal];
        //字体大小
        [self.titleLabel setFont:[UIFont systemFontOfSize:17.0]];
        
        [self setImage:[UIImage imageNamed:imageN] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:imageS] forState:UIControlStateHighlighted];
        [self setImage:[UIImage imageNamed:imageS] forState:UIControlStateSelected];
                
        // 标题颜色
        [self setTitleColor:MAIN_TITLE_COLOR forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted{}

@end
