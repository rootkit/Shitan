//
//  MessageInfo.m
//  Shitan
//
//  Created by Jia HongCHI on 14/10/25.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "MessageInfo.h"

@implementation MessageInfo

- (instancetype)initWithParsData:(NSDictionary *)dict{
    
    if ([dict objectForKey:@"createTime"] != [NSNull null])
    {
        self.createTime = [dict objectForKey:@"createTime"];
    }
    
    if ([dict objectForKey:@"extra"] != [NSNull null]) {
        self.extra = [dict objectForKey:@"extra"];
    }
    
    if ([dict objectForKey:@"messageId"] != [NSNull null]) {
        self.messageId = [dict objectForKey:@"messageId"];
    }
    
    if ([dict objectForKey:@"imgId"] != [NSNull null]) {
        self.imgId = [dict objectForKey:@"imgId"];
    }
    
    if ([dict objectForKey:@"messageType"] != [NSNull null]) {
        self.messageType = [[dict objectForKey:@"messageType"] integerValue];
    }
    
    if ([dict objectForKey:@"nickname"] != [NSNull null]) {
        self.nickname = [dict objectForKey:@"nickname"];
    }
    
    if ([dict objectForKey:@"portraitUrl"] != [NSNull null]) {
        self.portraitUrl = [dict objectForKey:@"portraitUrl"];
    }
    
    if ([dict objectForKey:@"receiverId"] != [NSNull null]) {
        self.receiverId = [dict objectForKey:@"receiverId"];
    }
    
    if ([dict objectForKey:@"senderId"] != [NSNull null]) {
        self.senderId = [dict objectForKey:@"senderId"];
    }
    
    self.userType = [[dict objectForKeyNotNull:@"userType"] integerValue];
    
    return self;
}


@end
