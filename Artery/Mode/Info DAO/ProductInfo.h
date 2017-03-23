//
//  ProductInfo.h
//  Shitan
//
//  Created by Richard Liu on 15/6/3.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductInfo : NSObject

@property (nonatomic, strong) NSString *businessId;
@property (nonatomic, strong) NSString *cateId;
@property (nonatomic, strong) NSString *productId;

@property (nonatomic, strong) NSString *name;               //名字
@property (nonatomic, strong) NSString *des;                //描述

@property (nonatomic, assign) NSUInteger buyCount;
@property (nonatomic, assign) NSUInteger sellCount;         //已售个数
@property (nonatomic, assign) NSUInteger totalCount;        //库存个数

@property (nonatomic, strong) NSString *h5Url;              //商品详情html5

@property (nonatomic, strong) NSString *orPrice;            //原价
@property (nonatomic, assign) BOOL hasRules;                //是否有规格

@property (nonatomic, strong) NSArray *imgArray;            //图片数组

@property (nonatomic, assign) BOOL isMeal;

@property (nonatomic, strong) NSString *price;              //价格（打折之后）


- (instancetype)initWithParsData:(NSDictionary *)dict;

@end
