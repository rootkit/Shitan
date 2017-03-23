//
//  PlaceViewController.h
//  Artery
//
//  Created by 刘敏 on 14-9-25.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceInfo.h"

@interface PlaceViewController : STChildViewController<UISearchBarDelegate,UISearchDisplayDelegate,UITableViewDelegate,UITableViewDataSource>

@property (weak, readwrite, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, readwrite, weak) IBOutlet UITableView *tableview;

@property (nonatomic, strong) NSMutableArray *tableArray;     //附近的位置数据

@end

