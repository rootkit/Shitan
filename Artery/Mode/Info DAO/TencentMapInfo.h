//
//  TencentMapInfo.h
//  Shitan
//
//  Created by RichardLiu on 15/3/27.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <AMapSearchKit/AMapSearchAPI.h>

@interface TencentMapInfo : NSObject

@property (nonatomic, strong) NSString *address;        //详细地址
@property (nonatomic, assign) CGFloat distance;         //距离
@property (nonatomic, strong) NSString *title;          //标题

@property (assign, nonatomic) CLLocationCoordinate2D coordinate;


- (instancetype)initWithParsData:(NSDictionary *)dict;


//解析高德地图数据
- (instancetype)initWithParsAmapData:(AMapPOI *)dic;


@end
