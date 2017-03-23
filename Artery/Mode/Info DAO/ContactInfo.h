//
//  ContactInfo.h
//  Shitan
//
//  Created by 刘敏 on 15/1/14.
//  Copyright (c) 2015年 深圳食探网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactInfo : NSObject

@property (nonatomic, strong) NSString *contactId;                //通讯录ID
@property (nonatomic, strong) NSString *contactName;              //通讯录名字
@property (nonatomic, strong) NSString *followedUserId;           //被关注的ID

@property (nonatomic, assign) BOOL hasExistSystem;                //是否存在系统中
@property (nonatomic, assign) BOOL hasFollow;                     //关注状态

@property (nonatomic, strong) NSString *mobilePhone;              //手机号码
@property (nonatomic, strong) NSString *nickName;                 //昵称
@property (nonatomic, strong) NSString *userId;                   //登录用户的用户标识

- (instancetype)initWithParsData:(NSDictionary *)dict;

@end
