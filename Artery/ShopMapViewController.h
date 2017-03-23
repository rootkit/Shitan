//
//  ShopMapViewController.h
//  Shitan
//
//  Created by 刘敏 on 15/1/22.
//  Copyright (c) 2015年 深圳食探网络科技有限公司. All rights reserved.
//

#import "STChildViewController.h"
#import "ShopInfo.h"
#import <MapKit/MapKit.h>

@interface ShopMapViewController : STChildViewController

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet MKMapView *mapView;

@property (nonatomic, strong) ShopInfo *sInfo;


@end
