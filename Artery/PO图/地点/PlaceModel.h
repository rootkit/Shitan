//
//  PlaceModel.h
//  Artery
//
//  Created by 刘敏 on 14-10-18.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlaceTableViewCell.h"


@interface PlaceModel : NSObject

+ (PlaceTableViewCell *)findCellWithTableView:(UITableView *)tableView;

@end
