//
//  PlaceNormalModel.m
//  Artery
//
//  Created by RichardLiu on 15/3/27.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "PlaceNormalModel.h"

@implementation PlaceNormalModel

+ (PlaceNormalTableViewCell *)findCellWithTableView:(UITableView *)tableView
{
    static NSString *CellIdentifier = @"PlaceNormalTableViewCell";
    PlaceNormalTableViewCell *cell = (PlaceNormalTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"PlaceNormalTableViewCell" owner:self options:nil];
        
        cell = [array objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

@end
