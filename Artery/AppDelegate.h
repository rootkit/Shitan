//
//  AppDelegate.h
//  Shitan
//
//  Created by 刘敏 on 14-9-11.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGProgressHUDManager.h"
#import "STMainViewController.h"
#import "BufferViewController.h"
#import "CityInfo.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, weak) STMainViewController *mainVC;
@property (nonatomic, weak) BufferViewController *buffVC;
@property (nonatomic, strong) UIWindow *window;


@property (strong, strong) JGProgressHUDManager *HUDManager;


@property (nonatomic, strong) NSString *longitude;    //经度
@property (nonatomic, strong) NSString *latitude;     //纬度
@property (nonatomic, strong) NSString *cityName;     //选择的城市（默认当前定位城市）
@property (nonatomic, strong) NSString *locatCity;    //当前定位城市
@property (strong, nonatomic) NSString *phone;        //存储临时的手机号码

@property (nonatomic, assign) BOOL isLogin;           //是否已经登录

@property (nonatomic, strong) NSDictionary *PODict;  //PO图专题数据封装（用于创建标签）
@property (nonatomic, assign) BOOL isPO;             //是否从PO图专题发图

@property (nonatomic, strong) CityInfo *cInfo;


+ (AppDelegate *)sharedAppDelegate;

- (void)loginSuccess;
- (void)loginOut;

- (void)laodMainVC;


@end
