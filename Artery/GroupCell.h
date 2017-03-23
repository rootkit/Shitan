//
//  GroupCell.h
//  Shitan
//
//  Created by Richard Liu on 15/5/21.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupInfo.h"
#import "LPLabel.h"

@interface GroupCell : UITableViewCell

@property (nonatomic, weak) UIImageView *headV;              
@property (nonatomic, weak) UILabel *titLabel;

@property (nonatomic, weak) LPLabel *priceL;             //原价
@property (nonatomic, weak) UILabel *currentPriceL;      //团购价格

@property (nonatomic, weak) UILabel *purchaseL;          //已经购买数量


- (void)setCellWithCellInfo:(GroupInfo *)gInfo;

@end
