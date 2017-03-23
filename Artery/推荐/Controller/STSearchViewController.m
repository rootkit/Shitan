//
//  STSearchViewController.m
//  Shitan
//
//  Created by Richard Liu on 15/9/7.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "STSearchViewController.h"
#import "RMMerchantsViewController.h"
#import "RecommendCell.h"
#import "MJRefresh.h"
#import "RecommendDAO.h"
#import <CoreLocation/CoreLocation.h>


@interface STSearchViewController ()<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *tableArray;

@property (nonatomic, assign) NSUInteger mPage;
@property (nonatomic, strong) NSString *mKeyword;

@property (nonatomic, strong) RecommendDAO *dao;


@end

@implementation STSearchViewController


- (void)initDAO
{
    if (!_dao) {
        self.dao = [[RecommendDAO alloc] init];
    }
    
    _tableArray = [[NSMutableArray alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setUpSearchBar];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, MAINSCREEN.size.width, MAINSCREEN.size.height) style:UITableViewStyleGrouped];
    _tableView = tableView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [ResetFrame resetScrollView:self.tableView contentInsetWithNaviBar:NO tabBar:NO iOS7ContentInsetStatusBarHeight:-1 inidcatorInsetStatusBarHeight:-1];
    
    
    self.tableView.backgroundColor = BACKGROUND_COLOR;
    
    [self setupRefresh];
    
    [self initDAO];
    
}


/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    self.tableView.footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
}

//刷新
- (void)headerRereshing
{
    _mPage = 1;
    [self findRecommendList];
    
}

// 下拉获取更多
- (void)footerRereshing
{
    _mPage++;
    [self findRecommendList];
}



#pragma mark - 初始化搜索栏
- (void)setUpSearchBar{
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 20, MAINSCREEN.size.width-56, 44)];
    _searchBar = searchBar;
    _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    [self.navbar addSubview:_searchBar];
    [_searchBar setPlaceholder:@"搜索美食名"];
    _searchBar.delegate = self;
    
    [self setNavBarLeftBtn:nil];
    [self setNavBarRightBtn:[STNavBarView createNormalNaviBarBtnByTitle:@"取消" target:self action:@selector(cancelButtonTapped:)]];

}

- (void)cancelButtonTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return self.tableArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5.0;
}


#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (MAINSCREEN.size.width == IPHONE6_PLUS_WIDTH){
        return IMAGE_H_IPHONE6_Plus;
    }
    else if (MAINSCREEN.size.width == IPHONE6_WIDTH) {
        return IMAGE_H_IPHONE6;
    }
    else
        return IMAGE_H_IPHONE5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecommendCell *cell = [RecommendCell cellWithTableView:tableView];
    RecommendInfo *mInfo = _tableArray[indexPath.section];
    [cell setCellWithCellInfo:mInfo];
    
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    RMMerchantsViewController *pv = CREATCONTROLLER(RMMerchantsViewController);
    pv.rInfo = _tableArray[indexPath.section];
    [self.navigationController pushViewController:pv animated:YES];
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_searchBar resignFirstResponder];
}



#pragma mark 搜索框事件
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    [self.tableArray  removeAllObjects];
    [self.tableView reloadData];
    
    
    _mPage = 1;
    _mKeyword = searchBar.text;
    //搜索
    [self findRecommendList];
}



#pragma mark 搜索请求
- (void)findRecommendList
{
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status) {
        MET_MIDDLE(@"定位失败，请开启定位或检查网络状况");
    }
    
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    [dict setObject:theAppDelegate.cInfo.cityId forKey:@"cityId"];
    
    if (theAppDelegate.longitude) {
        [dict setObject:theAppDelegate.latitude forKey:@"latitude"];
        [dict setObject:theAppDelegate.longitude forKey:@"longitude"];
    }
    
    if([AccountInfo sharedAccountInfo].userId)
    {
        [dict setObject:[AccountInfo sharedAccountInfo].userId forKey:@"userId"];
    }
    
    //最新
    [dict setObject:[NSNumber numberWithInteger:0] forKey:@"sort"];
    
    if (_mKeyword) {
        [dict setObject:_mKeyword forKey:@"keyword"];
    }
    
    [dict setObject:[NSNumber numberWithInteger:_mPage] forKey:@"page"];
    [dict setObject:[NSNumber numberWithInteger:10] forKey:@"size"];
    
    NSString* jsonString = [STJSONSerialization toJSONData:dict];
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [requestDict setObject:jsonString forKey:@"reqStr"];
    
    [_dao getRecommendList:requestDict completionBlock:^(NSDictionary *result) {
        if (result.code == 200) {
            [self pairsData:result.obj];
        }
        [self.tableView.header endRefreshing];
        [self.tableView.footer endRefreshing];
    }
            setFailedBlock:^(NSDictionary *result) {
                [self.tableView.header endRefreshing];
                [self.tableView.footer endRefreshing];
            }];

}


- (void)pairsData:(NSArray *)array
{
    if (!array || array.count == 0) {
        return;
    }
    
    
    NSMutableArray *tempA = [[NSMutableArray alloc] initWithCapacity:array.count];
    for (NSDictionary *item in array) {
        RecommendInfo *rInfo = [[RecommendInfo alloc] initWithParsData:item];
        [tempA addObject:rInfo];
    }
    
    if (_mPage == 1) {
        self.tableArray = tempA;
    }
    else{
        [self.tableArray addObjectsFromArray:tempA];
    }
    
    
    [self.tableView reloadData];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
