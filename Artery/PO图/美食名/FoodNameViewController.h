//
//  FoodNameViewController.h
//  Artery
//
//  Created by 刘敏 on 14-11-23.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoodInfo.h"
#import "PlaceInfo.h"

@interface FoodNameViewController : STChildViewController

@property (weak, readwrite, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, readwrite, weak) IBOutlet UITableView *tableview;

@property (nonatomic, strong) PlaceInfo *pInfo;

@end
