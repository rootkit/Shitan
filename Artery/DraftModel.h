//
//  DraftModel.h
//  Shitan
//
//  Created by 刘敏 on 15/1/20.
//  Copyright (c) 2015年 深圳食探网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DraftTableViewCell.h"

@interface DraftModel : NSObject

+ (DraftTableViewCell *)findCellWithTableView:(UITableView *)tableView;

@end