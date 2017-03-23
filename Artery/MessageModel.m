//
//  MessageModel.m
//  Shitan
//
//  Created by 刘敏 on 14-10-29.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "MessageModel.h"

@implementation MessageModel

+ (MessageCell *)findCellWithTableView:(UITableView *)tableView
{
    static NSString *CellIdentifier = @"MessageCell";
    MessageCell *cell = (MessageCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"MessageCell" owner:self options:nil];
        
        cell = [array objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

@end
