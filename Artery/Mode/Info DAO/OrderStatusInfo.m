//
//  OrderStatusInfo.m
//  Shitan
//
//  Created by Richard Liu on 15/8/6.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "OrderStatusInfo.h"

@implementation OrderStatusInfo

- (instancetype)initWithParsData:(NSDictionary *)dict
{
    
    self.orderNo = [dict objectForKeyNotNull:@"orderno"];
    self.state = [[dict objectForKeyNotNull:@"state"] integerValue];
    
    self.updateTime = [dict objectForKeyNotNull:@"updatetime"];
    self.updateTime = [self.updateTime substringWithRange:NSMakeRange(11, 5)];
    
    
    return self;
}

@end
