
//
//  PacketList.m
//  Shitan
//
//  Created by Avalon on 15/5/28.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "PacketList.h"

@implementation PacketList


- (instancetype)initWithParsData:(NSDictionary *)dict{
    
    
    self.totalMoney = [[dict objectForKeyNotNull:@"totalMoney"] floatValue];
    self.changeMoney = [[dict objectForKeyNotNull:@"changeMoney"] floatValue];
    self.ID = [[dict objectForKeyNotNull:@"id"] intValue];
    self.state = [[dict objectForKeyNotNull:@"state"] intValue];
    self.ptype = [[dict objectForKeyNotNull:@"ptype"] intValue];
    self.recordId = [dict objectForKeyNotNull:@"recordId"];
    self.userId = [dict objectForKeyNotNull:@"userId"];
    self.note = [dict objectForKeyNotNull:@"note"];
    self.createTime = [dict objectForKeyNotNull:@"createTime"];
    self.updateTime = [dict objectForKeyNotNull:@"updateTime"];
    
    
    return self;
}


@end
