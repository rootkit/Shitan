
//
//  shareButton.m
//  Shitan
//
//  Created by Avalon on 15/5/23.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "shareButton.h"

#define kRATIO 0.7

@implementation shareButton

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self setTitleColor:MAIN_TEXT_COLOR forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:14.0];
    }
    
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height * kRATIO);
    
    self.titleLabel.frame = CGRectMake(0, CGRectGetMaxY(self.imageView.frame), self.frame.size.width, self.frame.size.height * (1 - kRATIO));
    
}



@end
