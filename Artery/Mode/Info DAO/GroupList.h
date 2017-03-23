//
//  GroupList.h
//  Shitan
//
//  Created by Avalon on 15/5/28.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupList : NSObject

//消费记录的ID
@property (nonatomic, copy) NSString *recordId;
//团购标题
@property (nonatomic, copy) NSString *title;
//团购描述
@property (nonatomic, copy) NSString *groupDescription;
//团购数量
@property (nonatomic, assign) int count;
//团购返利，只有state=4时才有
@property (nonatomic, assign) float back;
//交易状态，1:用户下单，2:用户付费，3:退款，4:验券
@property (nonatomic, assign) int state;
//城市
@property (nonatomic, copy) NSString *city;
//图片URL
@property (nonatomic, copy) NSString *imageUrl;
//创建时间
@property (nonatomic, copy) NSString *createTime;
//用户Id
@property (nonatomic, copy) NSString *userId;
//团购Id
@property (nonatomic, copy) NSString *dealId;
//团购单价
@property (nonatomic, assign) float currentPrice;
//团购发布时间  格式为 yyyy-MM-dd
@property (nonatomic, copy) NSString *publishDate;
//佣金比例
@property (nonatomic, assign) float commissionRatio;
//更新时间
@property (nonatomic, copy) NSString *updateTime;

@property (nonatomic, copy) NSString *h5url;


- (instancetype)initWithParsData:(NSDictionary *)dict;


@end
