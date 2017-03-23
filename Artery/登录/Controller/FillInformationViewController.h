//
//  FillInformationViewController.h
//  Shitan
//
//  Created by 刘敏 on 14-9-15.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "RETableViewManager.h"

@interface FillInformationViewController : STChildViewController

@property (strong, readonly, nonatomic) RETableViewManager *manager;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, weak) IBOutlet UIButton *headButton;
@property (nonatomic, strong) UIImage *headImage;


@end
