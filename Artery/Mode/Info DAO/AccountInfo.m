//
//  AccountInfo.m
//  Shitan
//
//  Created by 刘敏 on 14-9-14.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//  账号信息

#import "AccountInfo.h"

@implementation AccountInfo

static AccountInfo * _userInfo = nil;


+ (AccountInfo *)sharedAccountInfo
{
    
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        _userInfo = [[self alloc] init];
        
    });
    
    return _userInfo;
}


- (void)parsAccountData:(NSDictionary *)dict
{
    
    if (!dict) {
        if ([[NSUserDefaults standardUserDefaults] dictionaryForKey:@"USER_INFO"]) {
            // 获取用户信息
            dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"USER_INFO"];
        }
    }

    NSMutableDictionary *accInfo = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    //账号类型
    if ([dict objectForKey:@"accountsource"] && [dict objectForKey:@"accountsource"]!= [NSNull null])
    {
        self.accountsource = [[dict objectForKey:@"accountsource"] integerValue];
        [accInfo setObject:[dict objectForKey:@"accountsource"] forKey:@"accountsource"];
    }
    
    //性别（0代表男，1代表女）
    if ([dict objectForKey:@"gender"] && [dict objectForKey:@"gender"]!= [NSNull null])
    {
        self.gender = [[dict objectForKey:@"gender"] integerValue];
        [accInfo setObject:[dict objectForKey:@"gender"] forKey:@"gender"];
    }
    
    //生日
    if ([dict objectForKey:@"birthday"] && [dict objectForKey:@"birthday"]!= [NSNull null])
    {
        self.birthday = [[dict objectForKey:@"birthday"] substringWithRange:NSMakeRange(0,10)];
        [accInfo setObject:self.birthday forKey:@"birthday"];
    }
    
    //城市
    if ([dict objectForKey:@"city"] && [dict objectForKey:@"city"]!= [NSNull null])
    {
        self.city = [dict objectForKey:@"city"];
        [accInfo setObject:[dict objectForKey:@"city"] forKey:@"city"];
    }
    
    
    //手机号码
    if ([dict objectForKey:@"mobile"] && [dict objectForKey:@"mobile"]!= [NSNull null])
    {
        self.mobile = [dict objectForKey:@"mobile"];
        [accInfo setObject:[dict objectForKey:@"mobile"] forKey:@"mobile"];
    }
    
    //姓名
    if ([dict objectForKey:@"name"] && [dict objectForKey:@"name"]!= [NSNull null])
    {
        self.name = [dict objectForKey:@"name"];
        [accInfo setObject:[dict objectForKey:@"name"] forKey:@"name"];
    }
    
    //昵称
    if ([dict objectForKey:@"nickname"] && [dict objectForKey:@"nickname"]!= [NSNull null])
    {
        self.nickname = [dict objectForKey:@"nickname"];
        [accInfo setObject:[dict objectForKey:@"nickname"] forKey:@"nickname"];
    }
    
    //头像
    if ([dict objectForKey:@"portraitUrl"] && [dict objectForKey:@"portraitUrl"]!= [NSNull null])
    {
        self.portraiturl = [dict objectForKey:@"portraitUrl"];
        [accInfo setObject:[dict objectForKey:@"portraitUrl"] forKey:@"portraitUrl"];
    }
    
    //用户ID
    if ([dict objectForKey:@"userId"] && [dict objectForKey:@"userId"]!= [NSNull null])
    {
        self.userId = [dict objectForKey:@"userId"];
        [accInfo setObject:[dict objectForKey:@"userId"] forKey:@"userId"];
    }
    
    
    //用户类型
    if ([dict objectForKey:@"userType"] && [dict objectForKey:@"userType"] != [NSNull null]) {
        self.userType = (STAccountType)[[dict objectForKey:@"userType"] integerValue];
        [accInfo setObject:[NSNumber numberWithInteger:self.userType] forKey:@"userType"];
    }
    
    //手机登录才有的Token
    if ([dict objectForKey:@"token"] && [dict objectForKey:@"token"] != [NSNull null])
    {
        self.token = [dict objectForKey:@"token"];
        [accInfo setObject:[dict objectForKey:@"token"] forKey:@"token"];
    }
    
    //QQ
    if ([dict objectForKey:@"qqId"] && [dict objectForKey:@"qqToken"]
        && [dict objectForKey:@"qqId"] != [NSNull null]
        && [dict objectForKey:@"qqToken"] != [NSNull null])
    {
        self.qqid = [dict objectForKey:@"qqId"];
        self.qqtoken = [dict objectForKey:@"qqToken"];
        
        
        [accInfo setObject:self.qqid forKey:@"qqId"];
        [accInfo setObject:self.qqtoken forKey:@"qqToken"];
        
    }
    
    
    //微博
    if ([dict objectForKey:@"weiboId"] && [dict objectForKey:@"weiboToken"] &&
        [dict objectForKey:@"weiboId"] != [NSNull null] &&
        [dict objectForKey:@"weiboToken"] != [NSNull null])
    {
        self.weiboid = [dict objectForKey:@"weiboId"];
        self.weibotoken = [dict objectForKey:@"weiboToken"];
        
        
        [accInfo setObject:self.weiboid forKey:@"weiboId"];
        [accInfo setObject:self.weibotoken forKey:@"weiboToken"];
    }
    
    //微信
    if ([dict objectForKey:@"weixinId"] && [dict objectForKey:@"weixinToken"] &&
        [dict objectForKey:@"weixinId"] != [NSNull null] &&
        [dict objectForKey:@"weixinToken"] != [NSNull null])
    {
        self.weixinid = [dict objectForKey:@"weixinId"];
        self.weixintoken = [dict objectForKey:@"weixinToken"];
        
        
        [accInfo setObject:self.weixinid forKey:@"weixinId"];
        [accInfo setObject:self.weixintoken forKey:@"weixinToken"];
    }
    
    //签名
    if ([dict objectForKey:@"signature"] && [dict objectForKey:@"signature"] != [NSNull null])
    {
        self.signature = [dict objectForKey:@"signature"];
        [accInfo setObject:self.signature forKey:@"signature"];
    }
    
    //密码
    if ([dict objectForKey:@"pwd"] && [dict objectForKey:@"pwd"] != [NSNull null]) {
        self.pwd = [dict objectForKey:@"pwd"];
        [accInfo setObject:self.pwd forKey:@"pwd"];
    }
    
    
    //关注
    if ([dict objectForKey:@"followedCount"] && [dict objectForKey:@"followedCount"] != [NSNull null]) {
        self.followedCount = [[dict objectForKey:@"followedCount"] integerValue];
        [accInfo setObject:[dict objectForKey:@"followedCount"] forKey:@"followedCount"];
    }
    
    
    //粉丝
    if ([dict objectForKey:@"followerCount"] && [dict objectForKey:@"followerCount"] != [NSNull null]) {
        self.fansCount = [[dict objectForKey:@"followerCount"] integerValue];
        [accInfo setObject:[dict objectForKey:@"followerCount"] forKey:@"followerCount"];
    }

    //图片数量
    if ([dict objectForKey:@"imgCount"] && [dict objectForKey:@"imgCount"] != [NSNull null]) {
        self.imgCount = [[dict objectForKey:@"imgCount"] integerValue];
        [accInfo setObject:[dict objectForKey:@"imgCount"] forKey:@"imgCount"];
    }
    
    // 缓存用户信息
    [[NSUserDefaults standardUserDefaults] setObject:accInfo forKey:@"USER_INFO"];

    CLog(@"%@", [AccountInfo sharedAccountInfo]);
}

- (void)setBusiness_userId:(NSString *)business_userId
{
    _business_userId = business_userId;
}

- (void)setAddressId:(NSString *)addressId
{
    _addressId = addressId;
}

- (void)setBusinessId:(NSInteger)businessId
{
    _businessId = businessId;
}


- (void)clearAccountInfo
{
    self.accountsource = 0;
    self.gender = 0;
    self.userType = 0;
    
    self.business_userId = nil;
    self.businessId = 0;
    self.addressId = nil;
    
    self.birthday = nil;
    self.city = nil;
    self.createtime = nil;
    self.lastmobilelogintime = nil;
    self.mobile = nil;
    self.mobileprefix = nil;
    self.name = nil;
    self.nickname = nil;
    self.portraiturl = nil;
    self.signature = nil;
    self.token = nil;
    self.updatetime = nil;
    self.userId = nil;
    self.qqid = nil;
    self.qqtoken = nil;
    self.weiboid = nil;
    self.weibotoken = nil;
    self.weixinid = nil;
    self.weixintoken = nil;

    self.pwd = nil;
}


@end
