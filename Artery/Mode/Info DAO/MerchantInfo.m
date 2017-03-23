//
//  MerchantInfo.m
//  Shitan
//
//  Created by Richard Liu on 15/6/26.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "MerchantInfo.h"

@implementation MerchantInfo

- (instancetype)initWithParsData:(NSDictionary *)dict
{
    self.address = [dict objectForKeyNotNull:@"address"];
    self.addressId = [dict objectForKeyNotNull:@"addressId"];
    self.businessId = [dict objectForKeyNotNull:@"businessId"];
    
    self.name = [dict objectForKeyNotNull:@"name"];
    self.title = [dict objectForKeyNotNull:@"title"];
    self.des = [dict objectForKeyNotNull:@"description"];
    
    
    self.coverUrl = [dict objectForKeyNotNull:@"coverUrl"];
    self.logoUrl = [dict objectForKeyNotNull:@"logoUrl"];
    
    
    if([dict objectForKeyNotNull:@"imgUrl"])
    {
        self.imgUrl = [[[dict objectForKeyNotNull:@"imgUrl"] componentsSeparatedByString:@","] objectAtIndex:0];

    }
    
    self.createTime = [dict objectForKeyNotNull:@"createTime"];
    self.tips = [dict objectForKeyNotNull:@"tips"];
    
    self.deliveryNote = [dict objectForKeyNotNull:@"deliveryNote"];
    //配送费用
    self.deliveryMoney = [[dict objectForKeyNotNull:@"deliveryMoney"] integerValue];
    
    self.state = [[dict objectForKeyNotNull:@"state"] integerValue];
    
    self.businessTime = [dict objectForKeyNotNull:@"businessTime"];
    
    //起送金额
    self.lowestMoney = [[dict objectForKeyNotNull:@"lowestMoney"] integerValue];
    
    
    return self;
}

@end
