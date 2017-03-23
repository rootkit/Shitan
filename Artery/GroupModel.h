//
//  GroupModel.h
//  Shitan
//
//  Created by Richard Liu on 15/5/21.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GroupCell.h"


@interface GroupModel : NSObject

+ (GroupCell *)findCellWithTableView:(UITableView *)tableView;

@end
