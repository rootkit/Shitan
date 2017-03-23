//
//  ShopDetailsInfo.h
//  Shitan
//
//  Created by RichardLiu on 15/3/2.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopDetailsInfo : NSObject

@property (nonatomic, strong) NSString *address;          //详细地址
@property (nonatomic, strong) NSString *addressId;        //地址ID
@property (nonatomic, strong) NSString *addressName;      //地址名称
@property (nonatomic, strong) NSString *branchName;       //分支机构名

@property (nonatomic, strong) NSString *coverImgId;       //封面ID
@property (nonatomic, strong) NSString *imgUrl;           //图片URL

@property (nonatomic, assign) NSUInteger imgHeight;
@property (nonatomic, assign) NSUInteger imgWidth;

@property (nonatomic, assign) BOOL isEdited;

@property (nonatomic, strong) NSString *longitude;        //经度
@property (nonatomic, strong) NSString *latitude;         //纬度

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *nameId;

@property (nonatomic, assign) CGFloat score;

- (instancetype)initWithParsData:(NSDictionary *)dict;

@end
