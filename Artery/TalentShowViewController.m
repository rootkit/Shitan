//
//  TalentShowViewController.m
//  Shitan
//
//  Created by 刘敏 on 14/12/9.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "TalentShowViewController.h"
#import "UserRelationshipDAO.h"
#import "UserTableViewCell.h"
#import "MJRefresh.h"
#import "HimselfViewController.h"
#import "UserTableModel.h"
#import "ProfileTableViewController.h"

@interface TalentShowViewController ()<UserCellDelegate>
{
    UIStoryboard *mineStoryboard;
}
@property (assign, nonatomic) NSInteger tPage;   //当前页码
@property (strong, nonatomic) UserRelationshipDAO *dao;

@end

@implementation TalentShowViewController

- (void)initDao
{
    if (!_dao) {
        self.dao = [[UserRelationshipDAO alloc] init];
    }
}

/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    self.tableView.footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(getDarenWithCity)];
}

// 附近列表下拉获取更多
- (void)getDarenWithCity
{
    _tPage++;
    [self getDarenWithCity:_tPage];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"同城达人推荐"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"同城达人推荐"];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavBarTitle:@"同城达人推荐"];
    
    [ResetFrame resetScrollView:self.tableView contentInsetWithNaviBar:YES tabBar:NO iOS7ContentInsetStatusBarHeight:-1 inidcatorInsetStatusBarHeight:-1];
    
    [self initDao];
    
    [self setupRefresh];
    
    //初始分页个数
    _tPage = 1;
    _tableArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self getDarenWithCity:_tPage];
    
    [self setExtraCellLineHidden:_tableView];
    
    mineStoryboard = [UIStoryboard storyboardWithName:@"MineStoryboard" bundle:nil];
}

//清除多余分割线
- (void)setExtraCellLineHidden:(UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 54;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _tableArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UserTableViewCell *cell = [UserTableModel findCellWithTableView:tableView];
    
    PersonalInfo *pInfo = [[PersonalInfo alloc] initWithParsData:[self.tableArray objectAtIndex:indexPath.row]];
    cell.delegate = self;
    
    [cell setCellWithRelationshipCellInfo:pInfo setRow:indexPath.row];
    
    return cell;
    
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PersonalInfo *pInfo = [[PersonalInfo alloc] initWithParsData:[_tableArray objectAtIndex:indexPath.row]];
    if (![pInfo.userId isEqualToString:[AccountInfo sharedAccountInfo].userId]){
        HimselfViewController *hVC = [mineStoryboard instantiateViewControllerWithIdentifier:@"HimselfViewController"];
        hVC.respondentUserId = pInfo.userId;
        hVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:hVC animated:YES];
    }else{
        ProfileTableViewController *hVC = [[ProfileTableViewController alloc] init];
        hVC.isFromTabbar = NO;
        [self.navigationController pushViewController:hVC animated:YES];
    }
    
}

#pragma mark UserCellDelegate
- (void)followButtonWithCellwithRow:(NSInteger)row
{
    PersonalInfo *pInfo = [[PersonalInfo alloc] initWithParsData:[_tableArray objectAtIndex:row]];
    
    if (pInfo.hasFollow == 1)
    {
        //取消关注
        NSMutableDictionary *encapsulateData = [[NSMutableDictionary alloc] initWithCapacity:2];
        
        [encapsulateData setObject:[AccountInfo sharedAccountInfo].userId forKey:@"followerUserId"];
        [encapsulateData setObject:pInfo.userId forKey:@"followedUserId"];
        
        //取消关注
        [_dao requestUserUnFollow:encapsulateData completionBlock:^(NSDictionary *result) {
            if ([[result objectForKey:@"code"] integerValue] == 200)
            {
                //重新获取
                [AccountInfo sharedAccountInfo].followedCount--;
                [self getDarenWithCity:1];
            }
            
        } setFailedBlock:^(NSDictionary *result) {
            
        }];
    }
    else if (pInfo.hasFollow == 0)
    {
        //关注好友
        NSMutableDictionary *encapsulateData = [[NSMutableDictionary alloc] initWithCapacity:2];
        
        
        [encapsulateData setObject:[AccountInfo sharedAccountInfo].userId forKey:@"followerUserId"];
        [encapsulateData setObject:pInfo.userId forKey:@"followedUserId"];
        
        [_dao requestUserFollow:encapsulateData completionBlock:^(NSDictionary *result) {
            if ([[result objectForKey:@"code"] integerValue] == 200)
            {
                //重新获取
                [AccountInfo sharedAccountInfo].followedCount++;
                [self getDarenWithCity:1];
            }
            else
            {
                CLog(@"%@", [result objectForKey:@"msg"]);
            }
        } setFailedBlock:^(NSDictionary *result) {
            
            
        }];
    }
}


- (void)getDarenWithCity:(NSInteger)page
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    if (theAppDelegate.cityName) {
        [dic setObject:theAppDelegate.cityName forKey:@"city"];
    }
    
    [dic setObject:[AccountInfo sharedAccountInfo].userId forKey:@"userId"];
    [dic setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    [dic setObject:[NSNumber numberWithInteger:20] forKey:@"size"];
    
    [_dao requestDarenWithCity:dic completionBlock:^(NSDictionary *result) {
        
        if ([[result objectForKey:@"code"] integerValue] == 200) {
            if ([result objectForKey:@"obj"]) {
                if (_tPage == 1) {
                    //如果请求的是第一页，则初始化array
                    [_tableArray removeAllObjects];
                }
                [_tableArray addObjectsFromArray:[result objectForKey:@"obj"]];
                [self.tableView reloadData];
            }
        }else{
            MET_MIDDLE([result objectForKey:@"msg"]);
        }
        
        [self.tableView.footer endRefreshing];
        
    } setFailedBlock:^(NSDictionary *result) {
        [self.tableView.footer endRefreshing];
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
