//
//  MenuCellModel.h
//  Shitan
//
//  Created by RichardLiu on 15/4/3.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MenuTableViewCell.h"

@interface MenuCellModel : NSObject

+ (MenuTableViewCell *)findCellWithTableView:(UITableView *)tableView;

@end
