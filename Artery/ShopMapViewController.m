//
//  ShopMapViewController.m
//  Shitan
//
//  Created by 刘敏 on 15/1/22.
//  Copyright (c) 2015年 深圳食探网络科技有限公司. All rights reserved.
//

#import "ShopMapViewController.h"

@interface ShopMapViewController ()<MKMapViewDelegate>

@end

@implementation ShopMapViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"商家地点"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"商家地点"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *titN = nil;
    if (_sInfo.branchName && _sInfo.branchName.length > 1) {
        titN = [NSString stringWithFormat:@"%@(%@)", _sInfo.addressName, _sInfo.branchName];
    }
    else{
        titN = _sInfo.addressName;
    }
    
    [self setNavBarTitle:titN];
    
    [ResetFrame resetScrollView:self.scrollView contentInsetWithNaviBar:YES tabBar:NO iOS7ContentInsetStatusBarHeight:-1 inidcatorInsetStatusBarHeight:-1];
    
    //设置地图中心
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [_sInfo.latitude floatValue];
    coordinate.longitude = [_sInfo.longitude floatValue];
    
    
    MKPointAnnotation *ann = [[MKPointAnnotation alloc] init];
    ann.coordinate = coordinate;
    [ann setTitle:titN];
    [ann setSubtitle:_sInfo.address];
    
    //触发viewForAnnotation
    [_mapView addAnnotation:ann];
    
    
    //设置显示范围
    MKCoordinateRegion region;
    region.span.latitudeDelta = 0.02;
    region.span.longitudeDelta = 0.02;
    region.center = coordinate;
    // 设置显示位置(动画)
    [_mapView setRegion:region animated:YES];
    // 设置地图显示的类型及根据范围进行显示
    [_mapView regionThatFits:region];
    
    //显示用户当前位置
    self.mapView.showsUserLocation = YES;
    //地图不旋转
    self.mapView.rotateEnabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
