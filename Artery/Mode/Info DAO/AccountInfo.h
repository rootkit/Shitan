//
//  AccountInfo.h
//  Shitan
//
//  Created by 刘敏 on 14-9-14.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//  账户信息

#import <Foundation/Foundation.h>


@interface AccountInfo : NSObject

@property (assign, nonatomic) NSInteger accountsource;       //账号类型
@property (assign, nonatomic) NSInteger gender;              //性别（0代表男，1代表女）


@property (assign, nonatomic) NSInteger followedCount;       //关注数
@property (assign, nonatomic) NSInteger fansCount;           //粉丝数
@property (assign, nonatomic) NSInteger imgCount;            //图片数

@property (strong, nonatomic) NSString *birthday;            //生日
@property (strong, nonatomic) NSString *city;                //城市
@property (strong, nonatomic) NSString *createtime;          //城市

@property (strong, nonatomic) NSString *lastmobilelogintime; //最后一次登录时间
@property (strong, nonatomic) NSString *mobile;              //手机号码
@property (strong, nonatomic) NSString *mobileprefix;        //区域编号
@property (strong, nonatomic) NSString *name;                //姓名
@property (strong, nonatomic) NSString *nickname;            //昵称
@property (strong, nonatomic) NSString *portraiturl;         //头像

@property (assign, nonatomic) STAccountType userType;            //账户类型（0普通用户，1、普通管理员，2、超级管理员, 10、食探大V，99、商家）


@property (strong, nonatomic) NSString *signature;           //签名
@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic) NSString *updatetime;          //更新时间

@property (strong, nonatomic) NSString *userId;              //用户ID

@property (strong, nonatomic) NSString *qqid;
@property (strong, nonatomic) NSString *qqtoken;

@property (strong, nonatomic) NSString *weiboid;
@property (strong, nonatomic) NSString *weibotoken;

@property (strong, nonatomic) NSString *weixinid;
@property (strong, nonatomic) NSString *weixintoken;



//商家才有的属性
@property (strong, nonatomic) NSString *business_userId;    //商家在系统中注册的用户Id, 和普通用户一样
@property (strong, nonatomic) NSString *addressId;          //商家的地址ID

@property (assign, nonatomic) NSInteger businessId;         //商户ID


/******************************* 手机端自用的字段  ************************/
@property (strong, nonatomic) NSString *pwd;                 //密码(MD5之后的值)

+ (AccountInfo *)sharedAccountInfo;

//解析用户数据
- (void)parsAccountData:(NSDictionary *)dict;

//清空数据
- (void)clearAccountInfo;

@end
