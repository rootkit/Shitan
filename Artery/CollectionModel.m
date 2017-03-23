//
//  CollectionModel.m
//  Shitan
//
//  Created by 刘敏 on 14-11-3.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "CollectionModel.h"

@implementation CollectionModel

+ (CollectionCell *)findCellWithTableView:(UITableView *)tableView{
    static NSString *CellIdentifier = @"CollectionCell";
    CollectionCell *cell = (CollectionCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CollectionCell" owner:self options:nil];
        
        cell = [array objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

@end
