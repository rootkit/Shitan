//
//  CollectionModel.h
//  Shitan
//
//  Created by 刘敏 on 14-11-3.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CollectionCell.h"


@interface CollectionModel : NSObject

+ (CollectionCell *)findCellWithTableView:(UITableView *)tableView;

@end
