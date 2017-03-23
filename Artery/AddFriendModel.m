//
//  AddFriendModel.m
//  NationalOA
//
//  Created by 刘敏 on 14-6-25.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "AddFriendModel.h"

@implementation AddFriendModel

+ (SearchTableViewCell *)findCellWithTableView:(UITableView *)tableView{
    
    static NSString *CellIdentifier = @"SearchCell";
    SearchTableViewCell *cell = (SearchTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SearchTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    return cell;
}

@end
