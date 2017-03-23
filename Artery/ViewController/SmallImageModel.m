//
//  SmallImageModel.m
//  Shitan
//
//  Created by Richard Liu on 15/5/5.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "SmallImageModel.h"

@implementation SmallImageModel

+ (SmallImageCell *)findCellWithTableView:(UITableView *)tableView
{
    static NSString *CellIdentifier = @"SmallImageCell";
    SmallImageCell *cell = (SmallImageCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SmallImageCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

@end
