//
//  TipsTableViewModel.m
//  Shitan
//
//  Created by 刘敏 on 14/12/9.
//  Copyright (c) 2014年 刘 敏. All rights reserved.
//

#import "TipsTableViewModel.h"

@implementation TipsTableViewModel

+ (TipsTableViewCell *)findCellWithTableView:(UITableView *)tableView
{
    static NSString *CellIdentifier = @"TipsTableViewCell";
    TipsTableViewCell *cell = (TipsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"TipsTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}



@end
