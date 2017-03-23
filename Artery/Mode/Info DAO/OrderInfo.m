//
//  OrderInfo.m
//  Shitan
//
//  Created by Richard Liu on 15/6/17.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "OrderInfo.h"

@implementation OrderInfo

- (instancetype)initWithParsData:(NSDictionary *)dict
{
    self.addressId = [dict objectForKeyNotNull:@"addressId"];
    self.businessId = [dict objectForKeyNotNull:@"businessId"];
    self.businessName = [dict objectForKeyNotNull:@"businessName"];
    
    self.couponId = [dict objectForKeyNotNull:@"couponId"];
    
    self.totalMoney = [dict objectForKeyNotNull:@"totalMoney"];
    self.createTime = [dict objectForKeyNotNull:@"createTime"];
    
    self.orderNO = [dict objectForKeyNotNull:@"orderNo"];
    self.state = [[dict objectForKeyNotNull:@"state"] integerValue];
    
    
    self.note = [dict objectForKeyNotNull:@"note"];
    
    self.deliveryTime = [dict objectForKeyNotNull:@"deliveryTime"];
    self.deliveryMoney = [[dict objectForKeyNotNull:@"deliveryMoney"] integerValue];
    
    self.payMethod = [[dict objectForKeyNotNull:@"payMethod"] integerValue];
    
    self.realMoney = [dict objectForKeyNotNull:@"realMoney"];
    
    return self;
}



@end
