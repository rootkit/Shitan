//
//  STMainViewController.m
//  Shitan
//
//  Created by Richard Liu on 15/8/24.
//  Copyright (c) 2015年 深圳食探网络科技有限公司. All rights reserved.
//

#import "STMainViewController.h"
#import "STNavigationController.h"
#import "STLeftMenuView.h"
#import "STHomeViewController.h"
#import "RecommendedViewController.h"
#import "FoundViewController.h"
#import "MessageViewController.h"
#import "SettingViewController.h"
#import "FavoritesViewController.h"
#import "ProfileTableViewController.h"
#import "STLoginViewController.h"
#import "SpecialTableViewController.h"
#import "DynamicalTableViewController.h"
#import "AccountDAO.h"
#import "UMSocial.h"
#import "CitySelectionViewController.h"

@interface STMainViewController ()<STLeftMenuViewDelegate, UIGestureRecognizerDelegate, CitySelectionViewControllerDelegate>


//左边按钮的view
@property (nonatomic, weak) STLeftMenuView *leftMenuView;

@property (strong, nonatomic) AccountDAO *dao;

@property (weak, nonatomic) STNavigationController *nav1;
@property (weak, nonatomic) STNavigationController *nav2;
@property (weak, nonatomic) STNavigationController *nav3;
@property (weak, nonatomic) STNavigationController *nav4;
@property (weak, nonatomic) STNavigationController *nav5;
@property (weak, nonatomic) STNavigationController *nav6;

@end

@implementation STMainViewController


- (void)initDao
{
    if (!self.dao) {
        self.dao = [[AccountDAO alloc] init];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _leftMenuView.delegate = nil;
    if (_leftMenuView) {
        [_leftMenuView removeFromSuperview];
    }
    
    CLog(@"%@", self.childViewControllers);
    
    if (_showViewController) {
        [_showViewController willMoveToParentViewController:nil];
        [_showViewController.view removeFromSuperview];
        [_showViewController removeFromParentViewController];
        
        self.showViewController = self.childViewControllers[0];
    }
    
    if (!theAppDelegate.isLogin) {
        [self initDao];
    }
    
    [self loadChildViewController];
    
    
    //创建左边View，添加约束
    STLeftMenuView *leftView = [[STLeftMenuView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN.size.width, MAINSCREEN.size.height + 20)];
    _leftMenuView = leftView;
    _leftMenuView.tag = 0x128;
    _leftMenuView.delegate = self;
    [self.view insertSubview:_leftMenuView atIndex:1];
}



- (void)updateMenu
{
    
    _leftMenuView.delegate = nil;
    if (_leftMenuView) {
        [_leftMenuView removeFromSuperview];
    }
    
    if (self.showViewController) {
        [self.showViewController openLeftMenu];
        self.showViewController = nil;
        
        [_nav6 willMoveToParentViewController:nil];
        [_nav6.view removeFromSuperview];
        [_nav6 removeFromParentViewController];
    }
    
    
    if (theAppDelegate.isLogin) {
        FavoritesViewController *vc = [[FavoritesViewController alloc] init];
        STNavigationController *nav3 = [[STNavigationController alloc] initWithRootViewController:vc];
        _nav3 = nav3;
        _nav3.view.layer.shadowColor = [UIColor blackColor].CGColor;
        _nav3.view.layer.shadowOffset = CGSizeMake(-3.5, 0);
        _nav3.view.layer.shadowOpacity = 0.2;
        [self addChildViewController:_nav3];
        
        
        ProfileTableViewController *pvc = [[ProfileTableViewController alloc] init];
        STNavigationController *nav5 = [[STNavigationController alloc] initWithRootViewController:pvc];
        _nav5 = nav5;
        _nav5.view.layer.shadowColor = [UIColor blackColor].CGColor;
        _nav5.view.layer.shadowOffset = CGSizeMake(-3.5, 0);
        _nav5.view.layer.shadowOpacity = 0.2;
        [self addChildViewController:_nav5];
    }
    else{
        [_nav3 willMoveToParentViewController:nil];
        [_nav3.view removeFromSuperview];
        [_nav3 removeFromParentViewController];
        
        [_nav5 willMoveToParentViewController:nil];
        [_nav5.view removeFromSuperview];
        [_nav5 removeFromParentViewController];
    }
    
    SettingViewController *pvc = [[SettingViewController alloc] init];
    STNavigationController *nav6 = [[STNavigationController alloc] initWithRootViewController:pvc];
    _nav6 = nav6;
    _nav6.view.layer.shadowColor = [UIColor blackColor].CGColor;
    _nav6.view.layer.shadowOffset = CGSizeMake(-3.5, 0);
    _nav6.view.layer.shadowOpacity = 0.2;
    [self addChildViewController:_nav6];
    
    
    
    //创建左边View，添加约束
    STLeftMenuView *leftView = [[STLeftMenuView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN.size.width, MAINSCREEN.size.height + 20)];
    _leftMenuView = leftView;
    _leftMenuView.tag = 0x128;
    _leftMenuView.delegate = self;
    [self.view insertSubview:_leftMenuView atIndex:1];
    
}


- (void)loadChildViewController
{
    /**************************************** 推荐 ************************************/
    RecommendedViewController *rvc = [[RecommendedViewController alloc] init];
    STNavigationController *nav1 = [[STNavigationController alloc] initWithRootViewController:rvc];
    _nav1 = nav1;
    _nav1.view.layer.shadowColor = [UIColor blackColor].CGColor;
    _nav1.view.layer.shadowOffset = CGSizeMake(-3.5, 0);
    _nav1.view.layer.shadowOpacity = 0.2;
    [self addChildViewController:_nav1];
    
    
    /**************************************** 发现 ************************************/
    
    FoundViewController *tVC = [[FoundViewController alloc] init];
    NSMutableArray *vs = [[NSMutableArray alloc] initWithCapacity:2];
    tVC.titleS = @[@"精选", @"最新"];
    
    [tVC.titleS enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL *stop) {
        if(idx == 0)
        {
            SpecialTableViewController *tableViewController = [[SpecialTableViewController alloc] initWithStyle:UITableViewStylePlain];
            tableViewController.title = title;
            tableViewController.twitterVC  = tVC;
            [vs addObject:tableViewController];
        }
        else if(idx == 1){
            DynamicalTableViewController *dyController = [[DynamicalTableViewController alloc] initWithStyle:UITableViewStylePlain];
            dyController.title = title;
            dyController.twitterVC  = tVC;
            [vs addObject:dyController];
        }
        
    }];
    
    
    tVC.viewControllers = vs;
    tVC.didChangedPageCompleted = ^(NSInteger cuurentPage, NSString *title) {
        CLog(@"cuurentPage : %ld on title : %@", (long)cuurentPage, title);
    };
    
    
    STNavigationController *nav2 = [[STNavigationController alloc] initWithRootViewController:tVC];
    _nav2 = nav2;
    _nav2.view.layer.shadowColor = [UIColor blackColor].CGColor;
    _nav2.view.layer.shadowOffset = CGSizeMake(-3.5, 0);
    _nav2.view.layer.shadowOpacity = 0.2;
    [self addChildViewController:_nav2];
    
    /**************************************** 消息 ************************************/
    MessageViewController *mvc = [[MessageViewController alloc] init];
    STNavigationController *nav4 = [[STNavigationController alloc] initWithRootViewController:mvc];
    _nav4 = nav4;
    _nav4.view.layer.shadowColor = [UIColor blackColor].CGColor;
    _nav4.view.layer.shadowOffset = CGSizeMake(-3.5, 0);
    _nav4.view.layer.shadowOpacity = 0.2;
    [self addChildViewController:_nav4];

    /**************************************** 设置 ************************************/
    SettingViewController *pvc = [[SettingViewController alloc] init];
    STNavigationController *nav6 = [[STNavigationController alloc] initWithRootViewController:pvc];
    _nav6 = nav6;
    _nav6.view.layer.shadowColor = [UIColor blackColor].CGColor;
    _nav6.view.layer.shadowOffset = CGSizeMake(-3.5, 0);
    _nav6.view.layer.shadowOpacity = 0.2;
    [self addChildViewController:_nav6];
    
    /**************************************** 收藏 ************************************/
    if(theAppDelegate.isLogin)
    {
        FavoritesViewController *vc = [[FavoritesViewController alloc] init];
        STNavigationController *nav3 = [[STNavigationController alloc] initWithRootViewController:vc];
        _nav3 = nav3;
        _nav3.view.layer.shadowColor = [UIColor blackColor].CGColor;
        _nav3.view.layer.shadowOffset = CGSizeMake(-3.5, 0);
        _nav3.view.layer.shadowOpacity = 0.2;
        [self addChildViewController:_nav3];
        
        
        ProfileTableViewController *pvc = [[ProfileTableViewController alloc] init];
        STNavigationController *nav5 = [[STNavigationController alloc] initWithRootViewController:pvc];
        _nav5 = nav5;
        _nav5.view.layer.shadowColor = [UIColor blackColor].CGColor;
        _nav5.view.layer.shadowOffset = CGSizeMake(-3.5, 0);
        _nav5.view.layer.shadowOpacity = 0.2;
        [self addChildViewController:_nav5];
    }

}


- (void)wechatLogin
{
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    
    snsPlatform.loginClickHandler(self, [UMSocialControllerService defaultControllerService], YES,
                                  ^(UMSocialResponseEntity *response){
                                      
                                      if (response.data) {
                                          [theAppDelegate.HUDManager showSimpleTip:@"正在授权" interval:NSNotFound];
                                          
                                          //获取微信用户资料
                                          [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToWechatSession  completion:^(UMSocialResponseEntity *response){
                                              
                                              CLog(@"SnsInformation is %@",response.data);
                                              
                                              if (response.data) {
                                                  NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:2];
                                                  [dic setObject:[response.data objectForKey:@"access_token"] forKey:@"access_token"];
                                                  [dic setObject:[response.data objectForKey:@"openid"] forKey:@"openid"];
                                                  
                                                  [self.dao requestWechatUnionid:dic completionBlock:^(NSDictionary *result) {
                                                      CLog(@"%@", result);
                                                      
                                                      NSString *unionid = [result objectForKeyNotNull:@"unionid"];
                                                      
                                                      NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:response.data];
                                                      [dic setObject:unionid forKey:@"unionid"];
                                                      [self parasResponseData:dic];
                                                      
                                                  } setFailedBlock:^(NSDictionary *result) {
                                                      
                                                  }];
                                              }
                                              
                                          }];
                                      }
                                      else{
                                          [theAppDelegate.HUDManager hideHUD];
                                          MET_MIDDLE(@"授权失败");
                                      }
                                  });
}


//解析微信登陆返回的数据
- (void)parasResponseData:(NSDictionary *)response
{
    if (![response objectForKey:@"access_token"]) {
        
        
        [theAppDelegate.HUDManager hideHUD];
        MET_MIDDLE(@"授权被取消");
        return;
    }
    
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    
    [dict setObject:[response objectForKey:@"access_token"] forKey:@"weixinToken"];
    [dict setObject:[response objectForKey:@"openid"] forKey:@"weixinId"];
    
    //微信unionid
    [dict setObject:[response objectForKey:@"unionid"] forKey:@"weixinUnionId"];
    
    //微信授权的类型
    [dict setObject:[NSNumber numberWithInt:0] forKey:@"winxinType"];
    
    //性别(男为0，女为1)
    if([[response objectForKey:@"gender"] integerValue] == 0)
    {
        [dict setObject:[NSNumber numberWithInt:1] forKey:@"gender"];
    }
    else{
        [dict setObject:[NSNumber numberWithInt:0] forKey:@"gender"];
    }
    
    
    //头像
    [dict setObject:[response objectForKey:@"profile_image_url"] forKey:@"portraitUrl"];
    //昵称
    [dict setObject:[response objectForKey:@"screen_name"] forKey:@"nickName"];
    
    
    [dict setObject:@"1990-01-01" forKey:@"birthday"];
    
    NSString* jsonString = [STJSONSerialization toJSONData:dict];
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionaryWithCapacity:1];
    [requestDict setObject:jsonString forKey:@"reqStr"];
    
    //直接登录
    [self.dao requestWechatLogin:requestDict];
    
}

//手机登陆
- (void)phoneLogin
{
    STLoginViewController *loginVC = CREATCONTROLLER(STLoginViewController);
    STNavigationController *nc = [[STNavigationController alloc] initWithRootViewController:loginVC];
    nc.view.layer.shadowColor = [UIColor blackColor].CGColor;
    nc.view.layer.shadowOffset = CGSizeMake(-3.5, 0);
    nc.view.layer.shadowOpacity = 0.2;
    
    [self presentViewController:nc animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WNXLeftMenuViewDelegate 左视图按钮点击事件
- (void)leftMenuViewButtonClcikFrom:(STLeftButtonType)fromIndex to:(STLeftButtonType)toIndex
{
    //暂时先做没有登陆的情况的点击
    STNavigationController *newNC = nil;
    STNavigationController *oldNC = nil;
    
    switch (toIndex) {
        case STLeftButtonTypeHome:
            newNC = _nav1;
            break;
            
        case STLeftButtonTypeFound:
            newNC = _nav2;
            break;
        case STLeftButtonTypeCollection:
            newNC = _nav3;
            break;
        case STLeftButtonTypeMessage:
            newNC = _nav4;
            break;
        case STLeftButtonTypeMine:
            newNC = _nav5;
            break;
        case STLeftButtonTypeSeting:
            newNC = _nav6;
            break;
            
        default:
            break;
    }
    
    
    switch (fromIndex) {
        case STLeftButtonTypeHome:
            oldNC = _nav1;
            break;
            
        case STLeftButtonTypeFound:
            oldNC = _nav2;
            break;
        case STLeftButtonTypeCollection:
            oldNC = _nav3;
            break;
        case STLeftButtonTypeMessage:
            oldNC = _nav4;
            break;
        case STLeftButtonTypeMine:
            oldNC = _nav5;
            break;
        case STLeftButtonTypeSeting:
            oldNC = _nav6;
            break;
            
        default:
            break;
    }
    
    [oldNC.view removeFromSuperview];
    
    //添加新的控制器view
    [self.view addSubview:newNC.view];
    newNC.view.transform = oldNC.view.transform;
    
    self.showViewController = newNC.childViewControllers[0];
    //自动点击遮盖btn
    [self.showViewController coverClick];
    
}


//常规按钮点击时调用
- (void)normaluttonClcikFrom:(STNormalButtonType)index
{
    switch (index) {
        case STNormalWeiXin:
            [self wechatLogin];
            break;
            
        case STNormalPhone:
            [self phoneLogin];
            break;
            
        default:
            break;
    }
    
    //自动点击遮盖btn
    [self.showViewController coverClick];
}


//cictyBtn城市改变时调用
- (void)leftMenuViewCictyButtonChange
{
    CitySelectionViewController *cityVC = CREATCONTROLLER(CitySelectionViewController);
    cityVC.delegate = self;
    STNavigationController *nav = [[STNavigationController alloc] initWithRootViewController:cityVC];
    
    [self presentViewController:nav animated:YES completion:nil];
}


#pragma mark - CitySelectionViewControllerDelegate <NSObject>
- (void)returnTheCityName:(CityInfo *)cInfo
{
    self.showViewController.coverDidRomove = ^{
        [self.leftMenuView setCityName:cInfo.name];
    };
    //自动点击遮盖btn
    [self.showViewController coverClick];
}


- (void)jumpMessage
{
    [_leftMenuView  jumpMessage];
}


@end
