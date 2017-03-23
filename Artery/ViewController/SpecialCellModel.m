//
//  SpecialCellModel.m
//  Shitan
//
//  Created by Richard Liu on 15/4/25.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "SpecialCellModel.h"

@implementation SpecialCellModel

+ (SpecialCell *)findCellWithTableView:(UITableView *)tableView
{
    static NSString *CellIdentifier = @"SpecialCell";
    SpecialCell *cell = (SpecialCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SpecialCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

@end
