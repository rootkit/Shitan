//
//  TextFieldEditViewController.h
//  Shitan
//
//  Created by Jia HongCHI on 14-10-10.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RETableViewManager.h"
#import "PersonalInfo.h"

@interface TextFieldEditViewController : STChildViewController

@property (strong, readonly, nonatomic) RETableViewManager *manager;
@property (nonatomic, weak) IBOutlet UITableView *tableView;


//编辑标题，例如 昵称、姓名 等
@property (weak, nonatomic) NSString *editTitle;


@end
