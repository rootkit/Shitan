//
//  MerchantInfo.h
//  Shitan
//
//  Created by Richard Liu on 15/6/26.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MerchantInfo : NSObject

@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *addressId;          //地址ID
@property (nonatomic, strong) NSString *businessId;         //商户ID
@property (nonatomic, strong) NSString *name;               //商户名称

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *des;

@property (nonatomic, strong) NSString *logoUrl;

@property (nonatomic, strong) NSString *coverUrl;
@property (nonatomic, strong) NSString *imgUrl;

@property (nonatomic, strong) NSString *createTime;

@property (nonatomic, strong) NSString *businessTime;       //营业时间

@property (nonatomic, strong) NSString *deliveryNote;       //配送方式
@property (nonatomic, assign) NSUInteger deliveryMoney;      //配送费用

@property (nonatomic, assign) NSUInteger state;             //状态
@property (nonatomic, strong) NSString *tips;               //注意事项

@property (nonatomic, assign) NSUInteger lowestMoney;       //起送金额


- (instancetype)initWithParsData:(NSDictionary *)dict;

@end
