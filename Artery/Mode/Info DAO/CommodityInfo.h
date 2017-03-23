//
//  CommodityInfo.h
//  Shitan
//
//  Created by Richard Liu on 15/8/6.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommodityInfo : NSObject

@property (nonatomic, strong) NSString *ruleId;
@property (nonatomic, strong) NSString *productId;
@property (nonatomic, strong) NSString *orderNo;
@property (nonatomic, strong) NSString *pname;
@property (nonatomic, strong) NSString *did;

@property (nonatomic, assign) NSUInteger buyCount;      //购买数量

@property (nonatomic, strong) NSString *disCount;       //打折后的价格
@property (nonatomic, strong) NSString *price;

- (instancetype)initWithParsData:(NSDictionary *)dict;

@end
