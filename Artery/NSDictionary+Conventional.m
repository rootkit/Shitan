//
//  NSDictionary+Conventional.m
//  Shitan
//
//  Created by Richard Liu on 15/4/30.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "NSDictionary+Conventional.h"

@implementation NSDictionary (Conventional)

/**
 *  状态 200为正常，500异常
 *
 *  @return
 */
- (NSUInteger)code
{
    return[[self objectForKeyNotNull:@"code"] integerValue];
}

/**
 *  返回描述
 *
 *  @return 
 */
- (NSString *)msg
{
    return [self objectForKeyNotNull:@"msg"];
}



- (id)obj
{
    return [self objectForKeyNotNull:@"obj"];
}


@end
