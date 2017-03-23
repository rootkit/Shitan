//
//  WXPayAPI.m
//  Shitan
//
//  Created by Richard Liu on 15/5/30.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "WXPayAPI.h"
#import "MD5Hash.h"

//商户号，填写商户对应参数
#define MCH_ID          @"1235377502"

//商户API密钥，填写相应参数
#define PARTNER_ID      @"0777bbd7c4bbeff26b2d14903bf646e0"

@implementation WXPayAPI


//支付签名
- (NSMutableDictionary *)sendPaySign:(NSString *)prepayId
{
    //扩展字段
    NSString *package = @"Sign=WXPay";

    //设置支付参数
    time_t now;
    time(&now);
    
    //时间戳
    NSString *time_stamp  = [NSString stringWithFormat:@"%ld", now];

    //随机字符串(调用随机数函数生成，将得到的值转换为字符串)
    NSString *nonce_str = [[MD5Hash getMd5_32Bit_String:time_stamp] uppercaseString];
    
    //重新按提交格式组包，微信客户端暂只支持package=Sign=WXPay格式，须考虑升级后支持携带package具体参数的情况
    //package = [NSString stringWithFormat:@"Sign=%@",package];
    
    //第二次签名参数列表
    NSMutableDictionary *signParams = [NSMutableDictionary dictionary];
    
    //APPID
    [signParams setObject:K_WEIXIN_APP_KEY forKey:@"appid"];
    
    //随机码
    [signParams setObject:nonce_str forKey:@"noncestr"];
    
    //扩展字段
    [signParams setObject:package forKey:@"package"];
    
    //商户号
    [signParams setObject:MCH_ID forKey:@"partnerid"];
    
    //时间戳
    [signParams setObject:time_stamp forKey:@"timestamp"];
    
    //预支付交易会话ID
    [signParams setObject:prepayId forKey:@"prepayid"];
    
    
    //生成签名
    NSString *sign  = [self createMd5Sign:signParams];
    
    //添加签名
    [signParams setObject:sign forKey:@"sign"];
    CLog(@"签名成功，sign＝%@\n", sign);
    
    //返回参数列表
    return signParams;
}


//创建支付package签名
- (NSString *)createMd5Sign:(NSMutableDictionary*)dict
{
    NSMutableString *contentString  =[NSMutableString string];
    NSArray *keys = [dict allKeys];
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    
    //拼接字符串
    for (NSString *categoryId in sortedArray) {
        if (   ![[dict objectForKey:categoryId] isEqualToString:@""]
            && ![categoryId isEqualToString:@"sign"]
            && ![categoryId isEqualToString:@"key"]
            )
        {
            [contentString appendFormat:@"%@=%@&", categoryId, [dict objectForKey:categoryId]];
        }
        
    }
    
    //添加key字段
    [contentString appendFormat:@"key=%@", PARTNER_ID];
    CLog(@"MD5签名字符串:\n%@\n\n", contentString);
    
    //得到MD5 sign签名
    NSString *md5Sign = [[MD5Hash getMd5_32Bit_String:contentString] uppercaseString];
    
    return md5Sign;;
}


@end
