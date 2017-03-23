//
//  PraiseInfo.m
//  Shitan
//
//  Created by 刘敏 on 15/1/30.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "PraiseInfo.h"

@implementation PraiseInfo

- (instancetype)initWithParsData:(NSDictionary *)dict
{
    
    if ([dict objectForKey:@"createTime"] != [NSNull null]) {
        self.createTime = [dict objectForKey:@"createTime"];
    }
    
    
    if ([dict objectForKey:@"id"] != [NSNull null])
    {
        self.mID = [[dict objectForKey:@"id"] integerValue];
    }
    
    
    if ([dict objectForKey:@"hasFollowTheAuthor"] != [NSNull null])
    {
        self.hasFollowTheAuthor = [[dict objectForKey:@"hasFollowTheAuthor"] boolValue];
    }
    
    if ([dict objectForKey:@"imgId"] != [NSNull null])
    {
        self.imgId = [dict objectForKey:@"imgId"];
    }
    
    
    if ([dict objectForKey:@"nickName"] != [NSNull null])
    {
        self.nickName = [dict objectForKey:@"nickName"];
    }
    
    
    if ([dict objectForKey:@"portraitUrl"] != [NSNull null])
    {
        self.portraitUrl = [dict objectForKey:@"portraitUrl"];
    }
    
    
    if ([dict objectForKey:@"praiseId"] != [NSNull null])
    {
        self.praiseId = [dict objectForKey:@"praiseId"];
    }
    
    if ([dict objectForKey:@"userId"] != [NSNull null])
    {
        self.userId = [dict objectForKey:@"userId"];
    }
    
    return self;
}


@end
