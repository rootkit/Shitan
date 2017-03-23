//
//  AddressBookModel.m
//  Shitan
//
//  Created by 刘敏 on 15/1/14.
//  Copyright (c) 2015年 深圳食探网络科技有限公司. All rights reserved.
//

#import "AddressBookModel.h"

@implementation AddressBookModel

+ (AddressBookTableViewCell *)findCellWithTableView:(UITableView *)tableView
{
    static NSString *CellIdentifier = @"AddressBookTableViewCell";
    AddressBookTableViewCell *cell = (AddressBookTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"AddressBookTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

@end
