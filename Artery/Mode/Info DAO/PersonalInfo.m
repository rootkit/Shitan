//
//  PersonalInfo.m
//  Shitan
//
//  Created by 刘敏 on 14-10-15.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "PersonalInfo.h"

@implementation PersonalInfo

- (instancetype)initWithParsData:(NSDictionary *)dict
{
    self.accountsource = [[dict objectForKeyNotNull:@"accountSource"] integerValue];
    self.gender = [[dict objectForKeyNotNull:@"gender"] integerValue];
    self.m_ID = [[dict objectForKeyNotNull:@"id"] integerValue];

    
    //关注
    self.followedCount = [[dict objectForKeyNotNull:@"followedCount"] integerValue];
    //粉丝
    self.fansCount = [[dict objectForKeyNotNull:@"followerCount"] integerValue];
    //图片数量
    self.imgCount = [[dict objectForKeyNotNull:@"imgCount"] integerValue];
    
    self.userType = [[dict objectForKeyNotNull:@"userType"] integerValue];
    
    if ([dict objectForKey:@"birthday"] != [NSNull null]) {
        self.birthday = [[dict objectForKeyNotNull:@"birthday"] substringWithRange:NSMakeRange(0,10)];
    }
    
    
    if ([dict objectForKey:@"city"] != [NSNull null]) {
        self.city = [dict objectForKeyNotNull:@"city"];
    }

    self.lastmobilelogintime = [dict objectForKeyNotNull:@"lastLoginTime"];
    
    if ([dict objectForKey:@"mobile"] != [NSNull null]) {
        self.mobile = [dict objectForKeyNotNull:@"mobile"];
    }
    
    if ([dict objectForKey:@"mobilePrefix"] != [NSNull null]) {
        self.mobileprefix = [dict objectForKeyNotNull:@"mobilePrefix"];
    }
    

    
    if ([dict objectForKey:@"name"] != [NSNull null]) {
        self.name = [dict objectForKeyNotNull:@"name"];
    }
    
    
    self.nickname = [dict objectForKeyNotNull:@"nickname"];

    //赞列表
    if (!self.nickname) {
        self.nickname = [dict objectForKeyNotNull:@"nickName"];
    }
    
    


    if ([dict objectForKey:@"portraitUrl"] != [NSNull null]) {
        self.portraiturl = [dict objectForKeyNotNull:@"portraitUrl"];
    }

    if ([dict objectForKey:@"signature"] != [NSNull null]) {
        self.signature = [dict objectForKeyNotNull:@"signature"];
    }
    
    if ([dict objectForKey:@"updateTime"] != [NSNull null]) {
        self.updatetime = [dict objectForKeyNotNull:@"updateTime"];
    }
    
    if ([dict objectForKey:@"userId"] != [NSNull null]) {
        self.userId = [dict objectForKeyNotNull:@"userId"];
    }
    
    
    if ([dict objectForKey:@"followedUserId"] != [NSNull null]) {
        self.followedUserId = [dict objectForKeyNotNull:@"followedUserId"];
    }
    
    if ([dict objectForKey:@"followerUserId"] != [NSNull null]) {
        self.followerUserId = [dict objectForKeyNotNull:@"followerUserId"];
    }
    

    
    if ([dict objectForKeyNotNull:@"hasFollow"]) {
        self.hasFollow = [[dict objectForKeyNotNull:@"hasFollow"] integerValue];
    }
    
    ////赞列表
    if ([dict objectForKeyNotNull:@"hasFollowTheAuthor"]) {
        self.hasFollow = [[dict objectForKeyNotNull:@"hasFollowTheAuthor"] integerValue];
    }

    return self;
}

@end
