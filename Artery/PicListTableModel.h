//
//  PicListTableModel.h
//  Shitan
//
//  Created by Jia HongCHI on 14/12/8.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PicListTableViewCell.h"

@interface PicListTableModel : NSObject

+ (PicListTableViewCell *)findCellWithTableView:(UITableView *)tableView;

@end
