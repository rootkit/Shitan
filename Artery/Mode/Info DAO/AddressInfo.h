//
//  AddressInfo.h
//  Shitan
//
//  Created by Richard Liu on 15/6/10.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressInfo : NSObject

@property (nonatomic, strong) NSString *addressId;
@property (nonatomic, strong) NSString *deliverName;

@property (nonatomic, strong) NSString *province;   //省
@property (nonatomic, strong) NSString *city;       //市
@property (nonatomic, strong) NSString *region;     //区

@property (nonatomic, strong) NSString *community;  //街道、企业、学校名
@property (nonatomic, strong) NSString *street;     //街道（详细地址）

@property (nonatomic, strong) NSString *mobile;     //手机
@property (nonatomic, strong) NSString *phone;      //固话

@property (nonatomic, strong) NSString *zipCode;    //邮编
@property (nonatomic, strong) NSString *userId;

@property (nonatomic, assign) double latitude;      //纬度
@property (nonatomic, assign) double longitude;     //经度

@property (nonatomic, assign) NSUInteger mId;

@property (nonatomic, assign) BOOL isDefault;
@property (nonatomic, assign) BOOL isFemale;


- (instancetype)initWithParsData:(NSDictionary *)dict;

@end
