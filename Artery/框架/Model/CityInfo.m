//
//  CityInfo.m
//  Shitan
//
//  Created by Richard Liu on 15/9/1.
//  Copyright (c) 2015年 深圳食探网络科技有限公司. All rights reserved.
//

#import "CityInfo.h"

@implementation CityInfo


- (instancetype)initWithParsData:(NSDictionary *)dict
{
    self.mId = [dict objectForKeyNotNull:@"id"];
    self.cityId = [dict objectForKeyNotNull:@"cityId"];
    self.parentId = [dict objectForKeyNotNull:@"parentId"];
    
    NSString *city = [dict objectForKeyNotNull:@"name"];
    self.name = [city stringByReplacingOccurrencesOfString:@"市" withString:@""];

    self.pinyin = [dict objectForKeyNotNull:@"pinyin"];
    self.createTime = [dict objectForKeyNotNull:@"createTime"];
    
    return self;
    
}

@end
