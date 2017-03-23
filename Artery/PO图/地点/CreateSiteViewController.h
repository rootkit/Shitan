//
//  CreateSiteViewController.h
//  Artery
//
//  Created by 刘敏 on 14-9-27.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RETableViewManager.h"

@interface CreateSiteViewController : STChildViewController<RETableViewManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, readwrite, nonatomic) RETableViewManager *manager;

@property (strong, nonatomic) NSString *merchantName;


@end
