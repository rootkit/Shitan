//
//  SimpleModel.m
//  Shitan
//
//  Created by 刘敏 on 14-10-29.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "SimpleModel.h"

@implementation SimpleModel

+ (SimpleCell *)findCellWithTableView:(UITableView *)tableView
{

    static NSString *CellIdentifier = @"SimpleCell";
    SimpleCell *cell = (SimpleCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SimpleCell" owner:self options:nil];
        
        cell = [array objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}
    
@end
