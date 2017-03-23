//
//  PlaceInfo.h
//  Shitan
//
//  Created by 刘敏 on 14-9-26.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//  大众点评附近商铺的Model

#import <Foundation/Foundation.h>

@interface PlaceInfo : NSObject

@property (nonatomic, assign) NSInteger mId;

@property (nonatomic, strong) NSString *address;                //详细地址
@property (nonatomic, strong) NSString *addressId;              //标签ID （后台生成）
@property (nonatomic, strong) NSString *addressName;            //地点名称
@property (nonatomic, strong) NSString *branchName;             //分店名称
@property (nonatomic, strong) NSString *addressSource;          //地址来源（大众点评、系统后台）
@property (nonatomic, strong) NSString *businessId;             //商户号
@property (nonatomic, strong) NSString *city;                   //城市

@property (nonatomic, strong) NSString *geoHash;
@property (nonatomic, strong) NSString *latitude;               //纬度
@property (nonatomic, strong) NSString *longitude;              //经度
@property (nonatomic, strong) NSString *phone;

@property (nonatomic, strong) NSString *region;                 //地区


- (instancetype)initWithParsData:(NSDictionary *)dict;

@end
