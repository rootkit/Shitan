//
//  SmallImageModel.h
//  Shitan
//
//  Created by Richard Liu on 15/5/5.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SmallImageCell.h"

@interface SmallImageModel : NSObject

+ (SmallImageCell *)findCellWithTableView:(UITableView *)tableView;

@end
