//
//  ShopToolCell.h
//  Shitan
//
//  Created by Richard Liu on 15/8/29.
//  Copyright (c) 2015年 深圳食探网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToolModelFrame.h"
#import "ShopToolView.h"

@interface ShopToolCell : UITableViewCell

@property (nonatomic, strong) ToolModelFrame *toolFrame;
@property (nonatomic, weak) ShopToolView *headView;

+ (ShopToolCell *)cellWithTableView:(UITableView *)tableView;

@end
