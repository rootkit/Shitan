//
//  UserGroupInfo.m
//  Shitan
//
//  Created by Avalon on 15/5/27.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "UserGroupInfo.h"

@implementation UserGroupInfo

- (instancetype)initWithParsData:(NSDictionary *)dict{
    
    self.userId = [dict objectForKeyNotNull:@"userId"];
    self.code = [dict objectForKeyNotNull:@"code"];
    self.invited = [dict objectForKeyNotNull:@"invited"];
    self.createTime = [dict objectForKeyNotNull:@"createTime"];
    self.updateTime = [dict objectForKeyNotNull:@"updateTime"];
    
    self.totalMoney = [[dict objectForKeyNotNull:@"totalMoney"] floatValue];
    self.percent = [[dict objectForKeyNotNull:@"percent"] floatValue];
    self.cashMin = [[dict objectForKeyNotNull:@"cashMin"] floatValue];
    self.cashing = [[dict objectForKeyNotNull:@"cashing"] intValue];

    return self;
    
}


@end
