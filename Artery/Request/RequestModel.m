//
//  RequestModel.m
//  Artery
//
//  Created by 刘敏 on 14-9-15.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//
//  封装网络请求

#import "RequestModel.h"
#import <ASIHTTPRequest/ASIHTTPRequest.h>
#import <ASIHTTPRequest/ASIFormDataRequest.h>
#import "JDStatusBarNotification.h"
#import "DPAPI.h"

static RequestModel *instance = nil;

@implementation RequestModel


+ (id)shareInstance {
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}


/**
 *  GET请求(带参)
 *
 *  @param api             接口名字
 *  @param getDict         GET数据 （字典）
 *  @param completionBlock 成功返回字典
 *  @param failedBlock     失败返回字典
 */
- (void)requestModelWithAPI:(NSString *)api
                    getDict:(NSDictionary *)getDict
            completionBlock:(RequestModelBlock)completionBlock
             setFailedBlock:(RequestModelBlock)failedBlock
{
    ASIHTTPRequest *request = nil;
    
    
    //非腾讯接口
    if ([api hasPrefix:@"http://apis.map.qq.com"] || [api hasPrefix:@"https://api.weixin.qq.com"]) {
        CLog(@"测试");
    }
    else
    {
        //封装token跟、tokenUserID
        getDict = [self insertTokenValidation:getDict];
    }
    
    
    NSString *urlStr = nil;
    if ([api hasPrefix:@"http://"] || [api hasPrefix:@"https://"]) {
        urlStr = api;
    }
    else{
        urlStr = [NSString stringWithFormat:@"%@%@", URL_Common, api];
    }
    
    if ([getDict count]) {
        
        // 存储get数据
        NSMutableArray *getArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        NSArray *allKeys = [getDict allKeys];
        for (int i=0; i<[allKeys count]; i++) {
            
            NSString *key = [allKeys objectAtIndex:i];
            NSString *value = [getDict objectForKey:key];
            
            if (value) {
                [getArray addObject:[NSString stringWithFormat:@"%@=%@", key, value]];
            }
        }
        
        urlStr = [NSString stringWithFormat:@"%@%@", urlStr, [getArray componentsJoinedByString:@"&"]];
        
        //中文字符转UTF8
        urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
        
        [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded; charset=UTF-8"];
        [request setRequestMethod:@"GET"];
        
    }
    else {
        request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    }
    
    [request startAsynchronous];
    
    ASIHTTPRequest *requestTemp = request;
    
    [request setCompletionBlock:^{
        NSDictionary *dict = nil;
        if (requestTemp.responseData) {
            dict = [STJSONSerialization JSONObjectWithData:requestTemp.responseData];
        }
        
        if ([[dict objectForKey:@"code"] integerValue] == 400 ) {
            completionBlock(nil);
            [theAppDelegate loginOut];
            MET_MIDDLE(@"登录超时");
        }
        else{
            completionBlock(dict);
        }
    }];
    
    
    [request setFailedBlock:^{
        [self showNetworkTips];
        completionBlock(nil);
    }];
}



/**
 *  POST请求(带参)
 *
 *  @param api             接口名字
 *  @param postDict        POST数据（字典）
 *  @param  成功返回字典
 *  @param failedBlock     失败返回字典
 */
- (void)requestModelWithAPI:(NSString *)api
                   postDict:(NSDictionary *)postDict
            completionBlock:(RequestModelBlock)completionBlock
             setFailedBlock:(RequestModelBlock)failedBlock
{
    //封装token跟、tokenUserID
    postDict = [self insertTokenValidation:postDict];
    
    
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:api]];
    
    if ([postDict count]) {
        
        NSArray *allKeys = [postDict allKeys];
        for (int i=0; i<[allKeys count]; i++) {
            NSString *key = [allKeys objectAtIndex:i];
            NSString *value = [postDict objectForKey:key];
            [request addPostValue:value forKey:key];
        }
        
        [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded; charset=UTF-8"];
        [request setRequestMethod:@"POST"];
        
    }
    
    
    [request startAsynchronous];
    
    ASIHTTPRequest *requestTemp = request;
    
    [request setCompletionBlock:^{
        NSDictionary *dict = nil;
        if (requestTemp.responseData) {
            dict = [STJSONSerialization JSONObjectWithData:requestTemp.responseData];
        }
        if ([[dict objectForKey:@"code"] integerValue] == 400 ) {
            completionBlock(nil);
            [theAppDelegate loginOut];
            MET_MIDDLE(@"登录超时");
        }
        else{
            completionBlock(dict);
        }
    }];
    
    
    [request setFailedBlock:^{
        [self showNetworkTips];
        completionBlock(nil);
    }];
}




/**
 *  上传图片
 *
 *  @param api             接口名字
 *  @param image           图片数据
 *  @param completionBlock 成功返回的字典
 *  @param failedBlock     失败返回的字典
 */
- (void)requestModelWithAPI:(NSString *)api
                  postImage:(UIImage *)image
            completionBlock:(RequestModelBlock)completionBlock
             setFailedBlock:(RequestModelBlock)failedBlock
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:api]];
    
    if (image) {
        
        NSData *imageData =  UIImageJPEGRepresentation(image, 1);
        
        NSString *usName = [NSString stringWithFormat:@"%@.jpg", [Units formatTimeAsFileName]];
        [request setData:imageData withFileName:usName andContentType:@"image/jpg" forKey:@"file"];
        
    }
    
    
    //增加Token
    if ([AccountInfo sharedAccountInfo].token && [AccountInfo sharedAccountInfo].userId) {
        //token
        [request addPostValue:[AccountInfo sharedAccountInfo].token forKey:@"token"];
        //token
        [request addPostValue:[AccountInfo sharedAccountInfo].userId forKey:@"tokenUserId"];
    }
    //device type,也就是设备类型 如android: 0表示(默认), ios:1
    [request addPostValue:@"1" forKey:@"dtype"];
    [request addPostValue:APP_Version forKey:@"v"];
    
    
    
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded; charset=UTF-8"];
    [request setRequestMethod:@"POST"];
    
    [request startAsynchronous];
    
    
    ASIHTTPRequest *requestTemp = request;
    
    [request setCompletionBlock:^{
        NSDictionary *dict = nil;
        if (requestTemp.responseData) {
            dict = [STJSONSerialization JSONObjectWithData:requestTemp.responseData];
        }
        
        if ([[dict objectForKey:@"code"] integerValue] == 400 ) {
            completionBlock(nil);
            [theAppDelegate loginOut];
            MET_MIDDLE(@"登录超时");
        }
        else{
            completionBlock(dict);
        }
        
    }];
    
    
    [request setFailedBlock:^{
        [self showNetworkTips];
        completionBlock(nil);
        
    }];
}



/**
 *  上传文件
 *
 *  @param api             接口名字
 *  @param pathName        文件路径
 *  @param completionBlock 成功返回闭包
 *  @param failedBlock     失败返回闭包
 */
- (void)requestModelWithAPI:(NSString *)api
                  postFiles:(NSString *)pathName
            completionBlock:(RequestModelBlock)completionBlock
             setFailedBlock:(RequestModelBlock)failedBlock
{
    
    CLog(@"%@", api);
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:api]];
    
    if (pathName) {
        [request setFile:pathName forKey:@"file"];
        
    }
    //增加Token
    if ([AccountInfo sharedAccountInfo].token && [AccountInfo sharedAccountInfo].userId) {
        //token
        [request addPostValue:[AccountInfo sharedAccountInfo].token forKey:@"token"];
        //token
        [request addPostValue:[AccountInfo sharedAccountInfo].userId forKey:@"tokenUserId"];
    }
    
    //device type,也就是设备类型 如android: 0表示(默认), ios:1
    [request addPostValue:@"1" forKey:@"dtype"];
    [request addPostValue:APP_Version forKey:@"v"];
    
    
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded; charset=UTF-8"];
    [request setRequestMethod:@"POST"];
    
    
    [request startAsynchronous];
    
    ASIHTTPRequest *requestTemp = request;
    
    
    
    [request setCompletionBlock:^{
        NSDictionary *dict = nil;
        if (requestTemp.responseData) {
            dict = [STJSONSerialization JSONObjectWithData:requestTemp.responseData];
        }
        
        if ([[dict objectForKey:@"code"] integerValue] == 400 ) {
            completionBlock(nil);
            [theAppDelegate loginOut];
            MET_MIDDLE(@"登录超时");
        }
        else{
            completionBlock(dict);
        }
        
    }];
    
    
    [request setFailedBlock:^{
        [self showNetworkTips];
        completionBlock(nil);
        
    }];
}

/**
 *  插入Token、tokenUserID、版本号、系统型号
 *
 *  @param dic <#dic description#>
 *
 *  @return <#return value description#>
 */
- (NSDictionary *)insertTokenValidation:(NSDictionary *)dic
{
    NSMutableDictionary *mDic = [[NSMutableDictionary alloc] init];
    
    if (dic) {
        [mDic addEntriesFromDictionary:dic];
    }
    
    if ([AccountInfo sharedAccountInfo].token && [AccountInfo sharedAccountInfo].userId) {
        //token
        [mDic setObject:[AccountInfo sharedAccountInfo].token forKey:@"token"];
        //token
        [mDic setObject:[AccountInfo sharedAccountInfo].userId forKey:@"tokenUserId"];
    }
    
    //device type,也就是设备类型 如android: 0表示(默认), ios:1
    [mDic setObject:@"1" forKey:@"dtype"];
    [mDic setObject:APP_Version forKey:@"v"];
    
    
    return mDic;
}



- (void)showNetworkTips
{
    [JDStatusBarNotification addStyleNamed:@"SBStyle1"
                                   prepare:^JDStatusBarStyle *(JDStatusBarStyle *style) {
                                       style.barColor = [UIColor colorWithRed:0.797 green:0.000 blue:0.662 alpha:1.000];
                                       style.textColor = [UIColor whiteColor];
                                       style.animationType = JDStatusBarAnimationTypeFade;
                                       style.font = [UIFont fontWithName:@"SnellRoundhand-Bold" size:17.0];
                                       style.progressBarColor = [UIColor colorWithRed:0.986 green:0.062 blue:0.598 alpha:1.000];
                                       style.progressBarHeight = 20.0;
                                       return style;
                                   }];
    
    
    
    [JDStatusBarNotification showWithStatus:@"网络连接失败"
                               dismissAfter:2.0
                                  styleName:JDStatusBarStyleError];
}





/********************************************** 大众点评 ********************************/

- (void)requestModelWithDianPingAPI:(NSString *)api
                            getDict:(NSDictionary *)getDict
                    completionBlock:(RequestModelBlock)completionBlock
                     setFailedBlock:(RequestModelBlock)failedBlock
{
    ASIHTTPRequest *request = nil;
    
    
    DPAPI *dInfo = [DPAPI sharedDPAPI];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:getDict];
    
    [dInfo requestWithURL:api params:dic];
    NSString *urlStr = dInfo.urlString;
    
    
    request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    
    [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded; charset=UTF-8"];
    [request setRequestMethod:@"GET"];
    
    [request startAsynchronous];
    ASIHTTPRequest *requestTemp = request;
    
    [request setCompletionBlock:^{
        NSDictionary *dict = nil;
        if (requestTemp.responseData) {
            dict = [STJSONSerialization JSONObjectWithData:requestTemp.responseData];
        }
        
        if ([[dict objectForKey:@"status"] isEqualToString:@"OK"]) {
            completionBlock(dict);
        }
        else{
            completionBlock(nil);
        }
    }];
    
    
    [request setFailedBlock:^{
        [self showNetworkTips];
        completionBlock(nil);
    }];
}



@end
