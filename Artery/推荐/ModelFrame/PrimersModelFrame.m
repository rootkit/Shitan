//
//  PrimersModelFrame.m
//  Shitan
//
//  Created by Richard Liu on 15/8/28.
//  Copyright (c) 2015年 深圳食探网络科技有限公司. All rights reserved.
//

#import "PrimersModelFrame.h"
#import "MLEmojiLabel.h"


@implementation PrimersModelFrame

- (void)setDInfo:(DishesInfo *)dInfo{
    _dInfo = dInfo;
    [self setUpPrimersFrame];
}

- (void)setUpPrimersFrame
{
    MLEmojiLabel *desLabel = [[MLEmojiLabel alloc]init];
    desLabel.emojiText = _dInfo.foodDesc;
    CGSize textsize = [desLabel preferredSizeWithMaxWidth:MAINSCREEN.size.width - kDesLabelMargin * 2];
    
    _desLabelFrame = CGRectMake(kDesLabelMargin, 15, MAINSCREEN.size.width - kDesLabelMargin*2, textsize.height);
    _backViewFrame = CGRectMake(kDesLabelMargin, 0, MAINSCREEN.size.width - kDesLabelMargin*2, CGRectGetMaxY(_desLabelFrame)+15);
    
    _rowHeight = CGRectGetMaxY(_backViewFrame);
}

@end
