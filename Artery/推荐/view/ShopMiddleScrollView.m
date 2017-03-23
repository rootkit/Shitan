//
//  ShopMiddleScrollView.m
//  Shitan
//
//  Created by Richard Liu on 15/6/27.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "ShopMiddleScrollView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ShopMiddleScrollView ()

@property (nonatomic, weak) UIImageView *imageV;

@end


@implementation ShopMiddleScrollView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self setUpChildView];
    }
    return self;
}

- (void)setUpChildView
{
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectZero];
    _imageV = imageV;
    _imageV.contentMode = UIViewContentModeScaleAspectFill;
    _imageV.layer.cornerRadius = 3;//设置那个圆角的有多圆
    _imageV.layer.masksToBounds = YES;//设为NO去试试
    [self addSubview:_imageV];
}

- (void)setRecommendModelFrame:(RecommendModelFrame *)recommendModelFrame
{
    _recommendModelFrame = recommendModelFrame;
    self.imageV.frame = _recommendModelFrame.imageFrame;
    [self setUpChildData];
}

- (void)setUpChildData
{
    if ([_recommendModelFrame.dInfo.imgUrl length] > 0) {
        [_imageV sd_setImageWithURL:[NSURL URLWithString:_recommendModelFrame.dInfo.imgUrl] placeholderImage:[UIImage imageNamed:@"default_image.png"]];
    }
}

@end
