//
//  CommentInfo.m
//  Shitan
//
//  Created by 刘敏 on 14-10-14.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "CommentInfo.h"

@implementation CommentInfo

- (instancetype)initWithParsData:(NSDictionary *)dict
{
    if ([dict objectForKey:@"id"] != [NSNull null])
    {
        self.m_Id = [[dict objectForKey:@"id"] integerValue];
    }

    if ([dict objectForKey:@"imgId"] != [NSNull null])
    {
        self.imgId = [dict objectForKey:@"imgId"];
    }
    
    if ([dict objectForKey:@"commentId"] != [NSNull null])
    {
        self.commentId = [dict objectForKey:@"commentId"];
    }
    
    if ([dict objectForKey:@"commentUserId"] != [NSNull null])
    {
        self.commentUserId = [dict objectForKey:@"commentUserId"];
    }
    
    if ([dict objectForKey:@"commentUserNickname"] != [NSNull null]) {
        self.commentUserNickname = [dict objectForKey:@"commentUserNickname"];
    }
    
    if ([dict objectForKey:@"commentUserPortraitUrl"] != [NSNull null]) {
        self.commentUserPortraitUrl = [dict objectForKey:@"commentUserPortraitUrl"];
    }
    
    if ([dict objectForKey:@"commentedUserId"] != [NSNull null]) {
        self.commentedUserId = [dict objectForKey:@"commentedUserId"];
    }
    
    if ([dict objectForKey:@"commentedUserNickname"] != [NSNull null]){
        self.commentedUserNickname = [dict objectForKey:@"commentedUserNickname"];
    }
    
    if ([dict objectForKey:@"content"] != [NSNull null]){
        self.content = [dict objectForKey:@"content"];
    }
    
    //创建时间
    if ([dict objectForKey:@"createTime"] != [NSNull null]){
        self.createTime = [dict objectForKey:@"createTime"];
    }
    
    //更新时间
    if ([dict objectForKey:@"updateTime"] != [NSNull null]){
        self.updateTime = [dict objectForKey:@"updateTime"];
    }
    
    if ([dict objectForKey:@"parentCommentId"] != [NSNull null])
    {
        self.parentCommentId = [dict objectForKey:@"parentCommentId"];
    }
    
    self.userType = [[dict objectForKeyNotNull:@"userType"] integerValue];

    return self;
}

@end
