//
//  PersonalInfo.h
//  Shitan
//
//  Created by 刘敏 on 14-10-15.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonalInfo : NSObject

@property (assign, nonatomic) NSInteger accountsource;       //账号类型
@property (assign, nonatomic) NSInteger gender;              //性别（0代表男，1代表女）
@property (assign, nonatomic) NSInteger m_ID;                //ID


@property (assign, nonatomic) NSInteger followedCount;       //关注数
@property (assign, nonatomic) NSInteger fansCount;           //粉丝数
@property (assign, nonatomic) NSInteger imgCount;            //图片数

@property (strong, nonatomic) NSString *birthday;            //生日
@property (strong, nonatomic) NSString *city;                //城市

@property (strong, nonatomic) NSString *lastmobilelogintime; //最后一次登录时间
@property (strong, nonatomic) NSString *mobile;              //手机号码
@property (strong, nonatomic) NSString *mobileprefix;        //区域编号
@property (strong, nonatomic) NSString *name;                //姓名
@property (strong, nonatomic) NSString *nickname;            //昵称
@property (strong, nonatomic) NSString *portraiturl;         //头像


@property (strong, nonatomic) NSString *signature;           //签名
@property (strong, nonatomic) NSString *updatetime;          //更新时间

@property (strong, nonatomic) NSString *userId;              //用户ID
@property (assign, nonatomic) NSUInteger userType;           //账户类型

@property (strong, nonatomic) NSString *followedUserId;
@property (strong, nonatomic) NSString *followerUserId;
@property (nonatomic, assign) NSInteger hasFollow;


- (instancetype)initWithParsData:(NSDictionary *)dict;


@end
