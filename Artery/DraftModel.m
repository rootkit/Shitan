//
//  DraftModel.m
//  Shitan
//
//  Created by 刘敏 on 15/1/20.
//  Copyright (c) 2015年 深圳食探网络科技有限公司. All rights reserved.
//

#import "DraftModel.h"

@implementation DraftModel

+ (DraftTableViewCell *)findCellWithTableView:(UITableView *)tableView
{
    static NSString *CellIdentifier = @"DraftTableViewCell";
    DraftTableViewCell *cell = (DraftTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"DraftTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;

}

@end
