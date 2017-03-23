//
//  ProfileTableViewController.m
//  Shitan
//
//  Created by Avalon on 15/4/25.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//


#import "ProfileTableViewController.h"
#import "PersonalProfileViewController.h"
#import "UserListViewController.h"
#import "UserRelationshipDAO.h"
#import "PicTableViewController.h"
#import "FavCollectionViewController.h"
#import "MJRefresh.h"
#import "CouponsDAO.h"
#import "PersonalTableViewCell.h"
#import "PersonalModelCell.h"
#import "FindFriendsViewController.h"



@interface ProfileTableViewController () <UITableViewDelegate,UITableViewDataSource, PersonalTableViewCellDelegate>
{
    BOOL    firstFAV;
}

@property (nonatomic, strong) UserRelationshipDAO *userDao;
@property (nonatomic, strong) UIButton *msgButton;  //消息按钮

@property (nonatomic, strong) CouponsDAO *dao;

@end

@implementation ProfileTableViewController


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"个人主页"];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [_settingTabelView reloadData];
    

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"个人主页"];
    [self headerRereshing];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initDao];
    [self setNavBarTitle:@"我的"];
    
    //tabbleView
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _settingTabelView = tableView;
    _settingTabelView.delegate = self;
    _settingTabelView.dataSource = self;
    [self.view addSubview:_settingTabelView];
    [ResetFrame resetScrollView:_settingTabelView contentInsetWithNaviBar:YES tabBar:NO iOS7ContentInsetStatusBarHeight:-1 inidcatorInsetStatusBarHeight:-1];
    
    //获取用户信息
    [self requestUserInfo];

    [self setupRefresh];
}

/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    self.settingTabelView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];

}


#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    //获取用户信息
    [self requestUserInfo];
}

- (void)initDao{
    
    if (self.userDao == nil) {
        self.userDao = [[UserRelationshipDAO alloc]init];
    }
    
    if (!_dao) {
        _dao = [[CouponsDAO alloc] init];
    }
}

#pragma mark 网络请求
// 获取用户信息
- (void)requestUserInfo
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:2];
    
    [dict setObject:[AccountInfo sharedAccountInfo].userId forKey:@"userId"];
    [dict setObject:@"true" forKey:@"statistics"];
    
    [_userDao requestUserInfo:dict
              completionBlock:^(NSDictionary *result) {
                  if (result.code == 200) {
                      //更新账户信息
                      [[AccountInfo sharedAccountInfo] parsAccountData:[result objectForKey:@"obj"]];
                      
                      //刷新个人资料
                      [_settingTabelView reloadData];
                      
                      [_settingTabelView.header endRefreshing];                      
                  }
                  else
                  {
                      MET_MIDDLE([result objectForKey:@"msg"]);
                      [_settingTabelView.header endRefreshing];
                  }
              }
               setFailedBlock:^(NSDictionary *result) {
                   [_settingTabelView.header endRefreshing];
               }];
    
}

#pragma mark - 导航栏按钮响应事件
//编辑个人资料
- (void)editorButonTouch
{
    //编辑个人资料
    PersonalProfileViewController *perProVC = (PersonalProfileViewController *)[StoryBoardUtilities viewControllerForStoryboardName:@"MineStoryboard" class:[PersonalProfileViewController class]];
    perProVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:perProVC animated:YES];
}

//打开粉丝列表
- (void)openFansList
{
    UserListViewController *userListVC = (UserListViewController *)[StoryBoardUtilities viewControllerForStoryboardName:@"MineStoryboard" class:[UserListViewController class]];
    
    userListVC.respondentUserId = [AccountInfo sharedAccountInfo].userId;
    userListVC.hidesBottomBarWhenPushed = YES;
    userListVC.userListType = FansList;
    [self.navigationController pushViewController:userListVC animated:YES];
}

//打开关注列表
- (void)openAttentionList{
    UserListViewController *userListVC = (UserListViewController *)[StoryBoardUtilities viewControllerForStoryboardName:@"MineStoryboard" class:[UserListViewController class]];
    
    userListVC.respondentUserId = [AccountInfo sharedAccountInfo].userId;
    userListVC.hidesBottomBarWhenPushed = YES;
    userListVC.userListType = FollowList;
    [self.navigationController pushViewController:userListVC animated:YES];
}


#pragma mark - tabbleViewSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
 
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"reuseCell";
    if (indexPath.section == 0) {
        PersonalTableViewCell *cell = [PersonalModelCell findCellWithTableView:tableView];
        [cell updateData];
        cell.delegate = self;
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        
    }

    if (indexPath.section == 1){
//        cell.imageView.image = [UIImage imageNamed:@"icon_order.png"];
        cell.textLabel.text = @"添加好友";
    }

    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 150;
    }
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.section == 1) {
        
        FindFriendsViewController *findFriendsVC = (FindFriendsViewController *)[StoryBoardUtilities viewControllerForStoryboardName:@"MineStoryboard" class:[FindFriendsViewController class]];
        findFriendsVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:findFriendsVC animated:YES];

    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20;
}


#pragma mark - personalTableViewCell的代理
- (void)personalTableViewCell:(PersonalTableViewCell *)mycell bTnIndex:(NSInteger) index{
    switch (index) {
        case 0:
            //图片个数
        {
            PicTableViewController *picVC = [[PicTableViewController alloc] init];
            picVC.navigationItem.title = @"我的美食日记";
            picVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:picVC animated:YES];
        }
            break;
            
        case 1:
        {
            //粉丝
            if([AccountInfo sharedAccountInfo].fansCount > 0){
                [self openFansList];
            }
        }
            break;
            
        case 2:
        {
            //关注
            if([AccountInfo sharedAccountInfo].followedCount > 0){
                [self openAttentionList];
            }
        }
            break;
        case 3:
        {
            //编辑
            [self editorButonTouch];
        }
            break;
            
            
        default:
            break;
    }
}


@end