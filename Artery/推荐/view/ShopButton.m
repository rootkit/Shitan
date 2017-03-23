//
//  ShopButton.m
//  Shitan
//
//  Created by Richard Liu on 15/6/29.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "ShopButton.h"

#define Interval_WIDTH  10.0f

@interface ShopButton ()

@property (nonatomic, weak) UIImageView *btnImageV;
@property (nonatomic, weak) UILabel *desL;

@property (nonatomic, strong) id target;
@property (nonatomic, assign) SEL action;

@end


@implementation ShopButton

- (instancetype)initWithFrame:(CGRect)frame imageName:(NSString *)imageName
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // Initialization code
        CGFloat btnW = MAINSCREEN.size.width/3 - Interval_WIDTH*2;
        
        UIImageView *btnImageV = [[UIImageView alloc] initWithFrame:CGRectMake((MAINSCREEN.size.width/3 - 18)/2, 12, 18, 18)];
        _btnImageV = btnImageV;
        [_btnImageV setImage:[UIImage imageNamed:imageName]];
        [self addSubview:_btnImageV];
        
        
        UILabel *desL = [[UILabel alloc] initWithFrame:CGRectMake(Interval_WIDTH, 30, btnW, 21)];
        _desL = desL;
        [_desL setBackgroundColor:[UIColor clearColor]];
        _desL.textColor = MAIN_TIME_COLOR;
        _desL.font = [UIFont systemFontOfSize:12.0];
        _desL.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_desL];
    }
    
    return self;
}


//目标动作回调
- (void)addTarget:target action:(SEL)action
{
    _target = target;
    _action = action;
}


- (void)setTitle:(NSString *)title
{
    [_desL setText:title];
}


//当button点击结束时，如果结束点在button区域中执行action方法
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //获取触摸对象
    UITouch *touche = [touches anyObject];
    //获取touche的位置
    CGPoint point = [touche locationInView:self];
    
    //判断点是否在button中
    if (CGRectContainsPoint(self.bounds, point))
    {
        //执行action
        [_target performSelector:_action withObject:self];
    }
}



@end
