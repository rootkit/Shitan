//
//  TipsTableViewModel.h
//  Shitan
//
//  Created by 刘敏 on 14/12/9.
//  Copyright (c) 2014年 刘 敏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TipsTableViewCell.h"

@interface TipsTableViewModel : NSObject

+ (TipsTableViewCell *)findCellWithTableView:(UITableView *)tableView;

@end
