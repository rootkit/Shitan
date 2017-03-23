//
//  ShopInfo.h
//  Shitan
//
//  Created by 刘敏 on 15/1/22.
//  Copyright (c) 2015年 深圳食探网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopInfo : NSObject

@property (nonatomic, strong) NSString *address;          //详细地址
@property (nonatomic, strong) NSString *addressId;        //地址ID
@property (nonatomic, strong) NSString *addressName;      //地址名称
@property (nonatomic, strong) NSString *addressSource;    //地点来源
@property (nonatomic, strong) NSString *avgPrice;         //均价
@property (nonatomic, strong) NSString *branchName;       //分支机构名
@property (nonatomic, strong) NSString *businessId;       //商户ID

@property (nonatomic, strong) NSString *categories;       //类别
@property (nonatomic, strong) NSString *city;             //城市
@property (nonatomic, strong) NSString *region;           //地区

@property (nonatomic, strong) NSString *geoHash;

@property (nonatomic, strong) NSString *phone;            //电话

@property (nonatomic, strong) NSString *longitude;        //经度
@property (nonatomic, strong) NSString *latitude;         //纬度

@property (nonatomic, strong) NSString *otherInfo;
@property (nonatomic, strong) NSString *businessTime;     //营业时间
@property (nonatomic, strong) NSString *distance;         //距离

@property (nonatomic, assign) int dealFlag;           //团购标识

- (instancetype)initWithParsData:(NSDictionary *)dict;

@end
