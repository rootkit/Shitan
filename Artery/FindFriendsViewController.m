//
//  FindFriendsViewController.m
//  Shitan
//
//  Created by Jia HongCHI on 14-10-4.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "FindFriendsViewController.h"
#import "SearchTableViewCell.h"
#import "AddFriendModel.h"
#import "AddressBookViewController.h"
#import "AccountDAO.h"
#import "SearchResultViewController.h"
#import "WeiboFollowedViewController.h"
#import "UserRelationshipDAO.h"
#import "TalentShowViewController.h"
#import "ShareModel.h"


@interface FindFriendsViewController ()<SearchTableViewCellDelegate>

@property (nonatomic, strong) NSArray* tableArray;
@property (nonatomic, strong, readonly) UIStoryboard *mStoryboard;
@property (nonatomic, strong) AccountDAO *dao;
@property (nonatomic, strong) UserRelationshipDAO *userDao;

@property (nonatomic, strong) NSArray *openArray;

@end

@implementation FindFriendsViewController



- (void)initDao
{
    if (!_dao) {
        self.dao = [[AccountDAO alloc] init];
    }
    
    if (!_userDao) {
        self.userDao = [[UserRelationshipDAO alloc] init];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"添加好友"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"添加好友"];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.hidesBottomBarWhenPushed = YES;
    
    [self initDao];
    self.tableView.backgroundColor = BACKGROUND_COLOR;
    [ResetFrame resetScrollView:self.tableView contentInsetWithNaviBar:YES tabBar:NO iOS7ContentInsetStatusBarHeight:-1 inidcatorInsetStatusBarHeight:-1];

    
    [self setNavBarTitle:@"添加好友"];
    
    _mStoryboard = [UIStoryboard storyboardWithName:@"MineStoryboard" bundle:nil];

}


//判断授权菜单个数
- (NSUInteger)numberOfSectionsSecord{
    NSUInteger i = 1;
    
    NSMutableArray *temp = [[NSMutableArray alloc] initWithCapacity:0];
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]])
    {
        i++;
        [temp addObject:@"mqq"];
    }
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"sinaweibo://"]])
    {
        i++;
        [temp addObject:@"weibo"];
    }
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"wechat://"]])
    {
        i++;
        [temp addObject:@"WeChat"];
    }
    
    self.openArray = temp;
    
    return i;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else if (section == 1)
    {
        return [self numberOfSectionsSecord];
    }
    else
        return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (section == 0) {
        SearchTableViewCell *cell = [AddFriendModel findCellWithTableView:tableView];
        cell.delegate = self;
        return cell;
    }
    else
    {
    
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
        
        
        if (section == 1){
            if (row == 0) {
                cell.imageView.image = [UIImage imageNamed:@"Share_binding_address.png"];
                cell.textLabel.text = @"手机通讯录";
            }
            else{
                NSString *key = [_openArray objectAtIndex:row-1];
                if ([key isEqualToString:@"mqq"]) {
                    cell.imageView.image = [UIImage imageNamed:@"Share_binding_QQ.png"];
                    cell.textLabel.text = @"邀请QQ好友";
                }
                if ([key isEqualToString:@"weibo"])
                {
                    cell.imageView.image = [UIImage imageNamed:@"Share_binding_weibo.png"];
                    cell.textLabel.text = @"微博好友";
                }
                if ([key isEqualToString:@"WeChat"])
                {
                    cell.imageView.image = [UIImage imageNamed:@"Share_binding_wechat.png"];
                    cell.textLabel.text = @"邀请微信好友";
                }
            }
        }
        else if (section == 2)
        {
            cell.imageView.image = [UIImage imageNamed:@"Share_city_talent.png"];
            cell.textLabel.text = @"同城达人推荐";
        }

        cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
   
    return nil;
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.section == 0) {
        //搜索用户
        
    }
    else if(indexPath.section == 1)
    {
        if (indexPath.row == 0) {
            AddressBookViewController *addVC = [_mStoryboard instantiateViewControllerWithIdentifier:@"AddressBookViewController"];
            [self.navigationController pushViewController:addVC animated:YES];
        }
        else{
            NSString *key = [_openArray objectAtIndex:indexPath.row-1];
            if ([key isEqualToString:@"mqq"]) {
                [[ShareModel getInstance] qqInvitation];;
            }
            if ([key isEqualToString:@"weibo"])
            {
                //跳转到微博好友界面
                WeiboFollowedViewController *weiboVC = [_mStoryboard instantiateViewControllerWithIdentifier:@"WeiboFollowedViewController"];
                [self.navigationController pushViewController:weiboVC animated:YES];
            }
            if ([key isEqualToString:@"WeChat"])
            {
                [[ShareModel getInstance] wechatFriendsInvitation];
            }
        }
    }
    else
    {
        TalentShowViewController *tVC = [_mStoryboard instantiateViewControllerWithIdentifier:@"TalentShowViewController"];
        
        [self.navigationController pushViewController:tVC animated:YES];
    }
}


//搜索
#pragma mark SearchTableViewCellDelegate
- (void)searchContentWithField:(NSString *)text{
    CLog(@"%@", text);
    if ([text length] > 0) {
        [self searchAccountWithKey:text];
    }
}

#pragma mark - Seachr and add Friends
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

    
    [_dao requestUserwithSearch:requestDict completionBlock:^(NSDictionary *result) {
        
        if ([[result objectForKey:@"code"] integerValue] == 200) {
            if ([result objectForKey:@"obj"]) {
                NSArray *userArray = [result objectForKey:@"obj"];
                
                SearchResultViewController * eVC = [_mStoryboard instantiateViewControllerWithIdentifier:@"SearchResultViewController"];
                eVC.tableArray = userArray;
                eVC.keyword = key;
                [self.navigationController pushViewController:eVC animated:YES];
                
            }
        }
        else
        {
            CLog(@"%@", [result objectForKey:@"msg"]);
            MET_MIDDLE(@"未搜索到相关用户");
        }
    } setFailedBlock:^(NSDictionary *result) {
        
    }];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView == self.tableView)
    {
        CLog(@"Hello");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"keyboardHiddenWithAccountField" object:nil];
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
