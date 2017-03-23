//
//  GroupCell.m
//  Shitan
//
//  Created by Richard Liu on 15/5/21.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "GroupCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation GroupCell

- (void)awakeFromNib {
    // Initialization code
    UIImageView *headV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 80, 50)];
    _headV = headV;
    [self.contentView addSubview:_headV];
    
    UILabel *titLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, MAINSCREEN.size.width-115, 20)];
    _titLabel = titLabel;
    [_titLabel setFont:[UIFont systemFontOfSize:16.0]];
    [_titLabel setTextColor:MAIN_TEXT_COLOR];
    [self.contentView addSubview:_titLabel];
    
    //团购价格
    UILabel *tA = [[UILabel alloc] initWithFrame:CGRectMake(95, 42, 30, 20)];
    [tA setFont:[UIFont systemFontOfSize:20.0]];
    [tA setText:@"￥"];
    [tA setTextColor:MAIN_TIME_COLOR];
    [self.contentView addSubview:tA];
    
    UILabel *currentPriceL = [[UILabel alloc] initWithFrame:CGRectMake(118, 42, 80, 20)];
    _currentPriceL = currentPriceL;
    [_currentPriceL setFont:[UIFont boldSystemFontOfSize:19.0]];
    [_currentPriceL setTextColor:MAIN_COLOR];
    [self.contentView addSubview:_currentPriceL];
    
    //原价
    UILabel *tB = [[UILabel alloc] initWithFrame:CGRectMake(190, 45, 30, 20)];
    [tB setFont:[UIFont systemFontOfSize:14.0]];
    [tB setText:@"￥"];
    [tB setTextColor:MAIN_TIME_COLOR];
    [self.contentView addSubview:tB];
    
    LPLabel *priceL = [[LPLabel alloc] initWithFrame:CGRectMake(205, 44, 80, 20)];
    _priceL = priceL;
    [_priceL setFont:[UIFont systemFontOfSize:13.0]];
    [_priceL setTextColor:MAIN_TIME_COLOR];
    [self.contentView addSubview:_priceL];
    
    
    //已卖
    UILabel *purchaseL = [[UILabel alloc] initWithFrame:CGRectMake(MAINSCREEN.size.width-90, 42, 80, 20)];
    _purchaseL = purchaseL;
    [_purchaseL setFont:[UIFont systemFontOfSize:12.0]];
    [_purchaseL setTextColor:DYLIST_USERNAME_COLOR];
    [_purchaseL setTextAlignment:NSTextAlignmentRight];
    [self.contentView addSubview:_purchaseL];
}

- (void)setCellWithCellInfo:(GroupInfo *)gInfo
{
    [_headV sd_setImageWithURL:[NSURL URLWithString:gInfo.s_image_url] placeholderImage:[UIImage imageNamed:@"head_default.png"]];
    [_titLabel setText:gInfo.title];
    
    [_currentPriceL setText:[NSString stringWithFormat:@"%.1f", gInfo.current_price]];
    [_priceL setText:[NSString stringWithFormat:@"%.1f", gInfo.list_price]];
    
    [_purchaseL setText:[NSString stringWithFormat:@"已售%lu", (unsigned long)gInfo.purchase_count]];
}

@end
