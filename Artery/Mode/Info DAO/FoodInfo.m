//
//  FoodInfo.m
//  Shitan
//
//  Created by 刘敏 on 14-11-24.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "FoodInfo.h"

@implementation FoodInfo

- (instancetype)initWithParsData:(NSDictionary *)dict{
    
    if ([dict objectForKey:@"id"] != [NSNull null])
    {
        self.mId = [[dict objectForKey:@"id"] integerValue];
    }
    
    if ([dict objectForKey:@"name"] != [NSNull null]) {
        self.name = [dict objectForKey:@"name"];
    }
    
    if ([dict objectForKey:@"nameId"] != [NSNull null]) {
        self.nameId = [dict objectForKey:@"nameId"];
    }
    
    return self;
}

@end
