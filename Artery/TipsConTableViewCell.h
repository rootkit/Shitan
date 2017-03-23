//
//  TipsConTableViewCell.h
//  Shitan
//
//  Created by 刘敏 on 15/1/22.
//  Copyright (c) 2015年 深圳食探网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopInfo.h"


@interface TipsConTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *iconImageV;
@property (nonatomic, weak) IBOutlet UILabel *desLabel;

- (void)setCellWithCellInfo:(ShopInfo *)dInfo setRow:(NSInteger)mRow;

@end
