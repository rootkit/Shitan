//
//  CommentModle.h
//  Shitan
//
//  Created by 刘敏 on 14-10-14.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommentCell.h"

@interface CommentModle : NSObject

+ (CommentCell *)findCellWithTableView:(UITableView *)tableView;

@end
