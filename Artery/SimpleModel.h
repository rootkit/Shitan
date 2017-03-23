//
//  SimpleModel.h
//  Shitan
//
//  Created by 刘敏 on 14-10-29.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimpleCell.h"


@interface SimpleModel : NSObject

+ (SimpleCell *)findCellWithTableView:(UITableView *)tableView;

@end
