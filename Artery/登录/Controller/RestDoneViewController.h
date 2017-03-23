//
//  RestDoneViewController.h
//  Shitan
//
//  Created by 刘敏 on 14-11-19.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "STChildViewController.h"
#import "RETableViewManager.h"

@interface RestDoneViewController : STChildViewController

@property (strong, readonly, nonatomic) RETableViewManager *manager;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, assign) STPhoneSetType phoneType;

@end
