//
//  WZShopCell.m
//  瀑布流
//
//  Created by Avalon on 15/4/10.
//  Copyright (c) 2015年 Avalon. All rights reserved.
//

#import "WZShopCell.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface WZShopCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;


@end



@implementation WZShopCell

- (void)setShop:(DynamicInfo *)shop{
    _shop = shop;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[Units foodImage320Thumbnails:_shop.imgUrl]]
                      placeholderImage:[UIImage imageNamed:@"default_image.png"]];
    
    self.imageView.layer.cornerRadius = 3;//设置那个圆角的有多圆
    self.imageView.layer.masksToBounds = YES;//设为NO去试试
}


@end
