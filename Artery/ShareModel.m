//
//  ShareModel.m
//  Shitan
//
//  Created by 刘敏 on 14/12/19.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "ShareModel.h"
#import "UMSocial.h"

@implementation ShareModel

static ShareModel * _getInstance = nil;

//单列
+ (ShareModel *)getInstance
{
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        _getInstance = [[self alloc] init];
        
    });
    
    return _getInstance;
}




// 微信(朋友圈)
- (void)wechatInvitation
{
    NSString *url = URL_Domain;
    
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = [url stringByAppendingString:[NSString stringWithFormat:@"?strform=Weixin&uid=%@&stype=invite", [AccountInfo sharedAccountInfo].userId]];
    
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:@"逛同城美食街—食探APP | 看看这座城市大家都在吃什么" image:[UIImage imageNamed:@"Icon.png"] location:nil urlResource:nil presentedController:nil completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            CLog(@"分享成功！");
        }
    }];
}


// 微信好友
- (void)wechatFriendsInvitation
{
    NSString *url = URL_Domain;
    
    [UMSocialData defaultData].extConfig.title = SHARE_TITLE;

    [UMSocialData defaultData].extConfig.wechatSessionData.url = [url stringByAppendingString:[NSString stringWithFormat:@"?strform=Weixin&uid=%@&stype=invite", [AccountInfo sharedAccountInfo].userId]];
    
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:SHARE_CONTENT image:[UIImage imageNamed:@"Icon.png"] location:nil urlResource:nil presentedController:nil completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            CLog(@"分享成功！");
        }
    }];
}

// QQ好友
- (void)qqInvitation
{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
    
        NSString *url = URL_Domain;
        
        [UMSocialData defaultData].extConfig.title = SHARE_TITLE;
        [UMSocialData defaultData].extConfig.qqData.url = [url stringByAppendingString:[NSString stringWithFormat:@"?strform=QQ&uid=%@&stype=invite", [AccountInfo sharedAccountInfo].userId]];
        
        
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:SHARE_CONTENT image:[UIImage imageNamed:@"Icon.png"] location:nil urlResource:nil presentedController:nil completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                CLog(@"分享成功！");
            }
        }];
        
    }
    else{
        
        MET_MIDDLE(@"未安装QQ App");
        
    }
}


//邀请QQ空间
- (void)qzoneInvitation
{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
        NSString *url = URL_Domain;
        [UMSocialData defaultData].extConfig.title = SHARE_TITLE;
        [UMSocialData defaultData].extConfig.qzoneData.url = [url stringByAppendingString:[NSString stringWithFormat:@"?strform=QQ&uid=%@&stype=invite", [AccountInfo sharedAccountInfo].userId]];

        
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:SHARE_CONTENT image:[UIImage imageNamed:@"Icon.png"] location:nil urlResource:nil presentedController:nil completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                CLog(@"分享成功！");
            }
        }];
    }
    else{
        
        MET_MIDDLE(@"未安装QQ App");
        
    }
}


//邀请
- (void)weiboInvitation:(NSString *)nickName
{
    NSString *content = nil;
    
    if (nickName) {
        [theAppDelegate.HUDManager showSimpleTip:@"正在发送邀请" interval:NSNotFound];
        
        content = [NSString stringWithFormat:@"@%@ 终于找到了一款可以逛同城美食的APP，推荐给你。下载地址%@?strform=Weibo&uid=%@&stype=invite。在食探App里添加好友搜“%@”，就可以看到我的美食日记啦！",nickName, URL_Domain, [AccountInfo sharedAccountInfo].userId, [AccountInfo sharedAccountInfo].nickname];
    }
    else{
        
        [theAppDelegate.HUDManager showSimpleTip:@"正在发送分享" interval:NSNotFound];
        
        content = [NSString stringWithFormat:@"终于找到了一款可以逛同城美食的APP，推荐给大家。下载地址%@?strform=Weibo&uid=%@&stype=invite。在食探App里添加好友搜“%@”，就可以看到我的美食日记啦！",URL_Domain, [AccountInfo sharedAccountInfo].userId, [AccountInfo sharedAccountInfo].nickname];
    }
    

    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:content image:[UIImage imageNamed:@"share_cover.jpg"]  location:nil urlResource:nil presentedController:nil completion:^(UMSocialResponseEntity *shareResponse){
        if (shareResponse.responseCode == UMSResponseCodeSuccess) {
            
            [theAppDelegate.HUDManager hideHUD];
            if(nickName)
            {
                MET_MIDDLE(@"邀请成功！");
            }
            else{
                MET_MIDDLE(@"分享成功！");
            }
        }
        else{
            MET_MIDDLE(@"发送失败！");
            [theAppDelegate.HUDManager hideHUD];
        }
    }];

}


//发布图片到微博
- (void)sendMessageToWeibo:(UIImage *)image
               description:(NSString *)describe

{
    NSString *content = [describe stringByAppendingString:@" @食探App"];


    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:content image:image  location:nil urlResource:nil presentedController:nil completion:^(UMSocialResponseEntity *shareResponse){
        if (shareResponse.responseCode == UMSResponseCodeSuccess) {
            
            MET_MIDDLE(@"分享成功！");

        }
        else{
            MET_MIDDLE(@"发送失败！");
        }
    }];

}



///*********************************** 分享 ************************************/

//QQ好友
- (void)qqFriendsShareMessageWithUrl:(NSString *)url
                           thumbnail:(NSData *)thumbnailData
                            describe:(NSString *)describe
                               title:(NSString *)tit
{
    
    if (!tit) {
        tit = @"美食推荐";
    }
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
        [UMSocialData defaultData].extConfig.title = tit;
        [UMSocialData defaultData].extConfig.qqData.url = url;
        
        
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:describe image:[UIImage imageWithData:thumbnailData] location:nil urlResource:nil presentedController:nil completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                CLog(@"分享成功！");
            }
        }];
    }
    else{
        
        MET_MIDDLE(@"未安装QQ App");
        
    }
}


//QQ空间
- (void)qqZoneShareMessageWithUrl:(NSString *)url
                        thumbnail:(NSData *)thumbnailData
                         describe:(NSString *)describe
                            title:(NSString *)tit
{
    
    if (!tit) {
        tit = @"美食推荐";
    }
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
        [UMSocialData defaultData].extConfig.title = tit;
        [UMSocialData defaultData].extConfig.qzoneData.url = url;
        
        
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:describe image:[UIImage imageWithData:thumbnailData] location:nil urlResource:nil presentedController:nil completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                CLog(@"分享成功！");
            }
        }];
    }
    else{
        
        MET_MIDDLE(@"未安装QQ App");
        
    }
}



- (void)weiboShareMessageWithUrl:(NSString *)url
                       thumbnail:(NSString *)thumbnail
                        describe:(NSString *)describe
                           title:(NSString *)tit;
{
    
     
    

}


//微信好友
- (void)wechatFriendsMessageWithUrl:(NSString *)url
                          thumbnail:(NSData *)thumbnailData
                           describe:(NSString *)describe
                              title:(NSString *)tit
{
    
    if (!tit) {
        tit = @"美食推荐";
    }

    [UMSocialData defaultData].extConfig.title = tit;
    
    [UMSocialData defaultData].extConfig.wechatSessionData.url = url;
    
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:describe image:[UIImage imageWithData:thumbnailData] location:nil urlResource:nil presentedController:nil completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            CLog(@"分享成功！");
        }
    }];
}


//微信朋友圈
- (void)wechatCircleMessageWithUrl:(NSString *)url
                         thumbnail:(NSData *)thumbnailData
                          describe:(NSString *)describe
                             title:(NSString *)tit
{
    
    if (!tit) {
        tit = @"美食推荐";
    }
    
    [UMSocialData defaultData].extConfig.title = describe;
    CLog(@"%@",url);
    
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = url;
    
    //[UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeApp;
    
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:describe image:[UIImage imageWithData:thumbnailData] location:nil urlResource:nil presentedController:nil completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            CLog(@"分享成功！");
        }
    }];
    
}


///***********************************团购返利**********************************/

//QQ好友
- (void)qqFriendsShareRebateCodeWithUrl:(NSString *)url
                           thumbnail:(NSData *)thumbnailData
                            describe:(NSString *)describe
                               title:(NSString *)tit
{
    
    if (!tit) {
        tit = @"快来返利";
    }
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
        [UMSocialData defaultData].extConfig.title = tit;
        [UMSocialData defaultData].extConfig.qqData.shareText = describe;
        
        
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:describe image:[UIImage imageNamed:@"group_package"] location:nil urlResource:nil presentedController:nil completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                CLog(@"分享成功！");
            }
        }];
    }
    else{
        
        MET_MIDDLE(@"未安装QQ App");
        
    }
}


//QQ空间
- (void)qqZoneShareRebateCodeWithUrl:(NSString *)url
                        thumbnail:(NSData *)thumbnailData
                         describe:(NSString *)describe
                            title:(NSString *)tit
{
    
    
}


//新浪微博
- (void)weiboShareRebateCodeWithUrl:(NSString *)url
                       thumbnail:(NSData *)thumbnailData
                        describe:(NSString *)describe
                           title:(NSString *)tit
{
    
    if (!tit) {
        tit = @"快来返利";
    }
    
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"sinaweibo://"]]) {
        [UMSocialData defaultData].extConfig.title = tit;
        //[UMSocialData defaultData].extConfig.sinaData.shareText = @"啊哈";
        NSString *describeWithUrl = [NSString stringWithFormat:@"%@ http://baidu.com",describe];
        
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:describeWithUrl image:[UIImage imageNamed:@"group_package"] location:nil urlResource:nil presentedController:nil completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                CLog(@"分享成功！");
            }
        }];
    }
    else{
        
        MET_MIDDLE(@"未安装微博 App");
        
    }
    

    
    
}


//微信好友
- (void)wechatFriendsRebateCodeWithUrl:(NSString *)url
                          thumbnail:(NSData *)thumbnailData
                           describe:(NSString *)describe
                              title:(NSString *)tit
{
    
    if (!tit) {
        tit = @"快来返利";
    }
    
    [UMSocialData defaultData].extConfig.title = tit;
    [UMSocialData defaultData].extConfig.wechatSessionData.url = url;
    
    
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:describe image:[UIImage imageNamed:@"group_package"] location:nil urlResource:nil presentedController:nil completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            CLog(@"分享成功！");
        }
    }];
}


//微信朋友圈
- (void)wechatCircleRebateCodeWithUrl:(NSString *)url
                         thumbnail:(NSData *)thumbnailData
                          describe:(NSString *)describe
                             title:(NSString *)tit
{
    
    if (!tit) {
        tit = @"快来返利";
    }
    
    [UMSocialData defaultData].extConfig.title = describe;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = url;
    
    
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:describe image:[UIImage imageNamed:@"group_package"] location:nil urlResource:nil presentedController:nil completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            CLog(@"分享成功！");
        }
    }];
    
    
}

@end
