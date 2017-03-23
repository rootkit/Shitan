//
//  TopSpecialModel.m
//  Shitan
//
//  Created by Richard Liu on 15/5/5.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "TopSpecialModel.h"

@implementation TopSpecialModel

+ (TopSpecialCell *)findCellWithTableView:(UITableView *)tableView
{
    static NSString *CellIdentifier = @"TopSpecialCell";
    TopSpecialCell *cell = (TopSpecialCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"TopSpecialCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

@end
