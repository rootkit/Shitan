//
//  DatePickeViewController.m
//  Shitan
//
//  Created by 刘敏 on 14-11-13.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "DatePickeViewController.h"
#import "AccountDAO.h"


@interface DatePickeViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UIDatePicker *datePicker;
@property (strong, readwrite, nonatomic) AccountDAO *dao;
@property (strong, nonatomic) NSString *dateS;
@end

@implementation DatePickeViewController


- (void)initDao
{
    if (!self.dao) {
        self.dao = [[AccountDAO alloc] init];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initDao];
    self.tableview.backgroundColor = BACKGROUND_COLOR;
    [self setNavBarTitle:@"选择日期"];
    
    [ResetFrame resetScrollView:self.tableview contentInsetWithNaviBar:YES tabBar:NO iOS7ContentInsetStatusBarHeight:-1 inidcatorInsetStatusBarHeight:0];
    
    [self setNavBarRightBtn:[STNavBarView createNormalNaviBarBtnByTitle:@"保存" target:self action:@selector(saveButtonTapped:)]];
    
    NSDate *tempDate = nil;
    if ([AccountInfo sharedAccountInfo].birthday) {
        tempDate = [Units convertDateFromString:[AccountInfo sharedAccountInfo].birthday];
    }
    else
        tempDate = [NSDate date];

    // 设置时区
    [_datePicker setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    
    // 设置当前显示时间
    [_datePicker setDate:tempDate animated:YES];
    // 设置显示最大时间（此处为当前时间）
    [_datePicker setMaximumDate:[NSDate date]];
    // 设置UIDatePicker的显示模式
    [_datePicker setDatePickerMode:UIDatePickerModeDate];
    // 当值发生改变的时候调用的方法
    [_datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
}

#pragma mark -
#pragma mark tableView Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.textLabel.text = @"出生日期";
    
    if (_dateS) {
        cell.detailTextLabel.text = _dateS;
    }
    else{
        cell.detailTextLabel.text = [AccountInfo sharedAccountInfo].birthday;
    }
    
    return cell;
}

#pragma mark -
#pragma mark Date picker value
- (void)datePickerValueChanged:(UIDatePicker *)datePicker
{
    _dateS = [Units convertStringFromDate:self.datePicker.date];
    
    [_tableview reloadData];
}


- (void)saveButtonTapped:(id)sender
{
    if (!_dateS || [[AccountInfo sharedAccountInfo].birthday isEqualToString:_dateS]) {
        MET_MIDDLE(@"出生日期未做修改，无需保存。");
        return;
    }
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:2];
    [dict setObject:[AccountInfo sharedAccountInfo].userId forKey:@"userId"];
    [dict setObject:_dateS forKey:@"birthday"];
    
    
    NSString* jsonString = [STJSONSerialization toJSONData:dict];
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [requestDict setObject:jsonString forKey:@"reqStr"];
    
    
    [_dao requestUserUpdate:requestDict
            completionBlock:^(NSDictionary *result) {
                
                if ([[result objectForKey:@"code"] integerValue] == 200)
                {
                    //跟新用户信息
                    [AccountInfo sharedAccountInfo].birthday = _dateS;
                    
                    //返回
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else
                {
                    MET_MIDDLE([result objectForKey:@"msg"]);
                }
            }
             setFailedBlock:^(NSDictionary *result) {
                 
             }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
