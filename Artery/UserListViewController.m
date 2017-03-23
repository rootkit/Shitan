//
//  UserListViewController.m
//  Shitan
//
//  Created by Jia HongCHI on 14-10-4.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "UserListViewController.h"
#import "UserRelationshipDAO.h"
#import "UserTableModel.h"
#import "UserTableViewCell.h"
#import "PersonalInfo.h"
#import "MJRefresh.h"
#import "HimselfViewController.h"
#import "ProfileTableViewController.h"

@interface UserListViewController () <UserCellDelegate>
{
    UIStoryboard *board;
}

@property (strong, readwrite, nonatomic) UserRelationshipDAO *dao;
@property (assign, nonatomic) NSInteger mPage;
@property (strong, nonatomic) NSMutableArray *tableArray;

@property (nonatomic, assign) BOOL isMore;
@property (nonatomic, assign) NSUInteger topId;

@end

@implementation UserListViewController

/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    [self.tableView.header beginRefreshing];
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    self.tableView.footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    self.isMore = NO;
    
    _mPage = 1;
    
    if(_userListType == PraiseList)
    {
        [self praiseList];
    }
    else{
        [self requestUserList:_mPage];
    }
}


// 上拉获取更多
- (void)footerRereshing
{
    self.isMore = YES;
    _mPage ++;
    
    if(_userListType == PraiseList)
    {
        [self praiseList];
    }
    else{
        [self requestUserList:_mPage];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_userListType == FansList) {
        [MobClick beginLogPageView:@"TA的粉丝列表"];

    }
    else if(_userListType == FollowList){
        [MobClick beginLogPageView:@"TA的关注列表"];
    }
    else if(_userListType == PraiseList){
        [MobClick beginLogPageView:@"赞列表"];
    }

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_userListType == FansList) {
        [MobClick endLogPageView:@"TA的粉丝列表"];
        
    }
    else if(_userListType == FollowList){
        [MobClick endLogPageView:@"TA的关注列表"];
    }
    else if(_userListType == PraiseList){
        [MobClick endLogPageView:@"赞列表"];
    }
}



- (void)initDao
{
    if (!self.dao) {
        self.dao = [[UserRelationshipDAO alloc] init];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [ResetFrame resetScrollView:self.tableView contentInsetWithNaviBar:YES tabBar:NO iOS7ContentInsetStatusBarHeight:-1 inidcatorInsetStatusBarHeight:-1];
    
    _isMore = NO;
    
    //初始化Dao
    [self initDao];
    _tableArray = [[NSMutableArray alloc] initWithCapacity:0];
    _mPage = 1;
    
    if (_userListType == FansList) {
        [self setNavBarTitle:@"TA的粉丝列表"];
        
        [self requestUserList:_mPage];
    }
    else if(_userListType == FollowList){
        
        [self setNavBarTitle:@"TA的关注列表"];
        
        [self requestUserList:_mPage];
    }
    else if(_userListType == PraiseList){
        [self setNavBarTitle:@"赞列表"];
        [self praiseList];
    }
    
    // 集成刷新控件
    [self setupRefresh];
    
    
    
    [self  setExtraCellLineHidden:_tableView];
    
    board = [UIStoryboard storyboardWithName:@"MineStoryboard" bundle:nil];
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
    PersonalInfo *pInfo = [[PersonalInfo alloc] initWithParsData:[_tableArray objectAtIndex:indexPath.row]];
    UserTableViewCell *cell = [UserTableModel findCellWithTableView:tableView];
    cell.delegate = self;
    
    if (_userListType == FansList || _userListType == PraiseList) {
        //粉丝列表
        [cell setCellWithRelationshipCellInfo:pInfo setRow:indexPath.row isFocus:NO];
        
    }
    else{
        //关注列表
        [cell setCellWithRelationshipCellInfo:pInfo setRow:indexPath.row isFocus:YES];
    }
    return cell;
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PersonalInfo *pInfo = [[PersonalInfo alloc] initWithParsData:[_tableArray objectAtIndex:indexPath.row]];
    
    NSString *tempId = nil;
    
    if (_userListType == FansList) {
        tempId = pInfo.followerUserId;
    }else if (_userListType == FollowList){
        tempId = pInfo.followedUserId;
    }
    else if(_userListType == PraiseList)
    {
        tempId = pInfo.userId;
    }
    
    if (![tempId isEqualToString:[AccountInfo sharedAccountInfo].userId]){
        HimselfViewController *hVC = [board instantiateViewControllerWithIdentifier:@"HimselfViewController"];
        hVC.respondentUserId = tempId;
        hVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:hVC animated:YES];
    }else{
        ProfileTableViewController *hVC = [[ProfileTableViewController alloc] init];
        hVC.isFromTabbar = NO;
        [self.navigationController pushViewController:hVC animated:YES];
    }
}


#pragma mark - request

// 获取用户列表
- (void)requestUserList:(NSInteger)page
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:4];
    [dict setObject:[AccountInfo sharedAccountInfo].userId forKey:@"viewUserId"];
    
    if (_userListType == FansList)
    {
        if (!_respondentUserId) {
            return;
        }
        [dict setObject:_respondentUserId forKey:@"followedUserId"];
    }
    else
    {
        if (!_respondentUserId) {
            return;
        }
        [dict setObject:_respondentUserId forKey:@"followerUserId"];
    }
    
    
    [dict setObject:@"20" forKey:@"size"];
    [dict setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    
    //获取粉丝列表
    if (_userListType == FansList) {
        //获取粉丝列表
         [_dao requestUserFollowers:dict completionBlock:^(NSDictionary *result) {
             
             if ([[result objectForKey:@"code"] integerValue] == 200)
             {
                 
                 if ([result objectForKey:@"obj"]) {
                     if (_mPage == 1) {
                         //如果请求的是第一页，则初始化array
                         [_tableArray removeAllObjects];
                     }
                     [_tableArray addObjectsFromArray:[result objectForKey:@"obj"]];
                 }
                 
                 [_tableView reloadData];
             }
             else
             {
                 MET_MIDDLE([result objectForKey:@"msg"]);
             }
             
         } setFailedBlock:^(NSDictionary *result) {

         }];
    }
    else
    {
        //获取关注列表
        [_dao requestUserFolloweds:dict completionBlock:^(NSDictionary *result) {
            
            if ([[result objectForKey:@"code"] integerValue] == 200)
            {
                
                if ([result objectForKey:@"obj"]) {
                    if (_mPage == 1) {
                        //如果请求的是第一页，则初始化array
                        [_tableArray removeAllObjects];
                    }
                    [_tableArray addObjectsFromArray:[result objectForKey:@"obj"]];
                }
                [_tableView reloadData];
            }
            else
            {
                MET_MIDDLE([result objectForKey:@"msg"]);
                
            }
            
        } setFailedBlock:^(NSDictionary *result) {

        }];
    }
    
    [self.tableView.header endRefreshing];
    [self.tableView.footer endRefreshing];
}


//获取赞列表
- (void)praiseList
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[AccountInfo sharedAccountInfo].userId forKey:@"userId"];

    [dict setObject:_imageId forKey:@"imgId"];
    [dict setObject:@"20" forKey:@"size"];
    
    //该页最大的ID
    if (self.isMore) {
        
        CLog(@"%lu~~tpid",(unsigned long)self.topId);
        
        [dict setObject:[NSNumber numberWithInteger:self.topId] forKey:@"topId"];
        
    }
    
    NSString* jsonString = [STJSONSerialization toJSONData:dict];
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [requestDict setObject:jsonString forKey:@"reqStr"];

    
    [_dao requestPraiseList:requestDict completionBlock:^(NSDictionary *result) {
        CLog(@"%ld~~",(long)[[result objectForKey:@"code"] integerValue]);
        
        
        
        if ([[result objectForKey:@"code"] integerValue] == 200 )
        {
            NSArray *temp = result.obj;
            if (temp) {
                if (!self.isMore) {
                    [_tableArray removeAllObjects];
                }
                
                if ([temp isKindOfClass:[NSArray class]] && [temp count] > 0) {
                    self.topId = [[[temp objectAtIndex:[temp count]-1] objectForKey:@"id"]integerValue] - 1;
                    
                    [_tableArray addObjectsFromArray:temp];

                }

            }
            [self.tableView reloadData];
            
        }
        else
        {
            
            if (!self.isMore) {
                [_tableArray removeAllObjects];
                
                //重载
                [self.tableView reloadData];
                
            }
            
            //MET_MIDDLE([result objectForKey:@"msg"])
            
        }
    } setFailedBlock:^(NSDictionary *result) {
        
    }];
    
    [self.tableView.header endRefreshing];
    [self.tableView.footer endRefreshing];
}


#pragma mark UserCellDelegate
- (void)followButtonWithCellwithRow:(NSInteger)row
{
    PersonalInfo *pInfo = [[PersonalInfo alloc] initWithParsData:[_tableArray objectAtIndex:row]];
    
    self.topId = 99999;
    
    NSMutableDictionary *encapsulateData = [[NSMutableDictionary alloc] initWithCapacity:2];
    
    if (_userListType == FansList) {
        //粉丝列表中，未关注的好友，
        [encapsulateData setObject:[AccountInfo sharedAccountInfo].userId forKey:@"followerUserId"];
        [encapsulateData setObject:pInfo.followerUserId forKey:@"followedUserId"];
    }
    else if (_userListType == FollowList){
        [encapsulateData setObject:pInfo.followedUserId forKey:@"followedUserId"];
        [encapsulateData setObject:[AccountInfo sharedAccountInfo].userId forKey:@"followerUserId"];
    }
    else if(_userListType == PraiseList)
    {
        [encapsulateData setObject:[AccountInfo sharedAccountInfo].userId forKey:@"followerUserId"];
        [encapsulateData setObject:pInfo.userId forKey:@"followedUserId"];
    }

    
    //已关注
    if (pInfo.hasFollow == 1)
    {
        
        //取消关注
        [_dao requestUserUnFollow:encapsulateData completionBlock:^(NSDictionary *result) {
            if ([[result objectForKey:@"code"] integerValue] == 200)
            {
                //重新获取
                [AccountInfo sharedAccountInfo].followedCount--;
                _mPage = 1;
                [self.tableArray removeAllObjects];
                [self.tableView reloadData];
                
                if(_userListType == PraiseList)
                {
                    [self praiseList];
                }
                else{
                    [self requestUserList:_mPage];
                }
            }
            
        } setFailedBlock:^(NSDictionary *result) {
            
            
        }];
    }
    else if (pInfo.hasFollow == 0)
    {
        [_dao requestUserFollow:encapsulateData completionBlock:^(NSDictionary *result) {
            if ([[result objectForKey:@"code"] integerValue] == 200)
            {
                //重新获取
                [AccountInfo sharedAccountInfo].followedCount++;
                _mPage = 1;
                [self.tableArray removeAllObjects];
                [self.tableView reloadData];
                
                
                if(_userListType == PraiseList)
                {
                    [self praiseList];
                }
                else{
                    [self requestUserList:_mPage];
                }
                
            }
            else
            {
                CLog(@"%@", [result objectForKey:@"msg"]);
            }
        } setFailedBlock:^(NSDictionary *result) {
            
            
        }];
    }
}

#pragma mark - didReceiveMemoryWarning
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
