//
//  SettingViewController.m
//  Shitan
//
//  Created by 刘敏 on 14-9-16.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "SettingViewController.h"
#import "LXActionSheet.h"
#import "ChangePswViewController.h"
#import "AccountDAO.h"
#import "AboutViewController.h"
#import "ShareModel.h"
#import "SGActionView.h"
#import "AboutViewController.h"
#import "UMSocial.h"
#import "RestPasswordViewController.h"
#import "DraftBoxViewController.h"
#import "AdviceViewController.h"
#import "JSBadgeView.h"
#import <SDWebImage/SDImageCache.h>
#import "MBProgressHUD+Add.h"
#import "FindFriendsViewController.h"


@interface SettingViewController ()<LXActionSheetDelegate, UMSocialUIDelegate, UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate>
{
    UIStoryboard *board;
}

@property (strong, nonatomic, readwrite) LXActionSheet *actionSheet;
@property (strong, readwrite, nonatomic) AccountDAO *dao;

@property (strong, nonatomic) NSArray *openArray;    //存储第三方数据


@end

@implementation SettingViewController

- (void)initDao
{
    if (!_dao) {
        self.dao = [[AccountDAO alloc] init];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"设置"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"设置"];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initDao];
    
    [self setNavBarTitle:@"设置"];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN.size.width, MAINSCREEN.size.height+20) style:UITableViewStyleGrouped];
    _tableView = tableView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [ResetFrame resetScrollView:self.tableView contentInsetWithNaviBar:YES tabBar:NO iOS7ContentInsetStatusBarHeight:-1 inidcatorInsetStatusBarHeight:-1];
    

    board = [UIStoryboard storyboardWithName:@"MineStoryboard" bundle:nil];
}


//判断授权菜单个数
- (NSUInteger)numberOfSectionsSecord{
    NSUInteger i = 1;
    
    NSMutableArray *temp = [[NSMutableArray alloc] initWithCapacity:0];
    
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
    if (!theAppDelegate.isLogin)
    {
        return 3;
    }
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0){
        return [self numberOfSectionsSecord];
    }
    else if (section == 1){
        return 2;
    }
    else if (section == 2){
        return 3;

    }
    
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"账号绑定";
    }else{
        return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"settingsCell";
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    cell.detailTextLabel.font = [UIFont systemFontOfSize:16.0f];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0) {
            cell.imageView.image = [UIImage imageNamed:@"Share_binding_phone.png"];
            cell.textLabel.text = @"手机号";
            
            if ([AccountInfo sharedAccountInfo].mobile)
            {
                cell.detailTextLabel.text = [AccountInfo sharedAccountInfo].mobile;
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            else
            {
                cell.detailTextLabel.text = @"立即绑定";
                cell.detailTextLabel.textColor = MAIN_COLOR;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }

        }
        else{
            NSString *key = [_openArray objectAtIndex:indexPath.row-1];
            if ([key isEqualToString:@"WeChat"]) {
                cell.imageView.image = [UIImage imageNamed:@"Share_binding_wechat.png"];
                cell.textLabel.text = @"微信";
                cell.accessoryType = UITableViewCellAccessoryNone;
                
                if ([AccountInfo sharedAccountInfo].weixintoken)
                {
                    cell.detailTextLabel.text = @"已绑定";
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
                else
                {
                    cell.detailTextLabel.text = @"立即绑定";
                    cell.detailTextLabel.textColor = MAIN_COLOR;
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
            }
        }
    }
    else if(indexPath.section == 1){
        switch (indexPath.row) {
            case 0:
            {
                cell.textLabel.text = @"草稿箱";
                
                //获取草稿箱信息条数
                NSString *path = NSTemporaryDirectory();
                NSString *plistPath = [NSString stringWithFormat:@"%@Draft", path];
                NSString *filename = [plistPath stringByAppendingPathComponent:@"draftData.plist"];   //获取路径
                
                NSArray *array = [[NSArray alloc] initWithContentsOfFile:filename];
                
                if([array count] > 0)
                {
                    JSBadgeView *badgeView = [[JSBadgeView alloc] initWithParentView:cell.contentView alignment:JSBadgeViewAlignmentTopRight badgePointSize:26.0];
                    
                    //为NO即显示数字，YES不显示数字
                    [badgeView setIsPointBadge:NO];
                    badgeView.badgeOverlayColor = [UIColor clearColor];
                    badgeView.badgeStrokeColor = [UIColor clearColor];
                    badgeView.badgeShadowColor = [UIColor clearColor];
                    badgeView.badgeTextColor = [UIColor whiteColor];
                    [badgeView setBadgePositionAdjustment:CGPointMake(-10, 21)];
                    [badgeView setBadgeText:[NSString stringWithFormat:@"%lu", (unsigned long)array.count]];
                    
                    BOOL isOpenDraft = [[NSUserDefaults standardUserDefaults] boolForKey:@"ISOPENDRAFT"];
                    if (!isOpenDraft) {
                        //红色
                        badgeView.badgeBackgroundColor = MAIN_COLOR;
                    }
                    else{
                        //灰色
                        badgeView.badgeBackgroundColor = [UIColor lightGrayColor];
                    }
                    
                    [cell.contentView addSubview:badgeView];
                }
            }
                
                break;
                case 1:
            {
                cell.textLabel.text = @"清空缓存";
                
                float tmpSize = [[SDImageCache sharedImageCache] checkTmpSize];
                cell.detailTextLabel.text = tmpSize >= 1 ? [NSString stringWithFormat:@"%.2fM",tmpSize] : [NSString stringWithFormat:@"%.2fK",tmpSize * 1024];
            }
                break;
                
            default:
                break;
        }
    }
    else if(indexPath.section == 2){
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"给我们建议";
                break;
            case 1:
                cell.textLabel.text = @"评分鼓励";
                break;
            case 2:
                cell.textLabel.text = @"关于我们";
                break;
            default:
                break;
        }
    }
    else{
        cell.textLabel.text = @"退出登录";
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0)
    {
        
        if (!theAppDelegate.isLogin)
        {
            STLoginViewController *loginVC = CREATCONTROLLER(STLoginViewController);
            STNavigationController *nc = [[STNavigationController alloc] initWithRootViewController:loginVC];
            nc.view.layer.shadowColor = [UIColor blackColor].CGColor;
            nc.view.layer.shadowOffset = CGSizeMake(-3.5, 0);
            nc.view.layer.shadowOpacity = 0.2;
            
            [self presentViewController:nc animated:YES completion:nil];
            
            return;
        }
        
        
        if (indexPath.row == 0) {
            if (![AccountInfo sharedAccountInfo].mobile)
            {
                //绑定手机
                UIStoryboard *mStoryboard = [UIStoryboard storyboardWithName:@"LoginStoryboard" bundle:nil];
                RestPasswordViewController *hVC = [mStoryboard instantiateViewControllerWithIdentifier:@"RestPasswordViewController"];
                hVC.phoneType = STBindingMobileType;
                
                [self.navigationController pushViewController:hVC animated:YES];
            }
            
        }
        else{
            NSString *key = [_openArray objectAtIndex:indexPath.row-1];
            if ([key isEqualToString:@"WeChat"])
            {
                [self detectionWechat];
            }
        }
    }
    if (indexPath.section == 1) {
        if(indexPath.row == 0)
        {
            if (!theAppDelegate.isLogin)
            {
                STLoginViewController *loginVC = CREATCONTROLLER(STLoginViewController);
                STNavigationController *nc = [[STNavigationController alloc] initWithRootViewController:loginVC];
                nc.view.layer.shadowColor = [UIColor blackColor].CGColor;
                nc.view.layer.shadowOffset = CGSizeMake(-3.5, 0);
                nc.view.layer.shadowOpacity = 0.2;
                
                [self presentViewController:nc animated:YES completion:nil];
                
                return;
            }
            
            //草稿箱
            DraftBoxViewController *dVC = (DraftBoxViewController *)[StoryBoardUtilities viewControllerForStoryboardName:@"Setting" class:[DraftBoxViewController class]];
            [self.navigationController pushViewController:dVC animated:YES];
        }
        else if(indexPath.row == 1)
        {
            AlertWithTitleAndMessageAndUnits(nil, @"确定要清除缓存吗？", self, @"确定", nil);
        }
        
        
    }
    if (indexPath.section == 2)
    {
        switch (indexPath.row) {
            case 0:
            {
                if (!theAppDelegate.isLogin)
                {
                    STLoginViewController *loginVC = CREATCONTROLLER(STLoginViewController);
                    STNavigationController *nc = [[STNavigationController alloc] initWithRootViewController:loginVC];
                    nc.view.layer.shadowColor = [UIColor blackColor].CGColor;
                    nc.view.layer.shadowOffset = CGSizeMake(-3.5, 0);
                    nc.view.layer.shadowOpacity = 0.2;
                    
                    [self presentViewController:nc animated:YES completion:nil];
                    
                    return;
                }
                
                AdviceViewController *aVC = (AdviceViewController *)[StoryBoardUtilities viewControllerForStoryboardName:@"Setting" class:[AdviceViewController class]];
                [self.navigationController pushViewController:aVC animated:YES];
            }
                break;
                
            case 1:
                [self evaluateScore];
                break;
            case 2:{
                //关于我们
                AboutViewController *aVC = (AboutViewController *)[StoryBoardUtilities viewControllerForStoryboardName:@"Setting" class:[AboutViewController class]];
                [self.navigationController pushViewController:aVC animated:YES];
            }
                break;
                
            default:
                break;
        }
    }
    else if (indexPath.section == 3)
    {
        _actionSheet = [[LXActionSheet alloc] initWithTitle:@"是否要退出当前账号？" delegate:self cancelButtonTitle:@"否" destructiveButtonTitle:nil otherButtonTitles:@[@"退出当前账号"]];
        _actionSheet.tag = 101;
        [_actionSheet showInView:self.view];
    }
}

//评分
- (void)evaluateScore{
    
    NSString *evaluateString = nil;
    
    if (isIOS7) {
        evaluateString = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id945646691"];
    }
    else{
        evaluateString = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=945646691"];
    }
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:evaluateString]];
}


#pragma mark - LXActionSheetDelegate
- (void)actionSheet:(LXActionSheet *)mActionSheet didClickOnButtonIndex:(int)buttonIndex
{
    if (mActionSheet.tag == 101) {
        switch (buttonIndex) {
            case 0:
                [theAppDelegate loginOut];
                break;
                
            default:
                break;
        }
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
            [MBProgressHUD showSuccess:@"清理完毕" toView:self.view];
            [_tableView reloadData];
        }];
    }
}

#pragma mark -
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
    
    
//微信
- (void)detectionWechat
{
    if (![AccountInfo sharedAccountInfo].weixintoken)
    {
        //绑定微信
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
        snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,
                                      ^(UMSocialResponseEntity *response)
        {
                                          
              if (response.data)
              {
                  NSString *accessToken = [[response.data objectForKey:@"wxsession"] objectForKey:@"accessToken"];
                  NSString *weixinId = [[response.data objectForKey:@"wxsession"] objectForKey:@"usid"];
                  
                  NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
                  [dic setObject:accessToken forKey:@"access_token"];
                  [dic setObject:weixinId forKey:@"openid"];
                  
                  [self.dao requestWechatUnionid:dic completionBlock:^(NSDictionary *result) {
                      CLog(@"%@", result);
                      
                      NSString *unionid = [result objectForKeyNotNull:@"unionid"];
                      
                      [dic removeAllObjects];
                      
                      [dic setObject:[AccountInfo sharedAccountInfo].userId forKey:@"userId"];
                      [dic setObject:weixinId forKey:@"weixinId"];
                      [dic setObject:accessToken forKey:@"weixinToken"];
                      
                      //微信unionid
                      [dic setObject:unionid forKey:@"weixinUnionId"];
                      
                      //微信授权的类型
                      [dic setObject:[NSNumber numberWithInt:0] forKey:@"winxinType"];
                      
                      NSString* jsonString = [STJSONSerialization toJSONData:dic];
                      NSMutableDictionary *requestDict = [NSMutableDictionary dictionaryWithCapacity:1];
                      [requestDict setObject:jsonString forKey:@"reqStr"];
                      
                      [_dao requestBindWeiChat:requestDict completionBlock:^(NSDictionary *result) {
                          if ([[result objectForKey:@"code"] integerValue] == 200)
                          {
                              if ([result objectForKey:@"obj"])
                              {
                                  
                                  [[AccountInfo sharedAccountInfo] parsAccountData:[result objectForKey:@"obj"]];
                                  
                                  [self.tableView reloadData];
                              }
                          }
                          else
                          {
                              MET_MIDDLE([result objectForKey:@"msg"]);
                          }
                      }
                                setFailedBlock:^(NSDictionary *result) {
                                    MET_MIDDLE([result objectForKey:@"msg"]);
                                }];
                      

                      
                  } setFailedBlock:^(NSDictionary *result) {
                      
                  }];
              }
              else{
                  MET_MIDDLE(@"授权失败");
              }});
    }
}

@end
