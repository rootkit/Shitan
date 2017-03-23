//
//  DynamicCellModel.m
//  Shitan
//
//  Created by 刘敏 on 14/11/30.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "DynamicCellModel.h"

@implementation DynamicCellModel

+ (DynamicTableViewCell*)findCellWithTableView:(UITableView *)tableView
{
    static NSString *CellIdentifier = @"DynamicTableViewCell";
    DynamicTableViewCell *cell = (DynamicTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"DynamicTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}


@end
