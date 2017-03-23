//
//  WeiboFollowedViewController.m
//  Shitan
//
//  Created by 刘敏 on 14/12/4.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "WeiboFollowedViewController.h"
#import "UserRelationshipDAO.h"
#import "UserTableViewCell.h"
#import "UserTableModel.h"
#import "HimselfViewController.h"
#import "AccountDAO.h"
#import "InvitationTableViewCell.h"
#import "InvitationWeiboModel.h"
#import "ShareModel.h"
#import "UMSocial.h"

@interface WeiboFollowedViewController ()<UserCellDelegate>

@property (nonatomic, strong) UserRelationshipDAO *dao;
@property (strong, readwrite, nonatomic) AccountDAO *accDao;

@end

@implementation WeiboFollowedViewController


- (void)initDao
{
    if (!_dao) {
        self.dao = [[UserRelationshipDAO alloc] init];
    }
    
    if (!_accDao) {
        self.accDao = [[AccountDAO alloc] init];
    }
    
    _friendsArray = [[NSMutableArray alloc] init];
    
    _inviteArray = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"微博好友"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"微博好友"];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initDao];
    
    self.tableView.backgroundColor = BACKGROUND_COLOR;
    
    
    [ResetFrame resetScrollView:self.tableView contentInsetWithNaviBar:YES tabBar:NO iOS7ContentInsetStatusBarHeight:-1 inidcatorInsetStatusBarHeight:-1];
    
    [self setNavBarTitle:@"微博好友"];

    
    [self setExtraCellLineHidden:self.tableView];
    
    if (![AccountInfo sharedAccountInfo].weibotoken)
    {
        [self addPromptView];
    }
    else{
        [self requestWeibo];
    }
    
}


//增加提示语句
- (void)addPromptView
{
    UILabel *titLabel = (UILabel *)[self.view viewWithTag:0x128];
    if (!titLabel) {
        titLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, MAINSCREEN.size.width, 30)];
        titLabel.text = @"尚未绑定微博";
        [titLabel setFont:[UIFont systemFontOfSize:14.0]];
        [titLabel setTextColor:MAIN_TIME_COLOR];
        titLabel.textAlignment = NSTextAlignmentCenter;
        titLabel.tag = 0x128;
    }
    [self.tableView addSubview:titLabel];
    
    
    UIButton *findButton = (UIButton *)[self.view viewWithTag:0x256];
    if (!findButton) {
        findButton = [[UIButton alloc] initWithFrame:CGRectMake((MAINSCREEN.size.width-160)/2, 190, 160, 36)];
        [findButton setBackgroundImage:@"bg_btn_160_72.png" setSelectedBackgroundImage:@"bg_btn_160_72.png"];
        [findButton setTitle:@"绑定微博" forState:UIControlStateNormal];
        [findButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        [findButton setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
        [findButton addTarget:self action:@selector(bindButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        findButton.tag = 0x256;
    }
    [self.tableView addSubview:findButton];
}

//删除提示语句
- (void)removePromptView
{
    UILabel *titLabel = (UILabel *)[self.view viewWithTag:0x128];
    if (titLabel) {
        [titLabel removeFromSuperview];
    }
    
    UIButton *findButton = (UIButton *)[self.view viewWithTag:0x256];
    if (findButton) {
        [findButton removeFromSuperview];
    }
    
}

- (void)bindButtonTapped:(id)sender
{

    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
        
    //usid为官方微博的uid（如果希望直接静默关注（不出现选项），则在代码中添加下面的方法）
    [[UMSocialDataService defaultDataService] requestAddFollow:UMShareToSina followedUsid:@[K_WEIBO_UID] completion:nil];
        
    snsPlatform.loginClickHandler(self, [UMSocialControllerService defaultControllerService],
                                  YES, ^(UMSocialResponseEntity *response)
    {
                                      
        if (response.data)
        {
          [theAppDelegate.HUDManager showSimpleTip:@"正在授权" interval:NSNotFound];
            
          //获取微博用户名、uid、token等
          if (response.responseCode == UMSResponseCodeSuccess) {
              //获取新浪用户信息
              [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToSina completion:^(UMSocialResponseEntity *response)
               {
                   NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:3];
                   [dict setObject:[response.data objectForKey:@"access_token"] forKey:@"weiboToken"];
                   [dict setObject:[response.data objectForKey:@"uid"] forKey:@"weiboId"];
                   [dict setObject:[AccountInfo sharedAccountInfo].userId forKey:@"userId"];
                   
                   
                   NSString* jsonString = [STJSONSerialization toJSONData:dict];
                   NSMutableDictionary *requestDict = [NSMutableDictionary dictionaryWithCapacity:1];
                   [requestDict setObject:jsonString forKey:@"reqStr"];
               
                    [_accDao requestBindWeibo:requestDict completionBlock:^(NSDictionary *result) {
                        if ([[result objectForKey:@"code"] integerValue] == 200)
                        {
                            if ([result objectForKey:@"obj"])
                            {
                                [[AccountInfo sharedAccountInfo] parsAccountData:[result objectForKey:@"obj"]];
                                [self requestWeibo];
                                [self removePromptView];
                            }
                        }
                        else
                        {
                            MET_MIDDLE([result objectForKey:@"msg"]);
                        }
                    }
                               setFailedBlock:^(NSDictionary *result)
                     {
                         MET_MIDDLE([result objectForKey:@"msg"]);
                     }];
               }];
            }
            else
            {
                MET_MIDDLE(@"授权失败");
            }
        }
    });
}

- (void)requestWeibo
{
    [self.friendsArray removeAllObjects];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:1];
    [dic setObject:[AccountInfo sharedAccountInfo].userId forKey:@"followerUserId"];
    
    [_dao requestWeiboFrendsWithMyApp:dic completionBlock:^(NSDictionary *result) {
        
        if ([[result objectForKey:@"code"] integerValue] == 200) {
            if ([result objectForKey:@"obj"]) {
                NSArray *userArray = [result objectForKey:@"obj"];
                if (userArray && [userArray count] > 0) {
                    [self.friendsArray addObjectsFromArray:userArray];
                    
                    [self requestInviteWeiboFriends];
                    [_tableView reloadData];
                }
            }
        }
        else{
            MET_MIDDLE([result objectForKey:@"msg"]);
        }
    } setFailedBlock:^(NSDictionary *result) {
        
    }];
}


//邀请微博好友
- (void)requestInviteWeiboFriends
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:1];
    [dic setObject:[AccountInfo sharedAccountInfo].userId forKey:@"followedUserId"];
    
    [_dao requestInviteFrendsWithWeibo:dic completionBlock:^(NSDictionary *result) {
        
        [theAppDelegate.HUDManager hideHUD];
        
        if ([[result objectForKey:@"code"] integerValue] == 200) {
            if ([result objectForKey:@"obj"]) {
                NSArray *userArray = [result objectForKey:@"obj"];
                if (userArray && [userArray count] > 0) {
                    [self.inviteArray addObjectsFromArray:userArray];
                    [_tableView reloadData];
                }
            }
            
        }
        else{
            
            if ([[result objectForKey:@"msg"] isEqualToString:@"请先绑定微博"]) {
                AlertWithTitleAndMessageAndUnits(nil, @"您没有绑定微博，是否继续绑定微博", self, @"绑定", nil);
            }
            
        }
    } setFailedBlock:^(NSDictionary *result) {
        
    }];

}



//清除多余分割线
- (void)setExtraCellLineHidden:(UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([self.friendsArray count] > 0) {
        return 2;
    }
    
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 54;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (_friendsArray.count > 0)
    {
        if (section == 0) {
            return _friendsArray.count;
        }
    }
    


    return _inviteArray.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PersonalInfo *pInfo = nil;
    
    if(indexPath.section == 0)
    {
        UserTableViewCell *cell = [UserTableModel findCellWithTableView:tableView];
        pInfo = [[PersonalInfo alloc] initWithParsData:[self.friendsArray objectAtIndex:indexPath.row]];
        [cell setCellWithRelationshipWeiboCellInfo:pInfo setRow:indexPath.row];
        
        cell.delegate = self;
        return cell;
    }
    else{
        InvitationTableViewCell *cell = [InvitationWeiboModel findCellWithTableView:tableView];
        pInfo = [[PersonalInfo alloc] initWithParsData:[self.inviteArray objectAtIndex:indexPath.row]];
        cell.controller = self;
        [cell setCellWithCellInfo:pInfo setRow:indexPath.row];
        
        return cell;
    }
    
    return nil;
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if (_friendsArray.count > 0)
    {
        if (indexPath.section == 0) {
            UIStoryboard *MineStoryboard = [UIStoryboard storyboardWithName:@"MineStoryboard" bundle:nil];
            HimselfViewController *hVC = [MineStoryboard instantiateViewControllerWithIdentifier:@"HimselfViewController"];
            
            PersonalInfo *pInfo = [[PersonalInfo alloc] initWithParsData:[_friendsArray objectAtIndex:indexPath.row]];
            
            hVC.respondentUserId = pInfo.followedUserId;
            hVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:hVC animated:YES];
        }
    }
    

    
}


#pragma mark UserCellDelegate
- (void)followButtonWithCellwithRow:(NSInteger)row
{
    PersonalInfo *pInfo = [[PersonalInfo alloc] initWithParsData:[_friendsArray objectAtIndex:row]];
    
    if (pInfo.hasFollow == 1)
    {
        //取消关注
        NSMutableDictionary *encapsulateData = [[NSMutableDictionary alloc] initWithCapacity:2];
        
        [encapsulateData setObject:[AccountInfo sharedAccountInfo].userId forKey:@"followerUserId"];
        [encapsulateData setObject:pInfo.followedUserId forKey:@"followedUserId"];
        
        //取消关注
        [_dao requestUserUnFollow:encapsulateData completionBlock:^(NSDictionary *result) {
            if ([[result objectForKey:@"code"] integerValue] == 200)
            {
                //重新获取
                [AccountInfo sharedAccountInfo].followedCount--;
                [self requestWeibo];
            }
            
        } setFailedBlock:^(NSDictionary *result) {
            
        }];
    }
    else if (pInfo.hasFollow == 0)
    {
        //关注好友
        NSMutableDictionary *encapsulateData = [[NSMutableDictionary alloc] initWithCapacity:2];
        
        
        [encapsulateData setObject:[AccountInfo sharedAccountInfo].userId forKey:@"followerUserId"];
        [encapsulateData setObject:pInfo.followedUserId forKey:@"followedUserId"];
        
        
        
        [_dao requestUserFollow:encapsulateData completionBlock:^(NSDictionary *result) {
            if ([[result objectForKey:@"code"] integerValue] == 200)
            {
                //重新获取
                [AccountInfo sharedAccountInfo].followedCount++;
                
                [self requestWeibo];
                
            }
            else
            {
                CLog(@"%@", [result objectForKey:@"msg"]);
            }
        } setFailedBlock:^(NSDictionary *result) {
            
            
        }];
    }
}


//发送微博邀请
- (void)sendInvitationWeibo:(NSInteger )row
{
    PersonalInfo *pInfo = [[PersonalInfo alloc] initWithParsData:[self.inviteArray objectAtIndex:row]];
    
    [[ShareModel getInstance] weiboInvitation:pInfo.nickname];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
