//
//  TipsConTableViewCell.m
//  Shitan
//
//  Created by 刘敏 on 15/1/22.
//  Copyright (c) 2015年 深圳食探网络科技有限公司. All rights reserved.
//

#import "TipsConTableViewCell.h"

@implementation TipsConTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setCellWithCellInfo:(ShopInfo *)dInfo setRow:(NSInteger)mRow
{
    
    UIImageView *lineV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image_line"]];
    
    if(mRow == 0)
    {
        //地址
        self.desLabel.text = dInfo.address;
        [self.iconImageV setImage:[UIImage imageNamed:@"imported_layers.png"]];
        [lineV setFrame:CGRectMake(15, 43.5, MAINSCREEN.size.width-15, 0.5)];
        
    }
    else if(mRow == 1){
        //电话
        if (dInfo.phone.length < 2) {
            self.desLabel.text = @"暂无";
        }
        else
            self.desLabel.text = dInfo.phone;
        
        [self.iconImageV setImage:[UIImage imageNamed:@"imported_phone.png"]];
        
        if ([dInfo.avgPrice floatValue] > 0.1)
        {
            [lineV setFrame:CGRectMake(15, 43.5, MAINSCREEN.size.width-15, 0.5)];
        }
        else
        {
            [lineV setFrame:CGRectMake(0, 43.5, MAINSCREEN.size.width, 0.5)];
        }
    }
    else if(mRow == 2)
    {
        [self.iconImageV setImage:[UIImage imageNamed:@"imported_price.png"]];
        self.desLabel.text = [NSString stringWithFormat:@"均价：%@ 元", dInfo.avgPrice];
        [lineV setFrame:CGRectMake(0, 43, MAINSCREEN.size.width, 0.5)];
    }
//    else if(mRow == 3)
//    {
//        //营业时间
//        self.desLabel.text = [NSString stringWithFormat:@"营业时间：%@", dInfo.businessTime];
//    }
    
    [self.contentView addSubview:lineV];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
