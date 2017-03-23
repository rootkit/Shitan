//
//  MessageInfo.h
//  Shitan
//
//  Created by Jia HongCHI on 14/10/25.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageInfo : NSObject

@property (nonatomic, strong) NSString *createTime; 
@property (nonatomic, strong) NSString *extra;             //当messageType为1的时候为跳转连接，其他如果不为空则为图片连接
@property (nonatomic, strong) NSString *messageId;        //消息ID
@property (nonatomic, strong) NSString *imgId;            //图片ID
@property (nonatomic, assign) NSInteger messageType;      //消息类型
@property (nonatomic, strong) NSString *nickname;         //用户昵称（评论方）
@property (nonatomic, strong) NSString *portraitUrl;      //用户头像（评论方）

@property (nonatomic, assign) NSUInteger userType;        //账户类型 （评论方）

@property (nonatomic, strong) NSString *receiverId;       //用户ID（接收方）
@property (nonatomic, strong) NSString *senderId;         //用户ID（评论方）

- (instancetype)initWithParsData:(NSDictionary *)dict;

@end
