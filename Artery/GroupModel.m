//
//  GroupModel.m
//  Shitan
//
//  Created by Richard Liu on 15/5/21.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "GroupModel.h"

@implementation GroupModel

+ (GroupCell *)findCellWithTableView:(UITableView *)tableView
{
    static NSString *CellIdentifier = @"GroupCell";
    GroupCell *cell = (GroupCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"GroupCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}


@end
