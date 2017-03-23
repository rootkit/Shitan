//
//  FavoriteShopViewController.m
//  Shitan
//
//  Created by Richard Liu on 15/9/1.
//  Copyright (c) 2015年 深圳食探网络科技有限公司. All rights reserved.
//

#import "FavoriteShopViewController.h"
#import "RMMerchantsViewController.h"
#import "CollectionDAO.h"
#import "RecommendCell.h"
#import "MJRefresh.h"

@interface FavoriteShopViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) CollectionDAO *favoriteDao;
@property (nonatomic, strong) NSArray *favArray;

@property (nonatomic, assign) NSUInteger mPage;

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tableArray;

@end

@implementation FavoriteShopViewController


//
- (void)initDao{
    
    if (!self.favoriteDao) {
        self.favoriteDao = [[CollectionDAO alloc]init];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initDao];
    
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN.size.width, MAINSCREEN.size.height - 84) style:UITableViewStyleGrouped];
    _tableView = tableView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    [ResetFrame resetScrollView:self.tableView contentInsetWithNaviBar:NO tabBar:NO iOS7ContentInsetStatusBarHeight:-1 inidcatorInsetStatusBarHeight:-1];
    
    [self getFavoriteShopList];
    _mPage = 1;
    
    [self setupRefresh];
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
    [self getFavoriteShopList];
    self.tableView.footer.hidden = NO;

    
}

// 下拉获取更多
- (void)footerRereshing
{
    _mPage++;
    [self getFavoriteShopList];
}


- (void)getFavoriteShopList
{
    if (![AccountInfo sharedAccountInfo].userId) {
        return;
    }
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:3];
    
    [dic setObject:[AccountInfo sharedAccountInfo].userId forKey:@"userId"];
    [dic setObject:[NSNumber numberWithInteger:10] forKey:@"size"];
    [dic setObject:[NSNumber numberWithInteger:_mPage]  forKey:@"page"];
    
    if (theAppDelegate.latitude) {
        [dic setObject:theAppDelegate.latitude forKey:@"latitude"];
        [dic setObject:theAppDelegate.longitude forKey:@"longitude"];
    }
    
    
    NSString* jsonString = [STJSONSerialization toJSONData:dic];
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [requestDict setObject:jsonString forKey:@"reqStr"];
    
    
    [_favoriteDao favoriteShopList:requestDict completionBlock:^(NSDictionary *result) {
        if (result.code == 200) {
            CLog(@"%@", result);
            if ([result.obj count] == 10) {
                _mPage++;
            }
            [self pairsData:result.obj];
        }
        else
        {
            self.tableView.footer.hidden = YES;
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
        self.tableView.footer.hidden = YES;
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
    
    self.tableArray = tempA;
    
    [self.tableView reloadData];
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

    pv.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:pv animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
