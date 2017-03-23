//
//  ParsModel.m
//  Shitan
//
//  Created by 刘敏 on 14-9-28.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "ParsModel.h"

@implementation ParsModel

+ (void)parsData:(NSDictionary *)result
    successBlock:(ParsModelBlock)successBlock
    failureBlock:(ParsModelBlock)failureBlock
{
    if (result) {
        // 状态
        NSInteger status = [[result objectForKey:@"code"] intValue];
        
        // 返回的数据
        NSDictionary *info = [result objectForKey:@"obj"];
        
        // 封装失败的数据
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:2];
        
        if ([result objectForKey:@"msg"]) {
            [dic setObject:[result objectForKey:@"msg"] forKey:@"msg"];
        }
        
        [dic setObject:[result objectForKey:@"code"] forKey:@"status"];
        
        
        switch (status) {
            case 200:
                if (info) {
                    successBlock(info);
                }
                break;
                
            case 500:
                failureBlock(dic);
                break;
                
                
            default:
                failureBlock(dic);
                break;
        }
    }
}

@end
