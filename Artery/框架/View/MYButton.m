//
//  MYButton.m
//  Shitan
//
//  Created by Richard Liu on 15/9/25.
//  Copyright © 2015年 刘 敏. All rights reserved.
//

#import "MYButton.h"

@implementation MYButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setTitleColor:MAIN_COLOR forState:UIControlStateSelected];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [self.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        
        //圆角
        self.layer.cornerRadius = CGRectGetHeight(frame)/2; //设置那个圆角的有多圆
        self.layer.borderWidth = 0.5;//设置边框的宽度，当然可以不要
        self.layer.borderColor = [[UIColor grayColor] CGColor];//设置边框的颜色
        self.layer.masksToBounds = YES;  //设为NO去试试

        
    }
    
    return self;
}



- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if(selected)
    {
        self.layer.borderColor = [MAIN_COLOR CGColor];//设置边框的颜色
        self.layer.borderWidth = 1;
    }
    else
    {
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = [[UIColor grayColor] CGColor];//设置边框的颜色
        
    }
}

@end
