//
//  SearchResultViewController.m
//  Shitan
//
//  Created by 刘敏 on 14-11-15.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "SearchResultViewController.h"
#import "UserTableViewCell.h"
#import "UserTableModel.h"
#import "PersonalInfo.h"
#import "UserRelationshipDAO.h"
#import "AccountDAO.h"
#import "HimselfViewController.h"
#import "ProfileTableViewController.h"


@interface SearchResultViewController ()<UserCellDelegate>
{
    UIStoryboard *mineStoryboard;
}

@property (nonatomic, strong) UserRelationshipDAO *dao;
@property (nonatomic, strong) AccountDAO *accDao;


@end

@implementation SearchResultViewController


- (void)initDao
{
    if (!self.dao) {
        self.dao = [[UserRelationshipDAO alloc] init];
    }
    
    if (!self.accDao) {
        self.accDao = [[AccountDAO alloc] init];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"好友搜索结果"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"好友搜索结果"];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavBarTitle:@"搜索结果"];
    
    [self initDao];
    
    [ResetFrame resetScrollView:self.tableView contentInsetWithNaviBar:YES tabBar:NO iOS7ContentInsetStatusBarHeight:-1 inidcatorInsetStatusBarHeight:-1];
    
    [self setExtraCellLineHidden:_tableView];
    
    mineStoryboard = [UIStoryboard storyboardWithName:@"MineStoryboard" bundle:nil];
    
    if ([_tableArray count] < 1) {
        [self addPromptView];
    }
}


//增加提示语句
- (void)addPromptView
{
    UILabel *titLabel = (UILabel *)[self.view viewWithTag:0x128];
    if (!titLabel) {
        titLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, MAINSCREEN.size.width, 30)];
        titLabel.textAlignment = NSTextAlignmentCenter;
        titLabel.tag = 0x128;
    }
    
    titLabel.text = @"无数据";
    [titLabel setFont:[UIFont systemFontOfSize:18.0]];
    [titLabel setTextColor:[UIColor lightGrayColor]];
    [self.tableView addSubview:titLabel];
}

//删除提示语句
- (void)removePromptView
{
    UILabel *titLabel = (UILabel *)[self.view viewWithTag:0x128];
    if (titLabel) {
        [titLabel removeFromSuperview];
    }
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
                [self searchAccountWithKey:_keyword];
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
                
                [self searchAccountWithKey:_keyword];
                
            }
            else
            {
                CLog(@"%@", [result objectForKey:@"msg"]);
            }
        } setFailedBlock:^(NSDictionary *result) {
            
            
        }];
    }
}



//搜索好友
- (void)searchAccountWithKey:(NSString *)key {
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:3];
    
    [dict setObject:key forKey:@"keyword"];
    //信息条数
    [dict setObject:[NSNumber numberWithInt:20] forKey:@"size"];
    //页数
    [dict setObject:[NSNumber numberWithInt:1] forKey:@"page"];
    
    NSString* jsonString = [STJSONSerialization toJSONData:dict];
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [requestDict setObject:jsonString forKey:@"reqStr"];
    
    //UserId
    [requestDict setObject:[AccountInfo sharedAccountInfo].userId forKey:@"userId"];
    
    
    [_accDao requestUserwithSearch:requestDict completionBlock:^(NSDictionary *result) {
        
        if ([[result objectForKey:@"code"] integerValue] == 200) {
            if ([result objectForKey:@"obj"]) {
                NSArray *userArray = [result objectForKey:@"obj"];
                if (userArray && [userArray count] > 0) {
                    self.tableArray = userArray;
                    [_tableView reloadData];
                    [self removePromptView];
                }
                else
                {
                    
                    [self addPromptView];
                }
                
            }
        }
    } setFailedBlock:^(NSDictionary *result) {
        
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
