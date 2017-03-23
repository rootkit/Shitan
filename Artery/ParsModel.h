//
//  ParsModel.h
//  Shitan
//
//  Created by 刘敏 on 14-9-28.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//  网络请求返回数据封装

#import <Foundation/Foundation.h>

typedef void(^ParsModelBlock)(NSDictionary * dict);

@interface ParsModel : NSObject

+ (void)parsData:(NSDictionary *)result
    successBlock:(ParsModelBlock)successBlock
    failureBlock:(ParsModelBlock)failureBlock;

@end
