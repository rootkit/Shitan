//
//  PhotoListModel.m
//  Artery
//
//  Created by RichardLiu on 15/4/10.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "PhotoListModel.h"

@implementation PhotoListModel

+ (PhotoListCell *)findCellWithTableView:(UITableView *)tableView
{
    static NSString *CellIdentifier = @"PhotoListCell";
    PhotoListCell *cell = (PhotoListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"PhotoListCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

@end
