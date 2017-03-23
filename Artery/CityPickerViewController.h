//
//  CityPickerViewController.h
//  Shitan
//
//  Created by 刘敏 on 14-11-13.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "STChildViewController.h"
#import "PersonalInfo.h"

@interface CityPickerViewController : STChildViewController

@property (nonatomic, weak) IBOutlet UIPickerView* pickerView;
@property (nonatomic, weak) IBOutlet UITableView *tableview;


@end
