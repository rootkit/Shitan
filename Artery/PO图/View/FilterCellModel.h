//
//  FilterCellModel.h
//  Artery
//
//  Created by 刘敏 on 14-10-23.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FilterCell.h"

@interface FilterCellModel : NSObject

+ (FilterCell *)findCellWithTableView:(UITableView *)tableView;

@end
