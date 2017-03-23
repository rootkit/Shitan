//
//  RecommendModelFrame.m
//  Shitan
//
//  Created by Richard Liu on 15/6/27.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//  商家推荐

#import "RecommendModelFrame.h"
#import "MLEmojiLabel.h"


@implementation RecommendModelFrame

- (void)setDInfo:(DishesInfo *)dInfo
{
    _dInfo = dInfo;
    [self setUpAllFrame];
}

- (void)setUpAllFrame
{
    //文字、标题
    [self setUpBottomViewFrame];
    //图片
    [self setUpScrollViewFrame];

}

- (void)setUpBottomViewFrame
{
    CGFloat m_w = 0.0;
    
    if (self.dInfo.foodName.length > 0)
    {
        _dishNameFrame = CGRectMake(kDesLabelMargin, 30, MAINSCREEN.size.width - kDesLabelMargin*2, 15);
        m_w = CGRectGetMinY(_dishNameFrame);
        
        
        if (self.dInfo.foodType == 2) {
            _lineVFrame = CGRectMake(kDesLabelMargin, 58, MAINSCREEN.size.width - kDesLabelMargin*2, 1);
            
            CGSize size = [self.dInfo.foodName sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15.0]}];
            CGFloat m_width = MAINSCREEN.size.width/2 - size.width/2;
            _shadowFrame = CGRectMake(m_width-3, 56, size.width+6, 5);
            
            m_w = CGRectGetMinY(_shadowFrame) + 15;
        }
        else
            m_w +=22;
        
    }
    else
    {
        _dishNameFrame = CGRectZero;
        m_w = CGRectGetMinY(_dishNameFrame);
    }
    
    if (self.dInfo.foodDesc.length > 0) {
        MLEmojiLabel *desLabel = [[MLEmojiLabel alloc]init];
        desLabel.emojiText = self.dInfo.foodDesc;
        CGSize textsize = [desLabel preferredSizeWithMaxWidth:MAINSCREEN.size.width - kDesLabelMargin * 2];
        _desLabelFrame = CGRectMake(kDesLabelMargin, 15+m_w, MAINSCREEN.size.width - kDesLabelMargin*2, textsize.height);
        
        _bottomViewFrame = CGRectMake(0, 0, MAINSCREEN.size.width, CGRectGetMaxY(_desLabelFrame)+15);
    }
    else
    {
        _desLabelFrame  = CGRectZero;
        _bottomViewFrame = CGRectMake(0, 0, MAINSCREEN.size.width, m_w);
    }
}


- (void)setUpScrollViewFrame
{
    _imageFrame = CGRectZero;
    
    if ([self.dInfo.imgUrl length] > 0)
    {
        CGFloat image_W = MAINSCREEN.size.width - kDesLabelMargin*2;    //宽度
        CGFloat image_H = 0.0;                                          //高度
        
        if (self.dInfo.isSquare)
        {
            image_H = image_W;
        }
        else
            image_H = image_W *0.62;
         
        
        _imageFrame = CGRectMake(kDesLabelMargin, 8, image_W, image_H);
    }
    
    _scrollViewFrame = CGRectMake(0, CGRectGetMaxY(_bottomViewFrame), MAINSCREEN.size.width, CGRectGetMaxY(_imageFrame));
    
    _rowHeight = CGRectGetMaxY(_scrollViewFrame);
}


- (CGFloat)calculateDesLabelheight:(NSString *)text
{
    UIFont *font = [UIFont systemFontOfSize:14.0];
    //设置一个行高上限
    CGSize size = CGSizeMake(20000, 15);
    
    //TODO:需要ios7以上才能使用
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil];
    size =[text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:tdic context:nil].size;
    
    return size.width;
}

@end
