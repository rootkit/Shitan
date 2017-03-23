//
//  CommentModle.m
//  Shitan
//
//  Created by 刘敏 on 14-10-14.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "CommentModle.h"

@implementation CommentModle

+ (CommentCell *)findCellWithTableView:(UITableView *)tableView{
    static NSString *CellIdentifier = @"CommentCell";
    CommentCell *cell = (CommentCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CommentCell" owner:self options:nil];
        
        cell = [array objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

@end
