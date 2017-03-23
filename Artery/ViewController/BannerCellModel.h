//
//  BannerCellModel.h
//  Shitan
//
//  Created by Richard Liu on 15/4/25.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BannerCell.h"

@interface BannerCellModel : NSObject

+ (BannerCell *)findCellWithTableView:(UITableView *)tableView;

@end
