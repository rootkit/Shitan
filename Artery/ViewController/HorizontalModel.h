//
//  HorizontalModel.h
//  Shitan
//
//  Created by Richard Liu on 15/4/26.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HorizontalScrollCell.h"

@interface HorizontalModel : NSObject

+ (HorizontalScrollCell *)findCellWithTableView:(UITableView *)tableView;

@end
