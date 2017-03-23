//
//  PhotoListModel.h
//  Artery
//
//  Created by RichardLiu on 15/4/10.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotoListCell.h"

@interface PhotoListModel : NSObject

+ (PhotoListCell *)findCellWithTableView:(UITableView *)tableView;


@end
