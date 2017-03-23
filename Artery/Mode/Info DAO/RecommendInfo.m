//
//  RecommendInfo.m
//  Shitan
//
//  Created by Richard Liu on 15/8/12.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "RecommendInfo.h"

@implementation RecommendInfo

- (instancetype)initWithParsData:(NSDictionary *)dict
{
    
    self.des = [dict objectForKeyNotNull:@"description"];
    self.coverUrl = [dict objectForKeyNotNull:@"coverUrl"];
    self.lowestMoney = [dict objectForKeyNotNull:@"lowestMoney"];
    self.nickName = [dict objectForKeyNotNull:@"nickName"];
    self.title = [dict objectForKeyNotNull:@"title"];
    
    self.address = [dict objectForKeyNotNull:@"address"];
    self.deliveryNote = [dict objectForKeyNotNull:@"deliveryNote"];;
    self.street = [dict objectForKeyNotNull:@"street"];
    self.businessId = [dict objectForKeyNotNull:@"businessId"];
    self.deliveryMoney = [dict objectForKeyNotNull:@"deliveryMoney"];
    self.logoUrl = [dict objectForKeyNotNull:@"logoUrl"];
    self.endTime = [dict objectForKeyNotNull:@"endTime"];
    self.avgPrice = [dict objectForKeyNotNull:@"avgPrice"];
    self.name = [dict objectForKeyNotNull:@"name"];
    self.city = [dict objectForKeyNotNull:@"city"];
    self.latitude = [dict objectForKeyNotNull:@"latitude"];
    
    self.state = [[dict objectForKeyNotNull:@"state"] integerValue];
    self.community = [dict objectForKeyNotNull:@"community"];
    self.tips = [dict objectForKeyNotNull:@"tips"];
    self.cityId = [dict objectForKeyNotNull:@"cityId"];
    self.longitude = [dict objectForKeyNotNull:@"longitude"];
    self.phone = [dict objectForKeyNotNull:@"phone"];
    
    self.distance = [dict objectForKeyNotNull:@"distance"];
    self.addressId = [dict objectForKeyNotNull:@"addressId"];
    
    if([dict objectForKeyNotNull:@"imgUrl"])
    {
        self.imgArray = [[dict objectForKeyNotNull:@"imgUrl"] componentsSeparatedByString:@","];
    }
    
    self.favoriteCount = [[dict objectForKeyNotNull:@"favoriteCount"] integerValue];
    self.browse = [[dict objectForKeyNotNull:@"browse"] integerValue];
    
    self.businessTime = [dict objectForKeyNotNull:@"businessTime"];
    self.createTime = [dict objectForKeyNotNull:@"createTime"];
    self.beginTime = [dict objectForKeyNotNull:@"beginTime"];
    
    self.isFavorited = [[dict objectForKeyNotNull:@"isFavorited"] boolValue];
    
    
    return self;
}


@end
