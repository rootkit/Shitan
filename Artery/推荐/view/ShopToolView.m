//
//  ShopToolView.m
//  Shitan
//
//  Created by Richard Liu on 15/8/29.
//  Copyright (c) 2015年 深圳食探网络科技有限公司. All rights reserved.
//

#import "ShopToolView.h"
#import "ShopButton.h"

#define BTN_W    MAINSCREEN.size.width/3


@implementation ShopToolView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self setUpChildView];
        
    }
    return self;
}


- (void)setUpChildView
{
    
    NSArray *imageArray = [[NSArray alloc] initWithObjects:@"merchant_address.png", @"merchant_phone.png", @"merchant_capita.png", nil];
    
    for (int i = 0; i<3; i++) {
        
        UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(BTN_W*(i+1), 32, 0.5, 24)];
        [la setBackgroundColor:[UIColor lightGrayColor]];
        [self addSubview:la];
        
        //初始化
        ShopButton *btn = [[ShopButton alloc] initWithFrame:CGRectMake(BTN_W*i, 15, MAINSCREEN.size.width/3, 60)
                                                  imageName:[imageArray objectAtIndex:i]];
        btn.tag = i+1000;
        
        //注册回调
        [btn addTarget:self action:@selector(tapButton:)];
        
        [self addSubview:btn];
        [self bringSubviewToFront:btn];
        
    }
}


- (void)setHeadFrame:(ToolModelFrame *)headFrame{
    
    _headFrame = headFrame;
    [self setUpChildData];
}

- (void)setUpChildData
{
    NSString *capitaS = [NSString stringWithFormat:@"人均：%@元", _headFrame.mInfo.avgPrice];
    
    for (int i = 0; i<3; i++) {
        ShopButton *btn = (ShopButton *)[self viewWithTag:i+1000];
        if (btn) {
            switch (i) {
                case 0:
                    btn.title = _headFrame.mInfo.street;
                    break;
                    
                case 1:
                    btn.title = _headFrame.mInfo.phone;
                    break;
                    
                case 2:
                    btn.title = capitaS;
                    break;
                    
                default:
                    break;
            }
            
        }
    }
}

//触摸事件响应
- (void)tapButton:(ShopButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(shopToolView:btnWithTag:)]) {
        [_delegate shopToolView:self btnWithTag:(sender.tag -1000)];
    }
    
}


@end
