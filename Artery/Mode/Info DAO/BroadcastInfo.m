//
//  BroadcastInfo.m
//  Shitan
//
//  Created by 刘敏 on 14-10-29.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "BroadcastInfo.h"

@implementation BroadcastInfo

- (instancetype)initWithParsData:(NSDictionary *)dict{
    
    if ([dict objectForKey:@"createTime"] != [NSNull null])
    {
        self.createTime = [dict objectForKey:@"createTime"];
    }
    
    if ([dict objectForKey:@"broadcastId"] != [NSNull null]) {
        self.broadcastId = [dict objectForKey:@"broadcastId"];
    }
    
    if ([dict objectForKey:@"description"] != [NSNull null]) {
        self.descriptions = [dict objectForKey:@"description"];
    }
    
    if ([dict objectForKey:@"title"] != [NSNull null]) {
        self.title = [dict objectForKey:@"title"];
    }
    
    
    if ([dict objectForKey:@"status"] != [NSNull null]) {
        self.status = [[dict objectForKey:@"status"] integerValue];
    }
    
    if ([dict objectForKey:@"id"] != [NSNull null]) {
        self.m_Id = [[dict objectForKey:@"id"] integerValue];
    }
    
    if ([dict objectForKey:@"url"] != [NSNull null]  && [[dict objectForKey:@"url"] isKindOfClass:[NSString class]] && [[dict objectForKey:@"url"] length] > 0) {
        self.url = [dict objectForKey:@"url"];
    }
    
    return self;
}




@end
