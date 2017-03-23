//
//  WXPayAPI.h
//  Shitan
//
//  Created by Richard Liu on 15/5/30.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "ApiXml.h"

@interface WXPayAPI : NSObject

//支付签名
- (NSMutableDictionary *)sendPaySign:(NSString *)prepayId;

@end
