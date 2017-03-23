//
//  TalentShowViewController.h
//  Shitan
//
//  Created by 刘敏 on 14/12/9.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "STChildViewController.h"

@interface TalentShowViewController : STChildViewController

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *tableArray;             //表格数组

@end
