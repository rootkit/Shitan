//
//  PlaceModel.m
//  Artery
//
//  Created by 刘敏 on 14-10-18.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "PlaceModel.h"

@implementation PlaceModel

+ (PlaceTableViewCell *)findCellWithTableView:(UITableView *)tableView
{
    static NSString *CellIdentifier = @"PlaceTableViewCell";
    PlaceTableViewCell *cell = (PlaceTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"PlaceTableViewCell" owner:self options:nil];
        
        cell = [array objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

@end
