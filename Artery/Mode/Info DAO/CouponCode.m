//
//  CouponCode.m
//  Shitan
//
//  Created by Avalon on 15/5/28.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import "CouponCode.h"

@interface CouponCode ()

//用户的ID,初始化传此参数
@property (nonatomic, copy) NSString *userId;
//用户优惠码
@property (nonatomic, copy) NSString *code;
//用户红包余额
@property (nonatomic, assign) float totalMoney;
//用户返利比例，比如 0.02=2%
@property (nonatomic, assign) float percent;
//邀请的用户Id
@property (nonatomic, copy) NSString *invited;
//创建时间
@property (nonatomic, copy) NSString *createTime;
//更新时间
@property (nonatomic, copy) NSString *updateTime;
//最小提现数
@property (nonatomic, assign) float cashMin;



@end


@implementation CouponCode



@end
