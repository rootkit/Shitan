//
//  CommodityInfo.m
//  Shitan
//
//  Created by Richard Liu on 15/8/6.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "CommodityInfo.h"

@implementation CommodityInfo

- (instancetype)initWithParsData:(NSDictionary *)dict
{
    self.ruleId = [dict objectForKeyNotNull:@"ruleId"];
    self.productId = [dict objectForKeyNotNull:@"productId"];
    self.orderNo = [dict objectForKeyNotNull:@"orderNo"];
    self.pname = [dict objectForKeyNotNull:@"pname"];
    self.did = [dict objectForKeyNotNull:@"did"];
    self.buyCount = [[dict objectForKeyNotNull:@"buyCount"] integerValue];      //购买数量
    self.disCount = [dict objectForKeyNotNull:@"disCount"];                     //打折后的价格
    self.price = [dict objectForKeyNotNull:@"price"];

    
    return self;
}


@end
