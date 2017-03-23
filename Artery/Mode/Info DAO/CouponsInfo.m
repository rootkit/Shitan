//
//  CouponsInfo.m
//  Shitan
//
//  Created by Richard Liu on 15/4/29.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "CouponsInfo.h"

@implementation CouponsInfo

- (instancetype)initWithParsData:(NSDictionary *)dict
{
    self.couponsId = [dict objectForKeyNotNull:@"couponsId"];
    self.businessId = [dict objectForKeyNotNull:@"businessId"];
    self.useBusinessId = [dict objectForKeyNotNull:@"useBusinessId"];
    self.businessName = [dict objectForKeyNotNull:@"businessName"];
    
    self.name = [dict objectForKeyNotNull:@"name"];
    
    self.money = [[dict objectForKeyNotNull:@"money"] integerValue];
    self.type = [[dict objectForKeyNotNull:@"type"] integerValue];
    
    self.lowMoney = [[dict objectForKeyNotNull:@"lowMoney"] integerValue];
    
    self.isLimit = [[dict objectForKeyNotNull:@"isLimit"] boolValue];
    self.isValid = [[dict objectForKeyNotNull:@"isValid"] boolValue];
    self.hasUse = [[dict objectForKeyNotNull:@"hasUse"] boolValue];

    self.beginTime = [dict objectForKeyNotNull:@"beginTime"];
    self.createTime = [dict objectForKeyNotNull:@"createTime"];
    
    NSString *endT = [dict objectForKeyNotNull:@"endTime"];
    
    if (endT) {
        self.endTime = [endT substringWithRange:NSMakeRange(0, 10)];
    }
    
    return self;
}

@end
