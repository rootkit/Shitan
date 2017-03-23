//
//  InvitationWeiboModel.m
//  Shitan
//
//  Created by 刘敏 on 14/12/17.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "InvitationWeiboModel.h"


@implementation InvitationWeiboModel

+ (InvitationTableViewCell *)findCellWithTableView:(UITableView *)tableView{
    
    static NSString *CellIdentifier = @"InvitationTableViewCell";
    
    InvitationTableViewCell *cell = (InvitationTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"InvitationTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    return cell;
}


@end
