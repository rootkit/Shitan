//
//  TencentPostion.m
//  Shitan
//
//  Created by RichardLiu on 15/3/28.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "TencentPostion.h"

@implementation TencentPostion


- (instancetype)initWithParsData:(NSDictionary *)dict
{
    self.address = [dict objectForKeyNotNull:@"address"];                       //详细地址
    
    NSDictionary *ad_info = [dict objectForKeyNotNull:@"ad_info"];
    self.nation = [ad_info objectForKeyNotNull:@"nation"];
    self.province = [ad_info objectForKeyNotNull:@"province"];
    self.city = [ad_info objectForKeyNotNull:@"city"];
    self.district = [ad_info objectForKeyNotNull:@"district"];
    
    NSDictionary *location = [ad_info objectForKeyNotNull:@"location"];
    self.coordinate = CLLocationCoordinate2DMake([[location objectForKeyNotNull:@"lat"] doubleValue], [[location objectForKeyNotNull:@"lng"] doubleValue]);
    
    NSDictionary *formatted_addresses = [dict objectForKeyNotNull:@"formatted_addresses"];
    self.title = [formatted_addresses objectForKeyNotNull:@"recommend"];                           //标题

    return self;
}

@end
