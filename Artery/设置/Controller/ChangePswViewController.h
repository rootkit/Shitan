//
//  ChangePswViewController.h
//  Shitan
//
//  Created by 刘敏 on 14-11-11.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "STChildViewController.h"
#import "RETableViewManager.h"

@interface ChangePswViewController : STChildViewController

@property (strong, readonly, nonatomic) RETableViewManager *manager;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end
