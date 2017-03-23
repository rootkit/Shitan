//
//  BannerCellModel.m
//  Shitan
//
//  Created by Richard Liu on 15/4/25.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "BannerCellModel.h"

@implementation BannerCellModel

+ (BannerCell *)findCellWithTableView:(UITableView *)tableView
{
    static NSString *CellIdentifier = @"BannerCell";
    BannerCell *cell = (BannerCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"BannerCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

@end
