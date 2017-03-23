//
//  ShopInfo.m
//  Shitan
//
//  Created by 刘敏 on 15/1/22.
//  Copyright (c) 2015年 深圳食探网络科技有限公司. All rights reserved.
//

#import "ShopInfo.h"

@implementation ShopInfo


- (instancetype)initWithParsData:(NSDictionary *)dict
{
    self.address = [dict objectForKeyNotNull:@"address"];
    self.addressId = [dict objectForKeyNotNull:@"addressId"];
    self.addressName = [dict objectForKeyNotNull:@"addressName"];
    self.addressSource = [dict objectForKeyNotNull:@"addressSource"];
    self.avgPrice = [dict objectForKeyNotNull:@"avgPrice"];
    self.branchName = [dict objectForKeyNotNull:@"branchName"];
    self.businessId = [dict objectForKeyNotNull:@"businessId"];
    
    self.categories = [dict objectForKeyNotNull:@"categories"];
    self.city = [dict objectForKeyNotNull:@"city"];
    self.region = [dict objectForKeyNotNull:@"region"];
    
    self.geoHash = [dict objectForKeyNotNull:@"geoHash"];
    
    self.phone = [dict objectForKeyNotNull:@"phone"];
    self.longitude = [dict objectForKeyNotNull:@"longitude"];
    self.latitude = [dict objectForKeyNotNull:@"latitude"];
    
    self.otherInfo = [dict objectForKeyNotNull:@"otherInfo"];
    self.businessTime = [dict objectForKeyNotNull:@"businessTime"];
    
    self.distance = [dict objectForKeyNotNull:@"distance"];
    self.dealFlag = [[dict objectForKeyNotNull:@"dealFlag"] intValue];

    return self;
}


@end
