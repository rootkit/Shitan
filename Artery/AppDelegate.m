//
//  AppDelegate.m
//  Shitan
//
//  Created by 刘敏 on 14-9-11.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "AppDelegate.h"
#import <ASIHTTPRequest/TReachability.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <SDWebImage/SDImageCache.h>
#import <CoreLocation/CoreLocation.h>
#import "UMSocialSinaHandler.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocial.h"
#import "XGPush.h"
#import "MobClick.h"
#import "STRate.h"
#import "JDStatusBarNotification.h"
#import "MD5Hash.h"
#import "Harpy.h"
#import "SettingModel.h"
#import "JSBadgeView.h"
#import "WXApi.h"
#import "FileManagement.h"
#import "WGS84TOGCJ02.h"
#import "JZLocationConverter.h"
#import "WXPayAPI.h"
#import "ApiXml.h"
#import "CoreNewFeatureVC.h"
#import "CALayer+Transition.h"


#define _IPHONE80_ 80000

@interface AppDelegate ()<CLLocationManagerDelegate, WXApiDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic, strong) TencentOAuth *tencentOAuth;

@property (nonatomic, assign) BOOL hasLocated;

//自定义NavBar+tabbar
- (void)customNavBar;

@end

@implementation AppDelegate


+ (AppDelegate *)sharedAppDelegate
{
	return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)registerPushForIOS8{
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    
    //Types
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    //Actions
    UIMutableUserNotificationAction *acceptAction = [[UIMutableUserNotificationAction alloc] init];
    
    acceptAction.identifier = @"ACCEPT_IDENTIFIER";
    acceptAction.title = @"Accept";
    
    acceptAction.activationMode = UIUserNotificationActivationModeForeground;
    acceptAction.destructive = NO;
    acceptAction.authenticationRequired = NO;
    
    //Categories
    UIMutableUserNotificationCategory *inviteCategory = [[UIMutableUserNotificationCategory alloc] init];
    inviteCategory.identifier = @"INVITE_CATEGORY";
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextDefault];
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextMinimal];
    NSSet *categories = [NSSet setWithObjects:inviteCategory, nil];
    
    
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    
    //注册推送
    [[UIApplication sharedApplication] registerForRemoteNotifications];
#endif
}

//注册推送
- (void)registerPush{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
}


#pragma mark Private methods
- (void)loginSuccess
{
    //是否第一次进入APP
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ISFirstInApp"];
    //是否已经登录
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ISLoginInApp"];
    
    _isLogin = YES;

    if ([AccountInfo sharedAccountInfo].userId)
    {
        //获取新消息
        [[NewsMessageManager shareInstance] getUnreadMessages];
    }
    
    //跟新根控制器
    [self updateMianVC];
}


//注销
- (void)loginOut{
    // 清空本地缓存用户信息
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"USER_INFO"];
    
    // 清空账户信息（内存）
    [[AccountInfo sharedAccountInfo] clearAccountInfo];

    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"ISLoginInApp"];
    _isLogin = NO;

    // 注销设备(注销推送)
    [XGPush unRegisterDevice];
    
    //清空Documents文件夹
    [FileManagement clearCoreData];
    
    //清空Draft文件夹
    [FileManagement clearDraftFolder];
    
    //清空缓存图片
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        CLog(@"清理完毕");
    }];
    
    //跟新根控制器
    [self updateMianVC];
    
}


- (void)enterMainVC
{
    STMainViewController *mainVC = (STMainViewController *)[StoryBoardUtilities viewControllerForStoryboardName:@"MainStoryboard" class:[STMainViewController class]];
    _mainVC = mainVC;
    self.window.rootViewController = _mainVC;
    [self.window.layer transitionWithAnimType:TransitionAnimTypeOglFlip subType:TransitionSubtypesFromLeft curve:TransitionCurveEaseIn duration:0.8f];
}



//更新根控制器
- (void)updateMianVC
{
    [_mainVC willMoveToParentViewController:nil];
    [_mainVC removeFromParentViewController];
    
    [_mainVC updateMenu];

}


- (void)laodMainVC
{
    STMainViewController *mainVC = (STMainViewController *)[StoryBoardUtilities viewControllerForStoryboardName:@"MainStoryboard" class:[STMainViewController class]];
    _mainVC = mainVC;
    self.window.rootViewController = _mainVC;
}


- (void)initializeGPSModule{
    
    _hasLocated = NO;
    
    if ([CLLocationManager locationServicesEnabled]){
        // 初始化并开始更新
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        
        // 设置定位精度
        // kCLLocationAccuracyNearestTenMeters:精度10米
        // kCLLocationAccuracyHundredMeters:精度100 米
        // kCLLocationAccuracyKilometer:精度1000 米
        // kCLLocationAccuracyThreeKilometers:精度3000米
        // kCLLocationAccuracyBest:设备使用电池供电时候最高的精度
        // kCLLocationAccuracyBestForNavigation:导航情况下最高精度，一般要有外接电源
        // 设置寻址经度
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        self.locationManager.distanceFilter = 100;
        
        
        [self.locationManager startUpdatingLocation];
        
        if(isIOS8)
        {
            //ios8新增的定位授权功能
            [self.locationManager requestWhenInUseAuthorization];
        }
        
    }
    else{
        MET_MIDDLE(@"定位失败,请打开定位功能");
    }
}

// 自定义导航栏
- (void)customNavBar{
    
    if (isIOS7) {
        [[UINavigationBar appearance] setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName, nil, NSShadowAttributeName, [UIFont boldSystemFontOfSize:18.0],
         NSFontAttributeName, nil];
        
        
        [[UINavigationBar appearance] setTitleTextAttributes:dic];
        [[UINavigationBar appearance] setTintColor:[UIColor grayColor]];
        
    }
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window = window;
    
    _cInfo = [[CityInfo alloc] init];
    _cInfo.cityId = @"CT01416";
    _cInfo.parentId = @"CT01415";
    _cInfo.name = @"深圳";
    
    
    
    _PODict = nil;
    
    //初始化第三方组件
    [self initComponent];
    
    _HUDManager = [[JGProgressHUDManager alloc] initManager];
    
    // 上一次用户选择的城市
    _cityName = [[NSUserDefaults standardUserDefaults] stringForKey:@"CITY_NAME"];
    
    if(!_cityName)
    {
       _cityName = @"深圳";
    }
    
    //评分
//    [STRate loadRate];
    
    //暂时Document文件夹
    BOOL isHaveUserType = [[NSUserDefaults standardUserDefaults] boolForKey:@"ISHaveUserType"];
    if (!isHaveUserType) {
        [FileManagement clearCoreData];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ISHaveUserType"];
    }

    // 创建草稿箱
    [FileManagement createCustomFolder];

    // 设置导航栏的颜色（ios7遮蔽问题）
    [self customNavBar];
    
    //判断是否需要显示：（内部已经考虑版本及本地版本缓存）
    BOOL canShow = [CoreNewFeatureVC canShowNewFeature];
    if(canShow){
        NewFeatureModel *m1 = nil;
        NewFeatureModel *m2 = nil;
        NewFeatureModel *m3 = nil;
        NewFeatureModel *m4 = nil;
        
        if (MAINBOUNDS.size.height == 480) {
            m1 = [NewFeatureModel model:[UIImage imageNamed:@"iphone4_f1.jpg"]];
            m2 = [NewFeatureModel model:[UIImage imageNamed:@"iphone4_f2.jpg"]];
            m3 = [NewFeatureModel model:[UIImage imageNamed:@"iphone4_f3.jpg"]];
            m4 = [NewFeatureModel model:[UIImage imageNamed:@"iphone4_f4.jpg"]];
        }
        else{
            m1 = [NewFeatureModel model:[UIImage imageNamed:@"f1.jpg"]];
            m2 = [NewFeatureModel model:[UIImage imageNamed:@"f2.jpg"]];
            m3 = [NewFeatureModel model:[UIImage imageNamed:@"f3.jpg"]];
            m4 = [NewFeatureModel model:[UIImage imageNamed:@"f4.jpg"]];
        }
        
        self.window.rootViewController = [CoreNewFeatureVC newFeatureVCWithModels:@[m1,m2,m3, m4] enterBlock:^{
            [self enterMainVC];
        }];
    }
    else
        [self enterMainVC];


    // 是否是登录状态（YES就自动登录，NO就手动登录）
    _isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:@"ISLoginInApp"];
    if (_isLogin)
    {
        //获取用户信息
        [[AccountInfo sharedAccountInfo] parsAccountData:nil];
    }

    if ([AccountInfo sharedAccountInfo].userId) {
        CLog(@"%@", [AccountInfo sharedAccountInfo].userId);
        //设置别名（账号）
        [XGPush setAccount:[AccountInfo sharedAccountInfo].userId];
    }
    
    if (_cityName) {
        //设置标签
        [XGPush setTag:_cityName successCallback:^{
            CLog(@"标签设置成功");
        } errorCallback:^{
            CLog(@"标签设置失败");
        }];
    }

    /*************************** 推送 *************************/
    {
        //注销之后需要再次注册前的准备
        void (^successCallback)(void) = ^(void){
            //如果变成需要注册状态
            if(![XGPush isUnRegisterStatus])
            {
                //iOS8注册push方法
                if (isIOS8) {
                    [self registerPushForIOS8];
                }
                else
                {
                    [self registerPush];
                }
            }
        };
        
        [XGPush initForReregister:successCallback];

        //推送反馈回调版本示例
        void (^successBlock)(void) = ^(void){
            //成功之后的处理
            NSLog(@"[XGPush]handleLaunching's successBlock");
        };
        
        void (^errorBlock)(void) = ^(void){
            //失败之后的处理
            NSLog(@"[XGPush]handleLaunching's errorBlock");
        };
        
        //角标清0
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        
        //清除所有通知(包含本地通知)
//        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        
        [XGPush handleLaunching:launchOptions successCallback:successBlock errorCallback:errorBlock];
        
        //本地推送示例
        
        /* NSDate *fireDate = [[NSDate new] dateByAddingTimeInterval:10];
         
         NSMutableDictionary *dicUserInfo = [[NSMutableDictionary alloc] init];
         [dicUserInfo setValue:@"myid" forKey:@"clockID"];
         NSDictionary *userInfo = dicUserInfo;
         
         [XGPush localNotification:fireDate alertBody:@"测试本地推送" badge:2 alertAction:@"确定" userInfo:userInfo];
         */
    }
    
    //网络监测
    [self monitoringNetwork];

    [self.window makeKeyAndVisible];
    self.window.backgroundColor = [UIColor whiteColor];
    
    return YES;
}

//初始化组件
- (void)initComponent
{
    [self redirectNSLogToDocumentFolder];

    //集成友盟分析组件
    [MobClick startWithAppkey:K_YOUMENG_APPKEY reportPolicy:BATCH channelId:@"APP Store"];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];

    
    //集成友盟社会化组件
    [UMSocialData setAppKey:K_YOUMENG_APPKEY];
    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:K_WEIXIN_APP_KEY appSecret:K_WEIXIN_APPSECRET url:@"http://www.umeng.com/social"];
    
    [WXApi registerApp:K_WEIXIN_APP_KEY withDescription:@"食探"];

    
    //新浪微博（回调地址）
    [UMSocialSinaHandler openSSOWithRedirectURL:K_REDIRECT_URL];

    
    
    //设置分享到QQ/Qzone的应用Id，和分享url 链接
    [UMSocialQQHandler setQQWithAppId:K_QQ_APP_KEY appKey:K_QQ_APPSECRET url:@"http://www.umeng.com/social"];
    [UMSocialQQHandler setSupportWebView:YES];

    
    //信鸽
    [XGPush startApp:2200067226 appKey:@"IL5Y52WK62UU"];
}

/******************************** 日志记录 ******************************/
- (void)redirectNSLogToDocumentFolder
{
    //如果已经连接Xcode调试则不输出到文件
    if(isatty(STDOUT_FILENO)) {
        [MobClick setCrashReportEnabled:NO];
        return;
    }
    
    UIDevice *device = [UIDevice currentDevice];
    if([[device model] hasSuffix:@"Simulator"]){
        //在模拟器不保存到文件中
        [MobClick setCrashReportEnabled:NO];
        return;
    }
    
    // 日志记录（真机下记录 非调试模式下记录）
    if(![SettingModel isCollectLogs])
    {
        //关闭，默认开启
        [MobClick setCrashReportEnabled:NO];
    }
}
/******************************** end ******************************/


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSString * deviceTokenStr = [XGPush registerDevice:deviceToken];
    
    void (^successBlock)(void) = ^(void){
        //成功之后的处理
        CLog(@"[XGPush]register successBlock ,deviceToken: %@",deviceTokenStr);
    };
    
    void (^errorBlock)(void) = ^(void){
        //失败之后的处理
        CLog(@"[XGPush]register errorBlock");
    };
    
    
    [XGPush registerDevice:deviceToken successCallback:successBlock errorCallback:errorBlock];
    
    //如果不需要回调
    [XGPush registerDevice:deviceToken];
    
    //打印获取的deviceToken的字符串
    CLog(@"deviceTokenStr is %@",deviceTokenStr);
}

//如果deviceToken获取不到会进入此事件
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    NSString *str = [NSString stringWithFormat: @"Error: %@",error];
    CLog(@"%@",str);
    
}



//后台运行
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    //notification是发送推送时传入的字典信息
//    [XGPush localNotificationAtFrontEnd:notification userInfoKey:@"clockID" userInfoValue:@"myid"];
    
    //删除推送列表中的这一条
//    [XGPush delLocalNotification:notification];
    //[XGPush delLocalNotification:@"clockID" userInfoValue:@"myid"];
    
    //清空推送列表
    //[XGPush clearLocalNotifications];
    
}


#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_

//注册UserNotification成功的回调
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //用户已经允许接收以下类型的推送
    //UIUserNotificationType allowedTypes = [notificationSettings types];
    
}

//按钮点击事件回调
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler{
    if([identifier isEqualToString:@"ACCEPT_IDENTIFIER"]){
        NSLog(@"ACCEPT_IDENTIFIER is clicked");
    }
    
    completionHandler();
}
#endif

//在线是响应（从消息中心点击后响应）
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    //推送反馈(app运行时)
    [XGPush handleReceiveNotification:userInfo];
    
    void (^successBlock)(void) = ^(void){
        //成功之后的处理
        NSLog(@"[XGPush]handleReceiveNotification successBlock");
    };
    
    void (^errorBlock)(void) = ^(void){
        //失败之后的处理
        NSLog(@"[XGPush]handleReceiveNotification errorBlock");
    };
    
    void (^completion)(void) = ^(void){
        //失败之后的处理
        NSLog(@"[xg push completion]userInfo is %@",userInfo);
    };
    
    [XGPush handleReceiveNotification:userInfo successCallback:successBlock errorCallback:errorBlock completion:completion];
    
    if(application.applicationState == UIApplicationStateActive)
    {
        //本身就在前台模式
        [_mainVC jumpMessage];
    }
    else
    {
        //跳转到消息模块
        //本身就在前台模式
        [_mainVC jumpMessage];
    }
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

    if ([AccountInfo sharedAccountInfo].userId)
    {
        //获取新消息
        [[NewsMessageManager shareInstance] getUnreadMessages];
    }
    
    //版本检测
    [Harpy checkVersion];
    
    
    //登录成功之后必须再定位一次
    [self initializeGPSModule];
    
    //大于50M自动清空缓存
    float tmpSize = [[SDImageCache sharedImageCache] checkTmpSize];
    if (tmpSize > 50.0f) {
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}



- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url];
}


#pragma mark CLLocationManagerDelegate methods
// 地理位置发生改变时触发
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    if(_hasLocated){
        return;
    }
    else{
        
        _hasLocated = YES;
        // 获取经纬度
        CLog(@"纬度:%f",newLocation.coordinate.latitude);
        CLog(@"经度:%f",newLocation.coordinate.longitude);
        
        
        //判断是不是属于国内范围
        if (![WGS84TOGCJ02 isLocationOutOfChina:[newLocation coordinate]]) {
            //转换后的coord
            CLLocationCoordinate2D coord = [JZLocationConverter wgs84ToGcj02:[newLocation coordinate]];
            
            
            // 获取经纬度
            CLog(@"火星坐标纬度:%f",coord.latitude);
            CLog(@"火星坐标经度:%f",coord.longitude);
            
            
            _latitude = [NSString stringWithFormat:@"%f", coord.latitude];
            _longitude = [NSString stringWithFormat:@"%f", coord.longitude];
        }
        else{
            // 获取经纬度
            CLog(@"火星坐标纬度:%f",newLocation.coordinate.latitude);
            CLog(@"火星坐标经度:%f",newLocation.coordinate.longitude);
            
            
            _latitude = [NSString stringWithFormat:@"%f", newLocation.coordinate.latitude];
            _longitude = [NSString stringWithFormat:@"%f", newLocation.coordinate.longitude];
        }
        
        // 保存Device的现语言 (英语 法语 ，，，)
        NSMutableArray *userDefaultLanguages = [[NSUserDefaults standardUserDefaults]
                                 objectForKey:@"AppleLanguages"];
        // 强制成简体中文
        [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"zh-hans", nil] forKey:@"AppleLanguages"];
        
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error){
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            
            CLog(@"%@, %@, %@", placemark.administrativeArea, placemark.locality, placemark.subLocality);
            
            if(placemark.locality)
            {
                //直辖市跟特别行政区需单独判断
                if([placemark.administrativeArea hasPrefix:@"北京"])
                {
                    _locatCity = @"北京";
                }
                else if([placemark.administrativeArea hasPrefix:@"天津"])
                {
                    _locatCity = @"天津";
                }
                else if([placemark.administrativeArea hasPrefix:@"上海"])
                {
                    _locatCity = @"上海";
                }
                else if([placemark.administrativeArea hasPrefix:@"重庆"])
                {
                    _locatCity = @"重庆";
                }
                else if([placemark.administrativeArea hasPrefix:@"香港"] || [placemark.administrativeArea hasPrefix:@"Hong Kong"])
                {
                    _locatCity = @"香港";
                }
                else if([placemark.administrativeArea hasPrefix:@"澳门"] || [placemark.administrativeArea hasPrefix:@"Macau"])
                {
                    _locatCity = @"澳门";
                }
                else{
                    //单前所在城市
                    _locatCity = [placemark.locality stringByReplacingOccurrencesOfString:@"市" withString:@""];
                }
                
                if(!_cityName)
                {
                    _cityName = _locatCity;
                }
                
                //发送通知
                [[NSNotificationCenter defaultCenter] postNotificationName:@"CITYNAMECODESUCCESSFUL" object:_cityName];
                
                //设置标签
                [XGPush setTag:_cityName successCallback:^{
                    CLog(@"标签设置成功");
                } errorCallback:^{
                    CLog(@"标签设置失败");
                }];
            }
            
        }];

        // 停止位置更新
        [manager stopUpdatingLocation];
        
        // 还原Device的语言
        [[NSUserDefaults standardUserDefaults] setObject:userDefaultLanguages forKey:@"AppleLanguages"];
    }
}


// 定位失误时触发
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    
    NSString *errorString;
    
    CLog(@"Error: %@",[error localizedDescription]);
    switch([error code]) {
        case kCLErrorDenied:
            //Access denied by user
            errorString = @"Access to Location Services denied by user";
            //Do something...
            break;
        case kCLErrorLocationUnknown:
            //Probably temporary...
            errorString = @"Location data unavailable";
            //Do something else...
            break;
        default:
            errorString = @"An unknown error has occurred";
            break;
    }
}


#pragma mark 网络监测
- (void)monitoringNetwork
{
    //网络监测
    TReachability* reach = [TReachability reachabilityWithHostname:@"www.baidu.com"];
    // 监测网络情况
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityNetWorkChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    [reach startNotifier];
}


- (void)reachabilityNetWorkChanged:(NSNotification *)note {
    TReachability* curReach = [note object];
    NetworkStatus status = [curReach currentReachabilityStatus];
    
    if (status == NotReachable) {
        
        CLog(@"网络连接断开");
        [JDStatusBarNotification addStyleNamed:@"SBStyle1"
                                       prepare:^JDStatusBarStyle *(JDStatusBarStyle *style) {
                                           style.barColor = [UIColor colorWithRed:0.797 green:0.000 blue:0.662 alpha:1.000];
                                           style.textColor = [UIColor whiteColor];
                                           style.animationType = JDStatusBarAnimationTypeFade;
                                           style.font = [UIFont fontWithName:@"SnellRoundhand-Bold" size:17.0];
                                           style.progressBarColor = [UIColor colorWithRed:0.986 green:0.062 blue:0.598 alpha:1.000];
                                           style.progressBarHeight = 20.0;
                                           return style;
                                       }];


        [JDStatusBarNotification showWithStatus:@"网络连接失败"
                                   dismissAfter:2.0
                                      styleName:JDStatusBarStyleError];
        
    }
    else
    {
        CLog(@"网络连接正常");
    }
}


@end
