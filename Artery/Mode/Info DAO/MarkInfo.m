//
//  MarkInfo.m
//  Shitan
//
//  Created by 刘敏 on 14-10-20.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "MarkInfo.h"

@implementation MarkInfo


- (instancetype)initWithParsData:(NSDictionary *)dict{
    
    if ([dict objectForKey:@"id"] != [NSNull null])
    {
        self.mId = [[dict objectForKey:@"id"] integerValue];
    }
    
    if ([dict objectForKey:@"rawTag"] != [NSNull null]) {
        self.rawTag = [dict objectForKey:@"rawTag"];
    }
    
    if ([dict objectForKey:@"rawId"] != [NSNull null]) {
        self.rawId = [dict objectForKey:@"rawId"];
    }
    
    return self;
}

@end
