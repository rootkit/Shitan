//
//  CityPickerViewController.m
//  Shitan
//
//  Created by 刘敏 on 14-11-13.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "CityPickerViewController.h"
#import "AccountDAO.h"

#define kProComponent 0
#define kEaraComponent 1


@interface CityPickerViewController ()<UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *cityArray;
@property (nonatomic, strong) NSArray *areaArray;
@property (nonatomic, strong) NSString *areaS;

@property (strong, readwrite, nonatomic) AccountDAO *dao;

@end

@implementation CityPickerViewController

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
    // Do any additional setup after loading the view.
    [self setNavBarTitle:@"选择城市"];
    
    [self setNavBarRightBtn:[STNavBarView createNormalNaviBarBtnByTitle:@"保存" target:self action:@selector(saveButtonTapped:)]];
    
    [ResetFrame resetScrollView:self.tableview contentInsetWithNaviBar:YES tabBar:NO iOS7ContentInsetStatusBarHeight:-1 inidcatorInsetStatusBarHeight:0];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"CityList" ofType:@"plist"];
    
    self.cityArray = [[NSArray alloc] initWithContentsOfFile:path];
    
    NSDictionary *selectedState = [self.cityArray objectAtIndex:0];
	NSArray *array = [selectedState objectForKey:@"area"];
	self.areaArray = array;
}

- (void)saveButtonTapped:(id)sender
{
    if (!_areaS) {
        MET_MIDDLE(@"所在地未做修改，无需保存。");
        return;
    }
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:2];
    [dict setObject:[AccountInfo sharedAccountInfo].userId forKey:@"userId"];
    [dict setObject:_areaS forKey:@"city"];
    
    
    NSString* jsonString = [STJSONSerialization toJSONData:dict];
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [requestDict setObject:jsonString forKey:@"reqStr"];
    
    
    [_dao requestUserUpdate:requestDict
            completionBlock:^(NSDictionary *result) {
                
                if ([[result objectForKey:@"code"] integerValue] == 200)
                {
                    //跟新用户信息
                    [AccountInfo sharedAccountInfo].city = _areaS;
                    
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
    
    cell.textLabel.text = @"地区";
    
    if (_areaS) {
        cell.detailTextLabel.text = _areaS;
    }
    else{
        cell.detailTextLabel.text = [AccountInfo sharedAccountInfo].city;
    }
    
    return cell;
}



#pragma mark -
#pragma mark Picker Data Source Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

//返回当前列显示的行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component == kProComponent )
    {
        return [self.cityArray count];
    }
    
    return [self.areaArray count];
}


#pragma mark -
#pragma mark Picker Delegate Protocol
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(component == kProComponent){
        NSDictionary *item = [self.cityArray objectAtIndex:row];
        return [item objectForKey:@"name"];
    }
    
    return [self.areaArray objectAtIndex:row];
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSDictionary *selectedState = [self.cityArray objectAtIndex:row];
    
    if (component == kProComponent)
	{
		NSArray *array = [selectedState objectForKey:@"area"];
		self.areaArray = array;
		[_pickerView selectRow:0 inComponent:kEaraComponent animated:YES];
		[_pickerView reloadComponent:kEaraComponent];
	}
    
    NSInteger proRow = [_pickerView selectedRowInComponent:kProComponent];
	NSInteger areaRow = [_pickerView selectedRowInComponent:kEaraComponent];
    
    NSString *pro = [[self.cityArray objectAtIndex:proRow] objectForKey:@"name"];
	NSString *area = [self.areaArray objectAtIndex:areaRow];
	
    _areaS = [[NSString alloc] initWithFormat:@"%@-%@", pro, area];
    
    [self.tableview reloadData];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
