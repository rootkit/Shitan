//
//  FavoriteCreateViewController.h
//  Shitan
//
//  Created by Jia HongCHI on 14-10-13.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RETableViewManager.h"

@interface FavoriteCreateViewController : STChildViewController

@property (strong, readonly, nonatomic) RETableViewManager *manager;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
