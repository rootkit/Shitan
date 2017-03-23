//
//  ToolModelFrame.m
//  Shitan
//
//  Created by Richard Liu on 15/8/29.
//  Copyright (c) 2015年 深圳食探网络科技有限公司. All rights reserved.
//

#import "ToolModelFrame.h"

#define kHeadVHeight        90.0f

@implementation ToolModelFrame

- (void)setMInfo:(RecommendInfo *)mInfo{
    _mInfo = mInfo;
    [self setUpAllFrame];
}

- (void)setUpAllFrame
{
    //设置Tool
    [self setUpToolFrame];
}

- (void)setUpToolFrame
{
    _toolsFrame =  CGRectMake(0, 0, MAINSCREEN.size.width, kHeadVHeight);
    //整个高度
    _rowHeight = CGRectGetMaxY(_toolsFrame);
}


@end
