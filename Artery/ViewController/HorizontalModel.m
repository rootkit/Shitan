//
//  HorizontalModel.m
//  Shitan
//
//  Created by Richard Liu on 15/4/26.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "HorizontalModel.h"

@implementation HorizontalModel

+ (HorizontalScrollCell *)findCellWithTableView:(UITableView *)tableView
{
    static NSString *CellIdentifier = @"HorizontalScrollCell";
    HorizontalScrollCell *cell = (HorizontalScrollCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"HorizontalScrollCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

@end
