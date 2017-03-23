//
//  PicListTableModel.m
//  Shitan
//
//  Created by Jia HongCHI on 14/12/8.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "PicListTableModel.h"

@implementation PicListTableModel

+ (PicListTableViewCell *)findCellWithTableView:(UITableView *)tableView
{
    static NSString *CellIdentifier = @"PicListTableViewCell";
    PicListTableViewCell *cell = (PicListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"PicListTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}

@end
