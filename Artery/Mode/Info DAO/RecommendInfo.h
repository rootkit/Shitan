//
//  RecommendInfo.h
//  Shitan
//
//  Created by Richard Liu on 15/8/12.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecommendInfo : NSObject

@property (nonatomic , strong) NSString              * des;
@property (nonatomic , strong) NSString              * coverUrl;
@property (nonatomic , strong) NSNumber              * lowestMoney;
@property (nonatomic , strong) NSString              * nickName;
@property (nonatomic , strong) NSString              * title;
@property (nonatomic , strong) NSString              * address;
@property (nonatomic , strong) NSString              * deliveryNote;
@property (nonatomic , strong) NSString              * street;
@property (nonatomic , strong) NSString              * businessId;
@property (nonatomic , strong) NSNumber              * deliveryMoney;
@property (nonatomic , strong) NSString              * logoUrl;
@property (nonatomic , strong) NSString              * endTime;
@property (nonatomic , strong) NSNumber              * avgPrice;
@property (nonatomic , strong) NSString              * name;
@property (nonatomic , strong) NSString              * city;
@property (nonatomic , strong) NSString              * latitude;
@property (nonatomic , assign) NSUInteger              state;
@property (nonatomic , strong) NSString              * community;

@property (nonatomic , strong) NSString              * tips;
@property (nonatomic , strong) NSString              * cityId;
@property (nonatomic , strong) NSString              * longitude;
@property (nonatomic , strong) NSString              * phone;
@property (nonatomic , strong) NSNumber              * distance;
@property (nonatomic , strong) NSString              * addressId;
@property (nonatomic , strong) NSArray               * imgArray;
@property (nonatomic , assign) NSUInteger            favoriteCount;
@property (nonatomic , strong) NSString              * businessTime;
@property (nonatomic , strong) NSString              * createTime;
@property (nonatomic , strong) NSString              * beginTime;

@property (nonatomic , assign) NSUInteger           browse;

@property (nonatomic, assign) BOOL isFavorited;


- (instancetype)initWithParsData:(NSDictionary *)dict;

@end
