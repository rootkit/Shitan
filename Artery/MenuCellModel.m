//
//  MenuCellModel.m
//  Shitan
//
//  Created by RichardLiu on 15/4/3.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "MenuCellModel.h"

@implementation MenuCellModel

+ (MenuTableViewCell *)findCellWithTableView:(UITableView *)tableView
{
    static NSString *CellIdentifier = @"MenuTableViewCell";
    MenuTableViewCell *cell = (MenuTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"MenuTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

@end
