//
//  SearchResultViewController.h
//  Shitan
//
//  Created by 刘敏 on 14-11-15.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//
//  搜索好友（昵称、手机号搜索）



#import "STChildViewController.h"

@interface SearchResultViewController : STChildViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *tableArray;             //表格数组
@property (strong, nonatomic) NSString *keyword;               //搜索的关键字

@end
