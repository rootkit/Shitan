//
//  ContactInfo.m
//  Shitan
//
//  Created by 刘敏 on 15/1/14.
//  Copyright (c) 2015年 深圳食探网络科技有限公司. All rights reserved.
//

#import "ContactInfo.h"

@implementation ContactInfo


- (instancetype)initWithParsData:(NSDictionary *)dict
{
    if ([dict objectForKey:@"contactId"] != [NSNull null])
    {
        self.contactId = [dict objectForKey:@"contactId"];
    }
    
    if ([dict objectForKey:@"contactName"] != [NSNull null]) {
        self.contactName = [dict objectForKey:@"contactName"];
    }
    
    if ([dict objectForKey:@"followedUserId"] != [NSNull null]) {
        self.followedUserId = [dict objectForKey:@"followedUserId"];
    }
    
    
    
    if ([dict objectForKey:@"hasExistSystem"] != [NSNull null]) {
        self.hasExistSystem = [[dict objectForKey:@"hasExistSystem"] boolValue];
        
    }
    
    if ([dict objectForKey:@"hasFollow"] != [NSNull null]) {
        self.hasFollow = [[dict objectForKey:@"hasFollow"] boolValue];
        
    }
    
    if ([dict objectForKey:@"mobilePhone"] != [NSNull null]) {
        self.mobilePhone = [dict objectForKey:@"mobilePhone"];
    }
    
    
    if ([dict objectForKey:@"nickName"] != [NSNull null]) {
        self.nickName = [dict objectForKey:@"nickName"];
    }
    
    if ([dict objectForKey:@"userId"] != [NSNull null]) {
        self.userId = [dict objectForKey:@"userId"];
    }
    
    return self;
}

@end
