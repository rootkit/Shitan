//
//  CollectionTypeViewController.h
//  Shitan
//
//  Created by 刘敏 on 14-10-13.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//  

#import <UIKit/UIKit.h>

@interface CollectionTypeViewController : STChildViewController

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSString *imageId;

@end
