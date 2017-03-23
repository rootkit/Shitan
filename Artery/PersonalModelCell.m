//
//  PersonalModelCell.m
//  Shitan
//
//  Created by Richard Liu on 15/5/3.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "PersonalModelCell.h"

@implementation PersonalModelCell

+ (PersonalTableViewCell *)findCellWithTableView:(UITableView *)tableView
{
    static NSString *CellIdentifier = @"PersonalTableViewCell";
    PersonalTableViewCell *cell = (PersonalTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"PersonalTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

@end
