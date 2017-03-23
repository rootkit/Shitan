//
//  TipInfo.m
//  Shitan
//
//  Created by 刘敏 on 14-10-20.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "TipInfo.h"

@implementation TipInfo

- (instancetype)initWithParsData:(NSDictionary *)dict {
    
    if ([dict objectForKey:@"imgId"] != [NSNull null]) {
        self.imgId = [dict objectForKey:@"imgId"];
    }
    
    if ([dict objectForKey:@"createTime"] != [NSNull null]) {
        self.createTime = [dict objectForKey:@"createTime"];
    }

    //标签名
    if ([dict objectForKey:@"branchName"] != [NSNull null]  && [[dict objectForKey:@"branchName"] length] > 0) {
        
        NSString *nameT = nil;
        if ([dict objectForKey:@"tag"] != [NSNull null]) {
            nameT = [dict objectForKey:@"tag"];
        }
        
        self.title = [[[nameT stringByAppendingString:@"("] stringByAppendingString:[dict objectForKey:@"branchName"]] stringByAppendingString:@")"];
    }
    else
    {
        if ([dict objectForKey:@"tag"] != [NSNull null]) {
            self.title = [dict objectForKey:@"tag"];
        }
    }
    
    
    if ([dict objectForKey:@"tagId"] != [NSNull null]) {
        self.tagId = [dict objectForKey:@"tagId"];
    }
    
    
    // X
    if ([dict objectForKey:@"x"] != [NSNull null]) {
        self.point_X = [[dict objectForKey:@"x"] floatValue];
    }
    
    // Y
    if ([dict objectForKey:@"y"] != [NSNull null]) {
        self.point_Y = [[dict objectForKey:@"y"] floatValue];
    }
    
    // isLeft 1代表在左边， 0代表在右边
    if ([dict objectForKey:@"directionFlag"] != [NSNull null]) {
        // 常规标签
        self.isLeft = [[dict objectForKey:@"directionFlag"] integerValue];
    }
    
    if ([dict objectForKey:@"id"] != [NSNull null]) {
        self.mId = [[dict objectForKey:@"id"] integerValue];
    }
    
    //标签类型
    if ([dict objectForKey:@"tagType"] != [NSNull null]) {
        self.tipType = (MYTipsType)[[dict objectForKey:@"tagType"] integerValue];
    }
    
    return self;
}

@end
