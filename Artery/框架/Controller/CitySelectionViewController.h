//
//  CitySelectionViewController.h
//  Shitan
//
//  Created by 刘敏 on 14-10-6.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CityInfo.h"

@protocol CitySelectionViewControllerDelegate;

@interface CitySelectionViewController : STChildViewController

@property (nonatomic, weak) id<CitySelectionViewControllerDelegate> delegate;

@property (nonatomic, weak) UITableView *tableView;

@property (strong, nonatomic) NSArray *tableArray;           //城市数组

@end


@protocol CitySelectionViewControllerDelegate <NSObject>

@optional
- (void)returnTheCityName:(CityInfo *)cInfo;

@end
