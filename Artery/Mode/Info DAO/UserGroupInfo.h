//
//  UserGroupInfo.h
//  Shitan
//
//  Created by Avalon on 15/5/27.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface UserGroupInfo : NSObject

//用户的ID
@property (nonatomic ,copy) NSString *userId;

//用户优惠码
@property (nonatomic ,copy) NSString *code;

//用户红包余额
@property (nonatomic ,assign) float totalMoney;

//用户返利比例
@property (nonatomic ,assign) float percent;

//邀请的用户Id
@property (nonatomic ,copy) NSString *invited;

//创建时间
@property (nonatomic ,copy) NSString *createTime;

//更新时间
@property (nonatomic ,copy) NSString *updateTime;

//最小提现数
@property (nonatomic ,assign) float cashMin;

//是否在提现
@property (nonatomic ,assign) int cashing;

- (instancetype)initWithParsData:(NSDictionary *)dict;

@end
