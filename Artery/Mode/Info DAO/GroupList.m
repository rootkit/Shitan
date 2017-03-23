
//
//  GroupList.m
//  Shitan
//
//  Created by Avalon on 15/5/28.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "GroupList.h"

@implementation GroupList

- (instancetype)initWithParsData:(NSDictionary *)dict{
    
    self.recordId = [dict objectForKeyNotNull:@"recordId"];
    self.userId = [dict objectForKeyNotNull:@"userId"];
    self.groupDescription = [dict objectForKeyNotNull:@"description"];
    self.title = [dict objectForKeyNotNull:@"title"];
    self.city = [dict objectForKeyNotNull:@"city"];
    self.imageUrl = [dict objectForKeyNotNull:@"imageUrl"];
    self.createTime = [dict objectForKeyNotNull:@"createTime"];
    self.dealId = [dict objectForKeyNotNull:@"dealId"];
    self.publishDate = [dict objectForKeyNotNull:@"publishDate"];
    self.updateTime = [dict objectForKeyNotNull:@"updateTime"];
    self.count = [[dict objectForKeyNotNull:@"count"] intValue];
    self.state = [[dict objectForKeyNotNull:@"state"] intValue];
    self.back = [[dict objectForKeyNotNull:@"back"] floatValue];
    self.commissionRatio = [[dict objectForKeyNotNull:@"commissionRatio"] floatValue];
    self.currentPrice = [[dict objectForKeyNotNull:@"currentPrice"] floatValue];
    
    self.h5url = [dict objectForKeyNotNull:@"h5url"];
    
    
    return self;
}


@end
