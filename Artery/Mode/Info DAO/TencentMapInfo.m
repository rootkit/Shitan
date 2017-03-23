//
//  TencentMapInfo.m
//  Shitan
//
//  Created by RichardLiu on 15/3/27.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "TencentMapInfo.h"

@implementation TencentMapInfo

- (instancetype)initWithParsData:(NSDictionary *)dict
{
    
    self.address = [dict objectForKeyNotNull:@"address"];                       //详细地址
    self.distance = [[dict objectForKeyNotNull:@"_distance"] floatValue];       //距离
    
    self.title = [dict objectForKeyNotNull:@"title"];                           //标题

    NSDictionary *dic = [dict objectForKeyNotNull:@"location"];
    self.coordinate = CLLocationCoordinate2DMake([[dic objectForKeyNotNull:@"lat"] doubleValue], [[dic objectForKeyNotNull:@"lng"] doubleValue]);

    
    
    return self;
}



//解析高德地图数据
- (instancetype)initWithParsAmapData:(AMapPOI *)dic
{
    self.address = [NSString stringWithFormat:@"%@%@%@%@", dic.province, dic.city, dic.district, dic.address];
    self.title = dic.name;
    self.coordinate = CLLocationCoordinate2DMake(dic.location.latitude, dic.location.longitude);
    
    return self;
}

@end
