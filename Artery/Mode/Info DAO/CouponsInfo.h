//
//  CouponsInfo.h
//  Shitan
//
//  Created by Richard Liu on 15/4/29.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CouponsInfo : NSObject

@property (nonatomic, strong) NSString *couponsId;
@property (nonatomic, strong) NSString *businessId;
@property (nonatomic, strong) NSString *useBusinessId;      //使用者当前所在的商铺ID

@property (nonatomic, strong) NSString *businessName;       //商户名称

@property (nonatomic, strong) NSString *beginTime;          //开始时间
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *endTime;


@property (nonatomic, assign) BOOL isLimit;                 //是否有限制
@property (nonatomic, assign) BOOL isValid;                 //是有效的
@property (nonatomic, assign) BOOL hasUse;                  //是否已经使用

@property (nonatomic, assign) NSUInteger lowMoney;          //最低消费金额
@property (nonatomic, assign) NSUInteger money;             //优惠金额

@property (nonatomic, strong) NSString *name;               //优惠券名称

@property (nonatomic, assign) NSUInteger type;              //优惠券类型


- (instancetype)initWithParsData:(NSDictionary *)dict;

@end
