//
//  MineButton.m
//  Shitan
//
//  Created by 刘敏 on 14-11-21.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "MineButton.h"

@implementation MineButton

- (id)initWithFrame:(CGRect)frame buttonWithTitle:(NSString *)title buttonwithNum:(NSString *)numS
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        // Initialization code
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 7, 30, 12)];
        _titleLabel.text = title;
        _titleLabel.textColor = MAIN_TIME_COLOR;
        _titleLabel.font = [UIFont systemFontOfSize:10.0];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        
        _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 21, 40, 21)];
        _numberLabel.text = numS;
        _numberLabel.textColor = MAIN_TEXT_COLOR;
        _numberLabel.font = [UIFont systemFontOfSize:17.0];
        _numberLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_numberLabel];
        
    }
    return self;
}


// 刷新
- (void)refreshMineButton:(NSString *)numS
{
    _numberLabel.text = numS;
}


@end
