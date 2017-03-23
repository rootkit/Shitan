//
//  HorizontalScrollCell.m
//  Shitan
//
//  Created by Richard Liu on 15/4/26.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "HorizontalScrollCell.h"
#import "DynamicInfo.h"
#import <SDWebImage/UIButton+WebCache.h>


#define CLEARANCE_W    10        //按钮之间的间距
#define BUTTON_WIDTH   60

#define CLEARANCE_FIRST 10       //第一个按钮距离边界的距离X轴

@implementation HorizontalScrollCell

- (void)awakeFromNib {
    // Initialization code
    self.contentView.backgroundColor = BACKGROUND_COLOR;
    
    CGFloat m_width = MAINSCREEN.size.width -CLEARANCE_FIRST - BUTTON_WIDTH - CLEARANCE_W;
    CGFloat m_hight = BUTTON_WIDTH + CLEARANCE_W*2;
    
    //背景
    UIView *pageView = [[UIView alloc] initWithFrame:CGRectMake(0, CLEARANCE_W, MAINSCREEN.size.width, m_hight)];
    _pageView = pageView;
    [_pageView setBackgroundColor:[UIColor whiteColor]];
    [self.contentView addSubview:_pageView];
    
    //关注
    [self initFirstButton];
    
    
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(CLEARANCE_FIRST+BUTTON_WIDTH+CLEARANCE_W, 0, m_width, m_hight)];
    _scroll = scroll;
    
    [_scroll setScrollEnabled:YES];
    [_scroll setScrollsToTop:NO];
    [_scroll setShowsHorizontalScrollIndicator:NO];
    [_pageView addSubview:_scroll];
}


// 初始化第一个按钮（关注列表）
- (void)initFirstButton
{
    /***************** 第一个按钮 **********************/
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setFrame:CGRectMake(CLEARANCE_FIRST, CLEARANCE_W, BUTTON_WIDTH, BUTTON_WIDTH)];
    
    [btn1 setBackgroundImage:[UIImage imageNamed:@"icon_btn_focus.png"] forState:UIControlStateNormal];
    [btn1 setBackgroundColor:[UIColor colorWithHex:0xFB9C02]];
    [btn1 addTarget:self action:@selector(focusImagesbtn:) forControlEvents:UIControlEventTouchUpInside];
    
    //圆角
    btn1.layer.cornerRadius = 4; //设置那个圆角的有多圆
    btn1.layer.masksToBounds = YES;  //设为NO去试试
    [_pageView addSubview:btn1];
}

// 添加好友按钮
- (void)initEndButton
{
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn2 setFrame:CGRectMake(CLEARANCE_FIRST + CLEARANCE_W + BUTTON_WIDTH, CLEARANCE_W, BUTTON_WIDTH, BUTTON_WIDTH)];
    
    //添加好友
    [btn2 setImage:[UIImage imageNamed:@"icon_btn_friends.png"] forState:UIControlStateNormal];
    [btn2 setBackgroundColor:[UIColor colorWithHex:0xB1B1B1]];
    [btn2 addTarget:self action:@selector(inviteFriendsbtn:) forControlEvents:UIControlEventTouchUpInside];
    
    //圆角
    btn2.layer.cornerRadius = 4; //设置那个圆角的有多圆
    btn2.layer.masksToBounds = YES;  //设为NO去试试
    [_pageView addSubview:btn2];
}



- (void)setUpCellWithArray:(NSArray *)array
{
    NSUInteger num = [array count]+1;
    if (num == 1) {
        [self initEndButton];
    }

    /***************** 第一个按钮 **********************/
    CGFloat xbase = 0;
    
    for(int i = 0; i < [array count]+1; i++)
    {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        if(i == [array count])
        {
            [btn setImage:[UIImage imageNamed:@"icon_btn_more.png"] forState:UIControlStateNormal];
        }
        else{
            DynamicInfo *dInfo = [array objectAtIndex:i];
            [btn sd_setImageWithURL:[NSURL URLWithString:[Units foodImage200Thumbnails:dInfo.imgUrl]] forState:UIControlStateNormal];
        }

        [self.scroll addSubview:btn];
        [btn setFrame:CGRectMake(xbase, CLEARANCE_W, BUTTON_WIDTH, BUTTON_WIDTH)];
        xbase += CLEARANCE_W + BUTTON_WIDTH;
        
        btn.tag = 1000+i;
        
        [btn addTarget:self action:@selector(imageBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        //圆角
        btn.layer.cornerRadius = 4; //设置那个圆角的有多圆
        btn.layer.masksToBounds = YES;  //设为NO去试试
    }
    
    [_scroll setContentSize:CGSizeMake(xbase, _scroll.frame.size.height)];
}

// 图片按钮点击
- (void)imageBtnTapped:(UIButton *)sender
{
    NSUInteger row = sender.tag - 1000;

    if(_delegate && [_delegate respondsToSelector:@selector(horizontalScrollCell:row:)])
    {
        [_delegate horizontalScrollCell:self row:row];
    }
}


// 关注好友列表
- (void)focusImagesbtn:(id)sender
{
    if(_delegate && [_delegate respondsToSelector:@selector(horizontalScrollCell:isFirst:)])
    {
        [_delegate horizontalScrollCell:self isFirst:YES];
    }
}

// 邀请好友
- (void)inviteFriendsbtn:(id)sender
{
    if(_delegate && [_delegate respondsToSelector:@selector(horizontalScrollCell:row:)])
    {
        [_delegate horizontalScrollCell:self isFirst:NO];
    }
}


@end
