//
//  SearchAddressModel.m
//  Shitan
//
//  Created by RichardLiu on 15/2/28.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "SearchAddressModel.h"

@implementation SearchAddressModel

+ (SearchAddressTableViewCell *)findCellWithTableView:(UITableView *)tableView
{
    static NSString *CellIdentifier = @"SearchAddressTableViewCell";
    SearchAddressTableViewCell *cell = (SearchAddressTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SearchAddressTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

@end
