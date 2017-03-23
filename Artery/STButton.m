//
//  STButton.m
//  Shitan
//
//  Created by Richard Liu on 15/5/3.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "STButton.h"

@implementation STButton

- (id)initWithFrame:(CGRect)frame buttonWithTitle:(NSString *)title buttonwithNum:(NSString *)numS
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // Initialization code
        CGFloat btnW = MAINSCREEN.size.width/3;
        
        _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, btnW, 21)];
        _numberLabel.text = numS;
        _numberLabel.textColor = MAIN_TEXT_COLOR;
        _numberLabel.font = [UIFont systemFontOfSize:16.0];
        _numberLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_numberLabel];
        
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 21, btnW, 21)];
        _titleLabel.text = title;
        _titleLabel.textColor = MAIN_TIME_COLOR;
        _titleLabel.font = [UIFont systemFontOfSize:14.0];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
    }
    return self;
}


// 刷新
- (void)refreshMineButton:(NSString *)numS
{
    _numberLabel.text = numS;
}


@end
