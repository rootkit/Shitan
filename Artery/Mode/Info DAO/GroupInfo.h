//
//  GroupInfo.h
//  Shitan
//
//  Created by Richard Liu on 15/5/21.
//  Copyright (c) 2015年 刘 敏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupInfo : NSObject

@property (nonatomic, strong) NSString *deal_id;        //团购单ID
@property (nonatomic, strong) NSString *title;          //团购标题
@property (nonatomic, strong) NSString *des;            //团购描述
@property (nonatomic, strong) NSString *city;           //城市名称，city为＂全国＂表示全国单，其他为本地单，城市范围见相关API返回结果

@property (nonatomic, assign) CGFloat list_price;       //团购包含商品原价值
@property (nonatomic, assign) CGFloat current_price;	//团购价格

@property (nonatomic, assign) NSUInteger purchase_count;//团购当前已购买数
@property (nonatomic, strong) NSString *publish_date;	//团购发布上线日期
@property (nonatomic, strong) NSString *details;        //团购详情

@property (nonatomic, strong) NSString *purchase_deadline;  //团购单的截止购买日期
@property (nonatomic, strong) NSString *image_url;          //团购图片链接，最大图片尺寸450×280
@property (nonatomic, strong) NSString *s_image_url;        //小尺寸团购图片链接，最大图片尺寸160×100



@property (nonatomic, assign) NSUInteger isAppointmentis;	//是否需要预约，0：不是，1：是
@property (nonatomic, assign) NSUInteger isRefundable;      //是否支持随时退款，0：不是，1：是
@property (nonatomic, strong) NSString *special_tips;       //特别说明
@property (nonatomic, strong) NSString *notice;             //重要通知(一般为团购信息的临时变更)
@property (nonatomic, strong) NSString *deal_url;           //团购Web页面链接，适用于网页应用
@property (nonatomic, strong) NSString *deal_h5_url;        //团购HTML5页面链接，适用于移动应用和联网车载应用

@property (nonatomic, strong) NSString *businessesName;     //商户名
@property (nonatomic, strong) NSString *businessesId;

@property (nonatomic, strong) NSString *latitude;           //商户纬度
@property (nonatomic, strong) NSString *longitude;          //商户经度

@property (nonatomic, strong) NSString *address;            //商户地址
@property (nonatomic, strong) NSString *url;                //商户页链接


- (instancetype)initWithParsData:(NSDictionary *)dict;

@end
