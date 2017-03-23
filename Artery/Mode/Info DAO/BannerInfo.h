//
//  BannerInfo.h
//  Shitan
//
//  Created by Richard Liu on 15/4/27.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BannerInfo : NSObject

@property (nonatomic, assign) NSUInteger applyCount;

@property (nonatomic, strong) NSString *bannerImgUrl;   //专题Banner图片的Url
@property (nonatomic, strong) NSString *coverImgUrl;    //专题封面的图片url
@property (nonatomic, strong) NSString *topImgUrl;      //专题详情页顶部图片url

@property (nonatomic, strong) NSString *h5Url;

@property (nonatomic, strong) NSString *beginTime;
@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, strong) NSString *createTime;

@property (nonatomic, strong) NSString *cityId;

@property (nonatomic, assign) NSUInteger commentCount;  //评论人数
@property (nonatomic, strong) NSString *des;           //描述

@property (nonatomic, assign) NSUInteger mid;
@property (nonatomic, assign) BOOL isBanner;

@property (nonatomic, assign) NSUInteger maxApply;
@property (nonatomic, assign) NSUInteger showCount;     //展示次数
@property (nonatomic, assign) NSUInteger sort;          //排序


@property (nonatomic, strong) NSString *specialId;
@property (nonatomic, assign) NSUInteger specialType;


@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) NSUInteger successCount;
@property (nonatomic, strong) NSString *updateTime;

@property (nonatomic, assign) NSUInteger state;


@property (nonatomic, strong) NSString *shareTitle;
@property (nonatomic, strong) NSString *shareImgUrl;
@property (nonatomic, strong) NSString *shareDesc;


@property (nonatomic, strong) NSString *mTag;          //专题标签

@property (nonatomic, assign) NSInteger leftTime;


- (instancetype)initWithParsData:(NSDictionary *)dict;

@end
