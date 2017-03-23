//
//  OrderInfo.h
//  Shitan
//
//  Created by Richard Liu on 15/6/17.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderInfo : NSObject

@property (nonatomic, strong) NSString *addressId;
@property (nonatomic, strong) NSString *businessId;
@property (nonatomic, strong) NSString *businessName;

@property (nonatomic, strong) NSString *couponId;           //优惠券ID
@property (nonatomic, strong) NSString *createTime;         //创建时间

@property (nonatomic, assign) NSUInteger deliveryMoney;     //快递费用
@property (nonatomic, strong) NSString *deliveryTime;       //发货时间

@property (nonatomic, strong) NSString *note;

@property (nonatomic, strong) NSString *orderNO;            //订单号
@property (nonatomic, assign) NSUInteger payMethod;         //支付方式


@property (nonatomic, strong) NSString *realMoney;          //实付金额
@property (nonatomic, assign) NSUInteger state;             //订单状态
@property (nonatomic, strong) NSString *totalMoney;         //总计金额


- (instancetype)initWithParsData:(NSDictionary *)dict;

@end
