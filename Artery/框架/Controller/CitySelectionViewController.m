//
//  CitySelectionViewController.m
//  Shitan
//
//  Created by 刘敏 on 14-10-6.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "CitySelectionViewController.h"
#import "CityDao.h"


@interface CitySelectionViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) CityDao *cityDAO;

@end

@implementation CitySelectionViewController


- (void)initDAO
{
    if(!_cityDAO)
    {
        _cityDAO = [[CityDao alloc] init];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavBarTitle:@"请选择城市"];
        
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN.size.width, MAINSCREEN.size.height) style:UITableViewStylePlain];
    _tableView = tableView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [ResetFrame resetScrollView:self.tableView contentInsetWithNaviBar:YES tabBar:NO iOS7ContentInsetStatusBarHeight:-1 inidcatorInsetStatusBarHeight:-1];

    
    [self setNavBarLeftBtn:[STNavBarView createImgNaviBarBtnByImgNormal:@"icon_close.png" imgHighlight:@"icon_close.png" target:self action:@selector(back:)]];
    
    

    UILabel *titLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/3, MAINSCREEN.size.width, 30)];
    titLabel.textAlignment = NSTextAlignmentCenter;

    titLabel.text = @"其他城市陆续开放中";
    [titLabel setFont:[UIFont systemFontOfSize:16.0]];
    [titLabel setTextColor:[UIColor lightGrayColor]];
    [self.tableView addSubview:titLabel];
    
    
    [self initDAO];
    [self getCityList];
}


- (void)getCityList
{
    [_cityDAO requestCityList:nil completionBlock:^(NSDictionary *result) {
        if (result.code == 200) {
            [self pairsData:result.obj];
        }
    } setFailedBlock:^(NSDictionary *result) {
        
    }];
}


- (void)pairsData:(NSArray *)array
{
    if (!array) {
        return;
    }
    
    NSMutableArray *tempA = [[NSMutableArray alloc] initWithCapacity:array.count];
    for (NSDictionary *item in array) {
        CityInfo *rInfo = [[CityInfo alloc] initWithParsData:item];
        [tempA addObject:rInfo];
    }
    
    self.tableArray = tempA;
    
    [self.tableView reloadData];
}


- (IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma UITableViewDelegate | UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_tableArray count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 70;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //搜索结果
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.textLabel.font = [UIFont systemFontOfSize:22.0f];
    }

    CityInfo *rInfo = _tableArray[indexPath.row];
    cell.textLabel.text = [rInfo.name stringByReplacingOccurrencesOfString:@"市" withString:@""];
    
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    //执行代理方法
    if (_delegate && [_delegate respondsToSelector:@selector(returnTheCityName:)])
    {
        theAppDelegate.cInfo = _tableArray[indexPath.row];
        [_delegate returnTheCityName:theAppDelegate.cInfo];
    }

    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
